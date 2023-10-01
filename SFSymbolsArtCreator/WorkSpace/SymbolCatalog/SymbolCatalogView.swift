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
        
        init(catalogBackgroundColorItem: ColorItem = .white,
             category: SFSymbols.Category = .all,
             fontWeight: Font.Weight = .regular,
             renderingType: RenderingType,
             primaryColor: Color,
             secondaryColor: Color,
             tertiaryColor: Color,
             canvasColor: Color
        ) {
            catalogSettingsState = .init(
                catalogBackgroundColorItem: catalogBackgroundColorItem,
                category: category,
                symbolWeight: fontWeight,
                catalogSymbolColorSettingState: .init(renderingType: renderingType,
                                                      primaryColor: primaryColor,
                                                      secondaryColor: secondaryColor,
                                                      tertiaryColor: tertiaryColor),
                currentCanvasColor: canvasColor
            )
            
            catalogItemListState = .init(
                fontWeight: fontWeight,
                primaryColor: primaryColor,
                secondaryColor: secondaryColor,
                tertiaryColor: tertiaryColor,
                renderingType: renderingType,
                backgroundColor: catalogBackgroundColorItem.color,
                category: category)
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
            case .catalogItemList:
                return .none
                
            case .catalogSettings(.binding(\.$catalogBackgroundColorItem)):
                state.catalogItemListState.backgroundColor = state.catalogSettingsState.catalogBackgroundColorItem.color
                return .none
                
            case .catalogSettings(.binding(\.$category)):
                state.catalogItemListState.category = state.catalogSettingsState.category
                return .none
                
            case let  .catalogSettings(.catalogSymbolColorSetting(.delegate(.primaryColorChanged(color)))):
                state.catalogItemListState.primaryColor = color
                return .none
                
            case let  .catalogSettings(.catalogSymbolColorSetting(.delegate(.secondaryColorChanged(color)))):
                state.catalogItemListState.secondaryColor = color
                return .none
                
            case let  .catalogSettings(.catalogSymbolColorSetting(.delegate(.tertiaryColorChanged(color)))):
                state.catalogItemListState.tertiaryColor = color
                return .none
                
            case let .catalogSettings(.catalogSymbolColorSetting(.delegate(.renderingTypeSelected(renderingType)))):
                state.catalogItemListState.renderingType = renderingType
                
                switch renderingType {
                    
                case .hierarchical, .monochrome, .multiColor:
                    state.catalogItemListState.secondaryColor = .clear
                    state.catalogItemListState.tertiaryColor = .clear
                    state.catalogSettingsState.catalogSymbolColorSettingState.secondaryColor = .clear
                    state.catalogSettingsState.catalogSymbolColorSettingState.tertiaryColor = .clear
               
                case .palette:
                    state.catalogItemListState.secondaryColor = .accentColor
                    state.catalogItemListState.tertiaryColor = .white
                    state.catalogSettingsState.catalogSymbolColorSettingState.secondaryColor = .accentColor
                    state.catalogSettingsState.catalogSymbolColorSettingState.tertiaryColor = .white
                }
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
                initialState: SymbolCatalogFeature.State(
                    renderingType: .monochrome,
                    primaryColor: .black,
                    secondaryColor: .accentColor,
                    tertiaryColor: .white,
                    canvasColor: .white)
            ) {
                SymbolCatalogFeature()
            })
        }
}
