//
//  EditButtonTool.swift
//  SFSymbolsArtCreator
//
//

import ComposableArchitecture
import SwiftUI

struct EditButtonToolFeature: Reducer {
    struct State: Equatable {
        var fontWight: Font.Weight
        var isFlippedHorizontal: Bool
        var isFlippedVertical: Bool
        var rotationDegrees: Double
        
        var decrementWeightButtonDisabled: Bool {
            return fontWight == .ultraLight
        }
        
        var incrementWeightButtonDisabled: Bool {
            return fontWight == .black
        }
    }
    
    enum Action: Equatable {
        case decrementWeightButtonTapped
        case delegate(Delegate)
        case flipHorizontalButtonTapped
        case flipVerticalButtonTapped
        case incrementWeightButtonTapped
        case rotateButtonTapped
        
        enum Delegate: Equatable {
            case degreesRotated(Double)
            case flipTypeChanged(FlipType)
            case fontWeightChanged(Font.Weight)
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case .decrementWeightButtonTapped:
                if state.decrementWeightButtonDisabled {
                    return .none
                }
                let decreasedWeight = state.fontWight.decreased()
                state.fontWight = decreasedWeight
                
                return sendFontWeightChanged(state: state)
                
            case .delegate:
                return .none
                
            case .flipHorizontalButtonTapped:
                state.isFlippedHorizontal.toggle()
                return sendFlipTypeChanged(state: state)
                
            case .flipVerticalButtonTapped:
                state.isFlippedHorizontal.toggle()
                return sendFlipTypeChanged(state: state)
            
            case .incrementWeightButtonTapped:
                if state.incrementWeightButtonDisabled {
                    return .none
                }
                let increasedWeight = state.fontWight.increased()
                state.fontWight = increasedWeight
                
                return sendFontWeightChanged(state: state)
                
            case .rotateButtonTapped:
                let rotatedDegrees = state.rotationDegrees.rotatingWithin360ByDegrees(45)
                state.rotationDegrees = rotatedDegrees
                
                return .run { [degrees = state.rotationDegrees] send in
                    await send(.delegate(.degreesRotated(degrees)))
                }
            }
        }
    }
    
    func sendFlipTypeChanged(state: State) -> Effect<Action> {
        let flipType = FlipType(isFlippedHorizontal: state.isFlippedHorizontal,
                                isFlippedVertical: state.isFlippedVertical)
        return .run { send in
            await send(.delegate(.flipTypeChanged(flipType)))
        }
    }
    
    func sendFontWeightChanged(state: State) -> Effect<Action> {
        let weight = state.fontWight
        return .run { send in
            await send(.delegate(.fontWeightChanged(weight)))
        }
    }
}

struct EditButtonToolView: View {
    
    let store: StoreOf<EditButtonToolFeature>
    
    var body: some View {
        
        WithViewStore(self.store, observe: { $0 }) { viewStore in
                
            HStack(spacing: 20) {
                    VerticalSymbolLabelButton(
                        title: "Flip Horizontal",
                        symbol: .arrowLeftAndRightRighttriangleLeftRighttriangleRightFill
                    ) {
                        viewStore.send(.flipHorizontalButtonTapped)
                    }
                    
                    VerticalSymbolLabelButton(
                        title: "Flip Vertical",
                        symbol: .arrowUpAndDownRighttriangleUpRighttriangleDownFill
                    ) {
                        viewStore.send(.flipVerticalButtonTapped)
                    }
                    
                    VerticalSymbolLabelButton(
                        title: "Rotate 45°",
                        symbol: .rotateRightFill
                    ) {
                        viewStore.send(.rotateButtonTapped)
                    }
                    
                    VerticalLabelButton(title: "Up Weight", action: {
                        viewStore.send(.incrementWeightButtonTapped)
                    }, content: {
                        HStack(spacing: 0) {
                            Image(symbol: .arrowUp)
                                .font(.system(size: 16))
                            Image(symbol: .bold)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28, height: 28)
                        }
                    })
                    .disabled(viewStore.incrementWeightButtonDisabled)
                    
                    VerticalLabelButton(title: "Down Weight", action: {
                        viewStore.send(.decrementWeightButtonTapped)
                    }, content: {
                        HStack(spacing: 0) {
                            Image(symbol: .arrowDown)
                                .font(.system(size: 16))
                            Image(symbol: .bold)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28, height: 28)
                        }
                    })
                    .disabled(viewStore.decrementWeightButtonDisabled)
                }
                .bold()
            }
    }
}

#Preview {
    EditButtonToolView(store: .init(
        initialState: EditButtonToolFeature.State(
            fontWight: .regular,
            isFlippedHorizontal: false,
            isFlippedVertical: false,
            rotationDegrees: 0)
    ) {
        EditButtonToolFeature()
    })
    .frame(height: 100)
    .background {
        RoundedRectangle(cornerRadius: 8)
            .fill(.heavyDarkGray)
    }
}
