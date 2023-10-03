//
//  EditPanel.swift
//  SFSymbolsArtCreator
//
//

import ComposableArchitecture
import SwiftUI

struct EditPanelFeature: Reducer {
    struct State: Equatable {
        @BindingState var editFormType: EditFormType
        var editButtonTool: EditButtonToolFeature.State
        var editStepperTool: EditStepperToolFeature.State
    }
    
    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case editButtonTool(EditButtonToolFeature.Action)
        case editStepperTool(EditStepperToolFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Scope(state: \.editButtonTool, action: /Action.editButtonTool) {
            EditButtonToolFeature()
        }
        Scope(state: \.editStepperTool, action: /Action.editStepperTool) {
            EditStepperToolFeature()
        }
    }
}

struct EditPanelView: View {
    
    let store: StoreOf<EditPanelFeature>
    
    var body: some View {
        
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(spacing: 16) {
                
                Picker("Edit Form", selection: viewStore.$editFormType) {
                    ForEach(EditFormType.allCases) {
                        Text($0.rawValue)
                            .tag($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 320)
                .padding(.bottom, 16)
                
                EditButtonToolView(store: store.scope(state: \.editButtonTool,
                                                      action: EditPanelFeature.Action.editButtonTool))
                Divider()
                    .background(.gray)
                    .padding(.bottom, 8)
                EditStepperToolView(store: store.scope(state: \.editStepperTool,
                                                       action: EditPanelFeature.Action.editStepperTool))
            }
            .frame(width: 560)
            .padding(24)
            .background(RoundedRectangle(cornerRadius: 16).fill(.heavyDarkGray))
        }
    }
}

#Preview {
    Color.black
        .overlay {
            EditPanelView(store: .init(
                initialState: EditPanelFeature.State(
                    editFormType: .freeForm,
                    editButtonTool: .init(
                        fontWight: .regular,
                        isFlippedHorizontal: false,
                        isFlippedVertical: false,
                        rotationDegrees: 0
                    ),
                    editStepperTool: .init(
                        width: 100,
                        height: 100,
                        positionX: 100,
                        positionY: 100,
                        rotationDegrees: 0)
                )) {
                    EditPanelFeature()
                }
            )
        }
        .onAppear {
            UISegmentedControl.setAppearance()
        }
}

extension UISegmentedControl {
    
    /// set appearance for this app
    static func setAppearance() {
        
        self.appearance().selectedSegmentTintColor = .tintColor
        self.appearance().setTitleTextAttributes(
            [.foregroundColor : UIColor.paleGray],
            for: .selected
        )
        self.appearance().setTitleTextAttributes(
            [.foregroundColor : UIColor.systemGray],
            for: .normal
        )
    }
}
