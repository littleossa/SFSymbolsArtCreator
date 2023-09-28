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
            let defaultCatalogBackgroundColorItem: ColorItem = .white
            let defaultCategory: SFSymbols.Category = .all
            let defaultFontWeight: Font.Weight = .regular
            
            catalogSettingsState = .init(
                catalogBackgroundColorItem: defaultCatalogBackgroundColorItem,
                category: defaultCategory,
                symbolWeight: defaultFontWeight,
                currentCanvasColor: .white
            )
            
            catalogItemListState = .init(
                fontWeight: defaultFontWeight,
                primaryColor: .black,
                secondaryColor: .clear,
                tertiaryColor: .clear,
                renderingType: .monochrome,
                backgroundColor: defaultCatalogBackgroundColorItem.color,
                category: defaultCategory)
        }
    }
    
    enum Action: Equatable {
        case catalogItemList(CatalogItemListFeature.Action)
        case catalogSettings(CatalogSettingsFeature.Action)
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case selectSymbol(SFSymbols)
        }
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
                return .run { send in
                    await send(.delegate(.selectSymbol(symbol)))
                }
            case .catalogItemList:
                return .none
            case .catalogSettings(.binding(\.$catalogBackgroundColorItem)):
                state.catalogItemListState.backgroundColor = state.catalogSettingsState.catalogBackgroundColorItem.color
                return .none
            case .catalogSettings(.binding(\.$category)):
                state.catalogItemListState.category = state.catalogSettingsState.category
                return .none
            case .catalogSettings(.binding(\.$symbolWeight)):
                state.catalogItemListState.fontWeight = state.catalogSettingsState.symbolWeight
                return .none
            case .catalogSettings:
                return .none
            case .delegate:
                return .none
            }
        }
    }
}

struct SymbolCatalogView: View {
    
    let store: StoreOf<SymbolCatalogFeature>
    
    var body: some View {
        
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
