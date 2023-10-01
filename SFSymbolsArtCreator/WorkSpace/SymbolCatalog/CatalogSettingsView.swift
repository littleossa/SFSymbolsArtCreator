//
//  CatalogSettingView.swift
//  SFSymbolsArtCreator
//
//

import ComposableArchitecture
import SFUserFriendlySymbols
import SwiftUI

struct CatalogSettingsFeature: Reducer {
    struct State: Equatable {
        @BindingState var catalogBackgroundColorItem: ColorItem
        @BindingState var category: SFSymbols.Category
        @BindingState var symbolWeight: Font.Weight
        var catalogSymbolColorSettingState: CatalogSymbolColorSettingFeature.State
        var currentCanvasColor: Color
    }
    
    enum Action: BindableAction, Equatable {        
        case binding(BindingAction<State>)
        case catalogSymbolColorSetting(CatalogSymbolColorSettingFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Scope(state: \.catalogSymbolColorSettingState,
              action: /Action.catalogSymbolColorSetting) {
            CatalogSymbolColorSettingFeature()
        }
    }
}

struct CatalogSettingsView: View {
    
    let store: StoreOf<CatalogSettingsFeature>
    
    var body: some View {
        
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                CategorySettingView(selectedCategory: viewStore.$category)
                SymbolWeightSettingView(weight: viewStore.$symbolWeight)
                CatalogBackgroundColorSettingView(
                    backgroundColorItem: viewStore.$catalogBackgroundColorItem,
                    canvasColor: viewStore.currentCanvasColor
                )
                CatalogSymbolColorSettingView(store: store.scope(
                    state: \.catalogSymbolColorSettingState,
                    action: CatalogSettingsFeature.Action.catalogSymbolColorSetting)
                )
            }
            .padding(.leading)
        }
    }
}

#Preview {
    Color.black
        .overlay {
            CatalogSettingsView(store: .init(
                initialState: CatalogSettingsFeature.State(
                    catalogBackgroundColorItem: .white,
                    category: .all,
                    symbolWeight: .regular,
                    catalogSymbolColorSettingState: .init(renderingType: .monochrome,
                                                          primaryColor: .white,
                                                          secondaryColor: .accentColor,
                                                          tertiaryColor: .white),
                    currentCanvasColor: .white
                ), reducer: {
                    CatalogSettingsFeature()
                })
            )
            .frame(width: 284)
            .background(.heavyDarkGray)
        }
}
