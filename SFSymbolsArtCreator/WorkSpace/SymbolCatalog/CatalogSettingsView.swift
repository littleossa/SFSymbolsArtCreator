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
        var currentCanvasColor: Color
    }
    
    enum Action: BindableAction, Equatable {        
        case binding(BindingAction<State>)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
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
                    currentCanvasColor: .white
                ), reducer: {
                    CatalogSettingsFeature()
                })
            )
            .frame(width: 284)
            .background(.heavyDarkGray)
        }
}
