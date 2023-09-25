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
        @BindingState var backgroundColor: Color
        @BindingState var category: SFSymbols.Category
        @BindingState var symbolWeight: Font.Weight
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
                CatalogBackgroundColorSettingView(color: viewStore.$backgroundColor)
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
                    backgroundColor: .white,
                    category: .all,
                    symbolWeight: .regular
                ), reducer: {
                    CatalogSettingsFeature()
                })
            )
            .frame(width: 284)
            .background(.heavyDarkGray)
        }
}
