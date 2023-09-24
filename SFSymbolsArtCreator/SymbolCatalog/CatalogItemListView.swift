//
//  CatalogItemListView.swift
//  SFSymbolsArtCreator
//
//

import ComposableArchitecture
import SFUserFriendlySymbols
import SwiftUI

struct CatalogItemListFeature: Reducer {
    
    struct State: Equatable {
        let backgroundColor: Color
        let category: SFSymbols.Category
        let fontWeight: Font.Weight
        let primaryColor: Color
        let renderingType: RenderingType
        let secondaryColor: Color
        let tertiaryColor: Color
        
        var catalogItems: IdentifiedArrayOf<CatalogItemFeature.State>
        @BindingState var searchText = ""
        
        init(fontWeight: Font.Weight,
             primaryColor: Color,
             secondaryColor: Color,
             tertiaryColor: Color,
             renderingType: RenderingType,
             backgroundColor: Color,
             category: SFSymbols.Category = .all,
             searchText: String = "") {
            self.backgroundColor = backgroundColor
            self.category = category
            self.fontWeight = fontWeight
            
            let allItems = category.symbols.compactMap { symbol in
                CatalogItemFeature.State(
                    symbol: symbol,
                    weight: fontWeight,
                    primaryColor: primaryColor,
                    secondaryColor: secondaryColor,
                    tertiaryColor: tertiaryColor,
                    renderingType: renderingType,
                    backgroundColor: backgroundColor,
                    squareLength: 72
                )
            }
            self.catalogItems = IdentifiedArray(uniqueElements: allItems)
            self.searchText = searchText
            self.primaryColor = primaryColor
            self.renderingType = renderingType
            self.secondaryColor = secondaryColor
            self.tertiaryColor = tertiaryColor
        }
        
        var filterCatalogItems: IdentifiedArrayOf<CatalogItemFeature.State> {
            
            let filteredSymbols: [SFSymbols]
            if searchText.isEmpty {
                filteredSymbols = category.symbols
            } else {
                let lowerCasedText = searchText.lowercased()
                filteredSymbols = category.symbols.filter { $0.rawValue.contains(lowerCasedText) }
            }
            
            if filteredSymbols.isEmpty {
                return []
            } else {
                let filteredItems = filteredSymbols.compactMap { symbol in
                    CatalogItemFeature.State(
                        symbol: symbol,
                        weight: fontWeight,
                        primaryColor: primaryColor,
                        secondaryColor: secondaryColor,
                        tertiaryColor: tertiaryColor,
                        renderingType: renderingType,
                        backgroundColor: backgroundColor,
                        squareLength: 72
                    )
                }
                return IdentifiedArray(uniqueElements: filteredItems)
            }
        }
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case catalogItem(id: CatalogItemFeature.State.ID, action: CatalogItemFeature.Action)
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case selectSymbol(SFSymbols)
        }
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
                
            case .binding:
                return .none
            case let .catalogItem(id: _, action: .delegate(.selectSymbol(symbol))):
                return .run { send in
                    await send(.delegate(.selectSymbol(symbol)))
                }
            case .catalogItem:
                return .none
            case let .delegate(.selectSymbol(symbol)):
                // TODO: symbolを選択された時の処理
                print("select", symbol)
                return .none
            case .delegate:
                return .none
            }
        }
        .forEach(\.catalogItems, action: /Action.catalogItem(id:action:)) {
            CatalogItemFeature()
        }
    }
}

struct CatalogItemListView: View {
    
    private let columns: [GridItem] = .init(repeating: .init(spacing: 8), count: 3)
    
    let store: StoreOf<CatalogItemListFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            
            VStack(spacing: 16) {
                
                SearchBar(text: viewStore.$searchText)
                
                ScrollView {
                    
                    LazyVGrid(columns: columns) {
                        
                        ForEachStore(
                            self.store.scope(state: \.filterCatalogItems,
                                             action: CatalogItemListFeature.Action.catalogItem(id:action:))
                        ) {
                            CatalogItemView(store: $0)
                        }
                    }
                }
            }
            .padding(.horizontal)
            .background(.heavyDarkGray)
        }
        .frame(width: 284)
    }
}

#Preview {
    
    HStack {
        
        ZStack {
            Color(uiColor: .darkGray)
                .frame(width: 284)
            
            CatalogItemListView(store: .init(
                initialState: CatalogItemListFeature.State(
                    fontWeight: .regular,
                    primaryColor: .black,
                    secondaryColor: .accentColor,
                    tertiaryColor: .black,
                    renderingType: .monochrome,
                    backgroundColor: .white
                )
            ) {
                CatalogItemListFeature()
                    ._printChanges()
            })
        }
        Spacer()
    }
}
