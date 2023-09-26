//
//  ColorPickerView.swift
//  SFSymbolsArtCreator
//
//

import ComposableArchitecture
import SwiftUI

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

#Preview {
    Circle()
        .fill(.black)
        .frame(width: 44, height: 44)
        .popover(isPresented: .constant(true)) {
            ColorPickerView(store: .init(
                initialState: ColorPickerFeature.State(
                    colorType: .primary,
                    selectedColor: .red)
            ) {
                ColorPickerFeature()
            })
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

