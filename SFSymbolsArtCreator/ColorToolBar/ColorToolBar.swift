//
//  ColorToolBar.swift
//  SFSymbolsArtCreator
//
//

import ComposableArchitecture
import SwiftUI

struct ColorToolFeature: Reducer {
    
    struct State: Equatable {
        let renderingType: RenderingType
        
        @PresentationState var colorPicker: ColorPickerFeature.State?
        var canvasColor: Color = .white
        var primaryColor: Color = .black
        var secondaryColor: Color = .clear
        var tertiaryColor: Color = .clear
        
        // Rect for a arrow of pop over
        var attachmentAnchorRect: CGRect {
            
            var height: CGFloat = 0
            
            if let colorPicker {
                switch colorPicker.colorType {
                case .canvas:
                    height = 488
                case .primary:
                    height = 30
                case .secondary:
                    height = 90
                case .tertiary:
                    height = 148
                }
            }
            return CGRect(x: 0, y: 0, width: 60, height: height)
        }
        
        var isOnlyPrimaryColorEnabled: Bool {
            return renderingType != .multiColor
        }
    }
    
    enum Action: Equatable {
        case canvasColorButtonTapped
        case colorPicker(PresentationAction<ColorPickerFeature.Action>)
        case primaryColorButtonTapped
        case secondaryColorButtonTapped
        case tertiaryColorButtonTapped
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
                return .none
                
            case .colorPicker:
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
                     attachmentAnchor: .rect(.rect(viewStore.attachmentAnchorRect)),
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
                initialState: ColorToolFeature.State(renderingType: .monochrome)
            ) {
                ColorToolFeature()
            })
            
            ColorToolBar(store: .init(
                initialState: ColorToolFeature.State(renderingType: .multiColor)
            ) {
                ColorToolFeature()
            })
        }
    }
}
