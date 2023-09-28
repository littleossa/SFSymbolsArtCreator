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
        var backgroundColor: Color
        var category: SFSymbols.Category
        var fontWeight: Font.Weight
        let primaryColor: Color
        let renderingType: RenderingType
        let secondaryColor: Color
        @BindingState var searchText = ""
        let tertiaryColor: Color
        
        init(fontWeight: Font.Weight,
             primaryColor: Color,
             secondaryColor: Color,
             tertiaryColor: Color,
             renderingType: RenderingType,
             backgroundColor: Color,
             category: SFSymbols.Category,
             searchText: String = "") {
            self.backgroundColor = backgroundColor
            self.category = category
            self.fontWeight = fontWeight
            self.searchText = searchText
            self.primaryColor = primaryColor
            self.renderingType = renderingType
            self.secondaryColor = secondaryColor
            self.tertiaryColor = tertiaryColor
        }
        
        var catalogItems: [SFSymbols] {
            
            let filteredSymbols: [SFSymbols]
            if searchText.isEmpty {
                filteredSymbols = category.symbols
            } else {
                let lowerCasedText = searchText.lowercased()
                filteredSymbols = category.symbols.filter { $0.rawValue.contains(lowerCasedText) }
            }
            return filteredSymbols
        }
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case symbolTapped(SFSymbols)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
                
            case .binding:
                return .none
            case .symbolTapped:
                return .none
            }
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
                        
                        ForEach(viewStore.catalogItems, id: \.self) { symbol in
                            CatalogItemView(symbol: symbol,
                                            weight: viewStore.fontWeight,
                                            primaryColor: viewStore.primaryColor,
                                            secondaryColor: viewStore.secondaryColor,
                                            tertiaryColor: viewStore.tertiaryColor,
                                            renderingType: viewStore.renderingType,
                                            backgroundColor: viewStore.backgroundColor,
                                            squareLength: 72) {
                                viewStore.send(.symbolTapped(symbol))
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    
    Color.black
        .overlay {
            
            HStack {
                
                CatalogItemListView(store: .init(
                    initialState: CatalogItemListFeature.State(
                        fontWeight: .regular,
                        primaryColor: .black,
                        secondaryColor: .accentColor,
                        tertiaryColor: .black,
                        renderingType: .monochrome,
                        backgroundColor: .white,
                        category: .all
                    )
                ) {
                    CatalogItemListFeature()
                        ._printChanges()
                })
                .frame(width: 284)
                .background(.heavyDarkGray)
                
                Spacer()
            }
        }
}
