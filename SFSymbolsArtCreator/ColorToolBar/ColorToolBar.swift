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
        var primaryColor: Color = .black
        var secondaryColor: Color = .clear
        var tertiaryColor: Color = .clear
        
        // Rect for a arrow of pop over
        var attachmentAnchorRect: CGRect {
            
            var height: CGFloat = 0
            
            if let colorPicker {
                switch colorPicker.colorType {
                case .primary:
                    height = 22
                case .secondary:
                    height = 82
                case .tertiary:
                    height = 140
                }
            }
            return CGRect(x: 0, y: 0, width: 44, height: height)
        }
    }
    
    enum Action: Equatable {
        case colorPicker(PresentationAction<ColorPickerFeature.Action>)
        case primaryColorButtonTapped
        case secondaryColorButtonTapped
        case tertiaryColorButtonTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .colorPicker(.presented(.delegate(.selectColor(type, color)))):
                
                switch type {
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
                    ColorPickCircleButton(color: viewStore.primaryColor, isDisabled: false) {
                        viewStore.send(.primaryColorButtonTapped)
                    }
                    .frame(width: 44, height: 44)
                    
                    ColorPickCircleButton(color: viewStore.secondaryColor, isDisabled: false) {
                        viewStore.send(.secondaryColorButtonTapped)
                    }
                    .frame(width: 44, height: 44)
                    
                    ColorPickCircleButton(color: viewStore.tertiaryColor, isDisabled: false) {
                        viewStore.send(.tertiaryColorButtonTapped)
                    }
                    .frame(width: 44, height: 44)
                }
                .popover(store: store.scope(
                    state: \.$colorPicker, action: ColorToolFeature.Action.colorPicker),
                    attachmentAnchor: .rect(.rect(viewStore.attachmentAnchorRect)),
                    arrowEdge: .top,
                    content: ColorPickerView.init(store:)
                )
                Spacer()
            }
            .labelsHidden()
            .frame(width: 60)
            .background(.heavyDarkGray)
        }
        .ignoresSafeArea(edges: .top)
    }
}

#Preview {
    Color.black.overlay {
        ColorToolBar(store: .init(
            initialState: ColorToolFeature.State()
        ) {
            ColorToolFeature()
        })
    }
}

struct ColorPickerFeature: Reducer {
    
    struct State: Equatable {
        let colorType: ColorType
        var selectedColor: Color
        
        enum ColorType: String {
            case primary
            case secondary
            case tertiary
            
            var title: String {
                return self.rawValue.capitalized
            }
        }
    }
    
    enum Action: Equatable {
        case colorSelected(Color)
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case selectColor(State.ColorType, Color)
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .colorSelected(color):
                state.selectedColor = color
                return .run { [colorType = state.colorType, color = state.selectedColor] send in
                    await send(.delegate(.selectColor(colorType, color)))
                }
            case .delegate:
                return .none
            }
        }
    }
}

struct ColorPickerView: View {
    
    let store: StoreOf<ColorPickerFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ColorPickerViewController(title: viewStore.colorType.title) { color in
                viewStore.send(.colorSelected(color))
            }
        }
    }
}

struct ColorPickerViewController: UIViewControllerRepresentable {
    
    let title: String
    let selectAction: (_ color: Color) -> Void
    
    func makeUIViewController(context: Context) -> UIColorPickerViewController {
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = context.coordinator
        colorPicker.title = title
        colorPicker.supportsAlpha = false
        return colorPicker
    }
    
    func updateUIViewController(_ colorPickerViewController: UIColorPickerViewController, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UIColorPickerViewControllerDelegate {
        
        private let parent: ColorPickerViewController
        
        init(parent: ColorPickerViewController) {
            self.parent = parent
        }
        
        func colorPickerViewController(_ colorPickerViewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
            parent.selectAction(Color(uiColor: color))
        }
    }
}
