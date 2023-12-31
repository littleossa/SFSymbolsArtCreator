//
//  ColorToolBar.swift
//  SFSymbolsArtCreator
//
//

import ComposableArchitecture
import SwiftUI

struct ColorToolFeature: Reducer {
    
    struct State: Equatable {
        @PresentationState var colorPicker: ColorPickerFeature.State?

        var renderingType: RenderingType
        var canvasColor: Color
        var primaryColor: Color
        var secondaryColor: Color
        var tertiaryColor: Color
        
        var isOnlyPrimaryColorEnabled: Bool {
            return renderingType != .palette
        }
    }
    
    enum Action: Equatable {
        case canvasColorButtonTapped
        case colorPicker(PresentationAction<ColorPickerFeature.Action>)
        case delegate(Delegate)
        case primaryColorButtonTapped
        case secondaryColorButtonTapped
        case tertiaryColorButtonTapped
        
        enum Delegate: Equatable {
            case canvasColorChanged(Color)
            case primaryColorChanged(Color)
            case secondaryColorChanged(Color)
            case tertiaryColorChanged(Color)
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .canvasColorButtonTapped:
                state.colorPicker = .init(colorType: .canvas,
                                          selectedColor: state.canvasColor)
                return .none
                
            case let .colorPicker(.presented(.delegate(.selectColor(type, color)))):
                
                switch type {
                case .canvas:
                    state.canvasColor = color
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
                        await send(.delegate(.canvasColorChanged(color)))
                    case .primary:
                        await send(.delegate(.primaryColorChanged(color)))
                    case .secondary:
                        await send(.delegate(.secondaryColorChanged(color)))
                    case .tertiary:
                        await send(.delegate(.tertiaryColorChanged(color)))
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

struct ColorToolBar: View {
    
    let store: StoreOf<ColorToolFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                
                Spacer()
                    .frame(height: 8)
                
                VStack(spacing: 16) {
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
                }
                
                Divider()
                    .frame(height: 1)
                    .background(.gray)
                    .padding(.vertical)
                    .padding(.horizontal, 8)
                
                ColorPickRectangleButton(color: viewStore.canvasColor) {
                    viewStore.send(.canvasColorButtonTapped)
                }
                .frame(width: 44, height: 44)
                
                Spacer()
            }
            .frame(width: 72)
            .background(.heavyDarkGray)
            .popover(store: store.scope(
                state: \.$colorPicker,
                action: ColorToolFeature.Action.colorPicker),
                     arrowEdge: .top) {
                ColorPickerView(store: $0)
                    .preferredColorScheme(.dark)
            }
        }
    }
}

#Preview {
    Color.black.overlay {
        
        HStack {
            ColorToolBar(store: .init(
                initialState: ColorToolFeature.State(
                    renderingType: .monochrome,
                    canvasColor: .white,
                    primaryColor: .black,
                    secondaryColor: .accentColor,
                    tertiaryColor: .white)
            ) {
                ColorToolFeature()
            })
        }
    }
}
