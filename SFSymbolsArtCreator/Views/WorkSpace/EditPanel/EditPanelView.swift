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
        var isDisplayAllEditToolOptions: Bool
        
        init(appearance: ArtSymbolAppearance,
             editFormType: EditFormType = .freeForm,
             isDisplayAllEditToolOptions: Bool = true) {
            self.editFormType = editFormType
            self.editButtonTool = .init(
                fontWight: appearance.weight,
                isFlippedHorizontal: appearance.flipType.value.isFlippedHorizontal,
                isFlippedVertical: appearance.flipType.value.isFlippedVertical,
                rotationDegrees: appearance.rotationDegrees
            )
            self.editStepperTool = .init(
                width: appearance.width,
                height: appearance.height,
                positionX: appearance.position.x,
                positionY: appearance.position.y,
                rotationDegrees: appearance.rotationDegrees
            )
            self.isDisplayAllEditToolOptions = isDisplayAllEditToolOptions
        }
    }
    
    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case delegate(Delegate)
        case editButtonTool(EditButtonToolFeature.Action)
        case editStepperTool(EditStepperToolFeature.Action)
        case resizeButtonTapped
        
        enum Delegate: Equatable {
            case editFormTypeChanged(EditFormType)
        }
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Scope(state: \.editButtonTool, action: /Action.editButtonTool) {
            EditButtonToolFeature()
        }
        Scope(state: \.editStepperTool, action: /Action.editStepperTool) {
            EditStepperToolFeature()
        }
        Reduce { state, action in
            switch action {
            case .binding(\.$editFormType):
                return .run { [editFormType = state.editFormType] send in
                    await send(.delegate(.editFormTypeChanged(editFormType)))
                }
            case .binding:
                return .none
                
            case .delegate:
                return .none
                
            case let .editButtonTool(.delegate(.degreesRotated(degrees))):
                state.editStepperTool.rotationDegrees = degrees
                return .none
                
            case .editButtonTool:
                return .none
                
            case .editStepperTool:
                return .none
                
            case .resizeButtonTapped:
                state.isDisplayAllEditToolOptions.toggle()
                return .none
            }
        }
    }
}

struct EditPanelView: View {
    
    let store: StoreOf<EditPanelFeature>
    
    var body: some View {
        
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(spacing: 16) {
                
                HStack {
                    
                    ResizeButton(isExpanded: viewStore.isDisplayAllEditToolOptions) {
                        viewStore.send(.resizeButtonTapped, animation: .bouncy)
                    }
                    
                    Spacer()
                    
                    Picker("Edit Form", selection: viewStore.$editFormType) {
                        ForEach(EditFormType.allCases) {
                            Text($0.rawValue)
                                .tag($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 320)
                    
                    Spacer()

                    Spacer()
                        .frame(width: 28)
                }
                .padding(.bottom, viewStore.isDisplayAllEditToolOptions ? 16 : 0)
                
                if viewStore.isDisplayAllEditToolOptions {
                    
                    EditButtonToolView(store: store.scope(
                        state: \.editButtonTool,
                        action: EditPanelFeature.Action.editButtonTool)
                    )
                    .padding(.bottom, 4)
                    
                    Divider()
                        .background(.gray)
                    
                    EditStepperToolView(store: store.scope(
                        state: \.editStepperTool,
                        action: EditPanelFeature.Action.editStepperTool)
                    )
                }
            }
            .frame(width: 560)
            .padding(8)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.heavyDarkGray)
                    .shadow(radius: 10)
            }
        }
    }
}

#Preview {
    Color.black
        .overlay {
            EditPanelView(store: .init(
                initialState: EditPanelFeature.State(
                    appearance: .preview(),
                    editFormType: .freeForm)
            ) {
                EditPanelFeature()
            })
        }
        .onAppear {
            UISegmentedControl.setAppearance()
        }
}
