//
//  CatalogSymbolColorSettingView.swift
//  SFSymbolsArtCreator
//
//

import ComposableArchitecture
import SwiftUI

struct CatalogSymbolColorSettingFeature: Reducer {
    
    struct State: Equatable {
        @PresentationState var colorPicker: ColorPickerFeature.State?

        var renderingType: RenderingType
        var primaryColor: Color
        var secondaryColor: Color
        var tertiaryColor: Color
        
        // Rect for a arrow of pop over
        var attachmentAnchorRect: CGRect {
            
            var width: CGFloat = 0
            
            if let colorPicker {
                switch colorPicker.colorType {
                case .canvas:
                    break
                case .primary:
                    width = 44
                case .secondary:
                    width = 96
                case .tertiary:
                    width = 156
                }
            }
            return CGRect(x: 0, y: 0, width: width, height: -8)
        }
        
        var isOnlyPrimaryColorEnabled: Bool {
            return renderingType != .palette
        }
    }
    
    enum Action: Equatable {
        case colorPicker(PresentationAction<ColorPickerFeature.Action>)
        case delegate(Delegate)
        case primaryColorButtonTapped
        case secondaryColorButtonTapped
        case renderingTypeSelected(RenderingType)
        case tertiaryColorButtonTapped
        
        enum Delegate: Equatable {
            case changePrimaryColor(Color)
            case changeSecondaryColor(Color)
            case changeTertiaryColor(Color)
            case renderingTypeSelected(RenderingType)
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case let .colorPicker(.presented(.delegate(.selectColor(type, color)))):
                
                switch type {
                case .canvas:
                    break
                case .primary:
                    state.primaryColor = color
                case .secondary:
                    state.secondaryColor = color
                case .tertiary:
                    state.tertiaryColor = color
                }
                
                return .run { send in
                    switch type {
                    case .canvas:
                        break
                    case .primary:
                        await send(.delegate(.changePrimaryColor(color)))
                    case .secondary:
                        await send(.delegate(.changeSecondaryColor(color)))
                    case .tertiary:
                        await send(.delegate(.changeTertiaryColor(color)))
                    }
                }
                
            case .colorPicker:
                return .none
                
            case .delegate:
                return .none
                
            case .primaryColorButtonTapped:
                state.colorPicker = .init(colorType: .primary,
                                          selectedColor: state.primaryColor)
                return .none
            case .secondaryColorButtonTapped:
                state.colorPicker = .init(colorType: .secondary,
                                          selectedColor: state.secondaryColor)
                return .none
            
            case let .renderingTypeSelected(renderingType):
                state.renderingType = renderingType
                
                switch renderingType {
                    
                case .hierarchical, .monochrome, .multiColor:
                    state.secondaryColor = .clear
                    state.tertiaryColor = .clear
               
                case .palette:
                    state.secondaryColor = .accentColor
                    state.tertiaryColor = .white
                }
                
                return .run { send in
                    await send(.delegate(.renderingTypeSelected(renderingType)))
                }
                
            case .tertiaryColorButtonTapped:
                state.colorPicker = .init(colorType: .tertiary,
                                          selectedColor: state.tertiaryColor)
                return .none
            }
        }
        .ifLet(\.$colorPicker, action: /Action.colorPicker) {
            ColorPickerFeature()
        }
    }
}

struct CatalogSymbolColorSettingView: View {
    
    let store: StoreOf<CatalogSymbolColorSettingFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            
            AccordionSettingView(title: "Foreground") {
                
                VStack(spacing: 16) {
                    
                    RenderingMenuButton(type: viewStore.renderingType) { renderingType in
                        viewStore.send(.renderingTypeSelected(renderingType))
                    }
                    .bold()
                    .frame(height: 44)
                    .padding(.trailing)
                    .padding(.top)
                    
                    Divider()
                        .background(.gray)
                    
                    HStack(spacing: 16) {
                        ColorPickCircleButton(
                            color: viewStore.primaryColor,
                            isDisabled: false
                        ) {
                            viewStore.send(.primaryColorButtonTapped)
                        }
                        .frame(width: 44, height: 44)
                        
                        ColorPickCircleButton(
                            color: viewStore.secondaryColor,
                            isDisabled: viewStore.isOnlyPrimaryColorEnabled
                        ) {
                            viewStore.send(.secondaryColorButtonTapped)
                        }
                        .frame(width: 44, height: 44)
                        
                        ColorPickCircleButton(
                            color: viewStore.tertiaryColor,
                            isDisabled: viewStore.isOnlyPrimaryColorEnabled
                        ) {
                            viewStore.send(.tertiaryColorButtonTapped)
                        }
                        .frame(width: 44, height: 44)
                        
                        Spacer()
                    }
                    .padding(.trailing)
                    .popover(store: store.scope(
                        state: \.$colorPicker,
                        action: CatalogSymbolColorSettingFeature.Action.colorPicker),
                             attachmentAnchor: .rect(.rect(viewStore.attachmentAnchorRect)),
                             arrowEdge: .top) {
                        ColorPickerView(store: $0)
                            .preferredColorScheme(.dark)
                    }
                }
                .padding(.bottom)
            }
        }
    }
}

#Preview {
    Color.heavyDarkGray
        .overlay {
            CatalogSymbolColorSettingView(store: .init(
                initialState: CatalogSymbolColorSettingFeature.State(
                    renderingType: .monochrome,
                    primaryColor: .black,
                    secondaryColor: .accentColor,
                    tertiaryColor: .white)) {
                        CatalogSymbolColorSettingFeature()
                    }
            )
            .frame(width: 284, height: 500)
        }
}
