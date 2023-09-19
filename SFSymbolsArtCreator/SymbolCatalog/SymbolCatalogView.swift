//
//  SymbolCatalogView.swift
//  SFSymbolsArtCreator
//
//

import ComposableArchitecture
import SFUserFriendlySymbols
import SwiftUI

struct SymbolCatalogFeature: Reducer {
    
    struct State: Equatable {
        var backgroundCanvasColor: Color
        var category: SFSymbols.Category = .all
        @BindingState var searchText = ""
        
        var currentSymbols: [SFSymbols] {
            if searchText.isEmpty {
                return category.symbols
            }
            let lowerCasedText = searchText.lowercased()
            return category.symbols.filter { $0.rawValue.contains(lowerCasedText) }
        }
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case delegate(Delegate)
        case selectCategory(SFSymbols.Category)
        case selectSymbol(SFSymbols)
        
        enum Delegate: Equatable {
            case selectSymbol(SFSymbols)
        }
    }
    
    var body: some ReducerOf<Self> {
        
        Reduce { state, action in
            switch action {
                
            case .binding :
                return .none
            case .delegate:
                return .none
            case let .selectCategory(category):
                state.category = category
                return .none
            case let .selectSymbol(symbol):
                return .run { send in
                    await send(.delegate(.selectSymbol(symbol)))
                }
            }
        }
        BindingReducer()
    }
}

struct SymbolCatalogView: View {
    
    private let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    let store: StoreOf<SymbolCatalogFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            
            NavigationStack {
                VStack {
                                        
                    // TODO: Select Category
                    
                    ScrollView {
                        
                        LazyVGrid(columns: columns) {
                            ForEach(viewStore.currentSymbols, id: \.self) {
                                // TODO: Catalog Item View
                                Text($0.rawValue)
                            }
                        }
                    }
                }
            }
            .searchable(text: viewStore.$searchText)
        }
    }
}

#Preview {
    SymbolCatalogView(store: .init(
        initialState: SymbolCatalogFeature.State(
            backgroundCanvasColor: .white
        )
    ) {
        SymbolCatalogFeature()
            ._printChanges()
    })
}
