//
//  EditStepperTool.swift
//  SFSymbolsArtCreator
//
//

import ComposableArchitecture
import SwiftUI

struct EditStepperToolFeature: Reducer {
    struct State: Equatable {
        var width: CGFloat
        var height: CGFloat
        var positionX: CGFloat
        var positionY: CGFloat
        var rotationDegrees: Double
    }
    
    enum Action: Equatable {
        case decrementDegreesButtonTapped
        case decrementHeightButtonTapped
        case decrementWidthButtonTapped
        case decrementXPositionButtonTapped
        case decrementYPositionButtonTapped
        case delegate(Delegate)
        case incrementDegreesButtonTapped
        case incrementHeightButtonTapped
        case incrementWidthButtonTapped
        case incrementXPositionButtonTapped
        case incrementYPositionButtonTapped
        
        enum Delegate: Equatable {
            case degreesValueChanged(Double)
            case heightValueChanged(CGFloat)
            case positionValueChanged(CGPoint)
            case widthValueChanged(CGFloat)
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case .decrementDegreesButtonTapped:
                let degrees = state.rotationDegrees.rotatingWithin360ByDegrees(-1)
                state.rotationDegrees = degrees
                return sendDegreesValueChanged(state: state)
                
            case .decrementHeightButtonTapped:
                guard state.height > AppConfig.minScalingHeight
                else { return .none }
                
                state.height -= 1
                return sendHeightValueChanged(state: state)
                
            case .decrementWidthButtonTapped:
                
                guard state.width > AppConfig.minScalingWidth 
                else { return .none }
                
                state.width -= 1
                return sendWidthValueChanged(state: state)
                
            case .decrementXPositionButtonTapped:
                state.positionX -= 1
                return sendPositionValueChanged(state: state)
                
            case .decrementYPositionButtonTapped:
                state.positionY -= 1
                return sendPositionValueChanged(state: state)

            case .delegate:
                return .none
                
            case .incrementDegreesButtonTapped:
                let degrees = state.rotationDegrees.rotatingWithin360ByDegrees(1)
                state.rotationDegrees = degrees
                return sendDegreesValueChanged(state: state)
                
            case .incrementHeightButtonTapped:
                state.height += 1
                return sendHeightValueChanged(state: state)
                
            case .incrementWidthButtonTapped:
                state.width += 1
                return sendWidthValueChanged(state: state)
                
            case .incrementXPositionButtonTapped:
                state.positionX += 1
                return sendPositionValueChanged(state: state)

            case .incrementYPositionButtonTapped:
                state.positionY += 1
                return sendPositionValueChanged(state: state)
            }
        }
    }
    
    private func sendDegreesValueChanged(state: State) -> Effect<Action> {
        return .run { send in
            await send(.delegate(.degreesValueChanged(state.rotationDegrees)))
        }
    }
    
    private func sendHeightValueChanged(state: State) -> Effect<Action> {
        return .run { send in
            await send(.delegate(.heightValueChanged(state.height)))
        }
    }
    
    private func sendPositionValueChanged(state: State) -> Effect<Action> {
        let position = CGPoint(x: state.positionX, y: state.positionY)
        return .run { send in
            await send(.delegate(.positionValueChanged(position)))
        }
    }
    
    private func sendWidthValueChanged(state: State) -> Effect<Action> {
        return .run { send in
            await send(.delegate(.widthValueChanged(state.width)))
        }
    }
}

struct EditStepperToolView: View {
    
    let store: StoreOf<EditStepperToolFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            
            HStack {
                EditValueStepper(
                    symbol: .arrowLeftAndRightSquareFill,
                    title: "Width"
                ) {
                    viewStore.send(.incrementWidthButtonTapped)
                } decrementAction: {
                    viewStore.send(.decrementWidthButtonTapped)
                }
                
                EditValueStepper(
                    symbol: .arrowUpAndDownSquareFill,
                    title: "Height"
                ) {
                    viewStore.send(.incrementHeightButtonTapped)
                } decrementAction: {
                    viewStore.send(.decrementHeightButtonTapped)
                }

                EditValueStepper(
                    symbol: .xSquareFill,
                    title: "X"
                ) {
                    viewStore.send(.incrementXPositionButtonTapped)
                } decrementAction: {
                    viewStore.send(.decrementXPositionButtonTapped)
                }

                EditValueStepper(
                    symbol: .ySquareFill,
                    title: "Y"
                ) {
                    viewStore.send(.incrementYPositionButtonTapped)
                } decrementAction: {
                    viewStore.send(.decrementYPositionButtonTapped)
                }

                EditValueStepper(
                    symbol: .arrowClockwiseCircleFill,
                    title: "Degrees"
                ) {
                    viewStore.send(.incrementDegreesButtonTapped)
                } decrementAction: {
                    viewStore.send(.decrementDegreesButtonTapped)
                }
            }
        }
    }
}

#Preview {
    Color.heavyDarkGray
        .overlay {
            EditStepperToolView(store: .init(
                initialState: EditStepperToolFeature.State(
                    width: 100,
                    height: 100,
                    positionX: 10,
                    positionY: 10,
                    rotationDegrees: 0
                )
            ) {
                EditStepperToolFeature()
            })
        }
}
