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
        var catalogItemListState: CatalogItemListFeature.State
        var catalogSettingsState: CatalogSettingsFeature.State
        
        init() {
            let defaultBackgroundColor: Color = .white
            let defaultCategory: SFSymbols.Category = .all
            let defaultFontWeight: Font.Weight = .regular
            
            catalogSettingsState = .init(
                backgroundColor: defaultBackgroundColor,
                category: defaultCategory,
                symbolWeight: defaultFontWeight
            )
            
            catalogItemListState = .init(
                fontWeight: defaultFontWeight,
                primaryColor: .black,
                secondaryColor: .black,
                tertiaryColor: .clear,
                renderingType: .monochrome,
                backgroundColor: defaultBackgroundColor,
                category: defaultCategory)
        }
    }
    
    enum Action: Equatable {
        case catalogItemList(CatalogItemListFeature.Action)
        case catalogSettings(CatalogSettingsFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.catalogItemListState, action: /Action.catalogItemList) {
            CatalogItemListFeature()
        }
        Scope(state: \.catalogSettingsState, action: /Action.catalogSettings) {
            CatalogSettingsFeature()
        }
        Reduce { state, action in
            switch action {
            case let .catalogItemList(.symbolTapped(symbol)):
                // TODO: アートシンボル配列に追加
                print("Selected Symbol", symbol)
                return .none
            case .catalogItemList:
                return .none
            case .catalogSettings(.binding(\.$backgroundColor)):
                state.catalogItemListState.backgroundColor = state.catalogSettingsState.backgroundColor
                return .none
            case .catalogSettings(.binding(\.$category)):
                state.catalogItemListState.category = state.catalogSettingsState.category
                return .none
            case .catalogSettings(.binding(\.$symbolWeight)):
                state.catalogItemListState.fontWeight = state.catalogSettingsState.symbolWeight
                return .none
            case .catalogSettings:
                return .none
            }
        }
    }
}

struct SymbolCatalogView: View {
    
    let store: StoreOf<SymbolCatalogFeature>
    
    var body: some View {
        
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(spacing: 16) {
                CatalogSettingsView(store: store.scope(
                    state: \.catalogSettingsState,
                    action: SymbolCatalogFeature.Action.catalogSettings)
                )
                
                CatalogItemListView(store: store.scope(
                    state: \.catalogItemListState,
                    action: SymbolCatalogFeature.Action.catalogItemList)
                )
            }
            .frame(width: 284)
            .background(.heavyDarkGray)
        }
    }
}

#Preview {
    Color.black
        .overlay {
            SymbolCatalogView(store: .init(
                initialState: SymbolCatalogFeature.State()) {
                    SymbolCatalogFeature()
                }
            )
        }
}
