//
//  BoundingBox.swift
//  BoundingBox
//


import ComposableArchitecture
import SwiftUI

struct BoundingBoxFeature: Reducer {
    struct State: Equatable {
        let artSymbol: ArtSymbolFeature.State
        let formType: EditFormType
        
        var symbolHeight: CGFloat {
            return artSymbol.height
        }
        
        var symbolWidth: CGFloat {
            return artSymbol.width
        }
    }
    
    enum Action: Equatable {
        case delegate(Delegate)
        case symbolMoved(CGPoint)
        case symbolScaled(width: CGFloat, height: CGFloat)
        
        enum Delegate: Equatable {
            case moveSymbol(CGPoint)
            case scaleSymbol(width: CGFloat, height: CGFloat)
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .delegate:
                return .none
            case let .symbolMoved(position):
                return .run { send in
                    await send(.delegate(.moveSymbol(position)))
                }
            case let .symbolScaled(width, height):
                return .run { send in
                    await send(.delegate(.scaleSymbol(width: width, height: height)))
                }
            }
        }
    }
}

struct BoundingBox: View {
    
    let store: StoreOf<BoundingBoxFeature>
    
    private let minScalingHeight: CGFloat = 10
    private let minScalingWidth: CGFloat = 10
    
    var body: some View {
        
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            
            MovingDashFramedRectangle()
                .overlay {
                    
                    EditPointsFramedRectangle(
                        width: viewStore.state.symbolWidth,
                        height: viewStore.state.symbolHeight
                    ) { value in
                        
                        switch viewStore.formType {
                        case .freeForm:
                            guard viewStore.state.symbolWidth + value.scaleSize.width > minScalingWidth,
                                  viewStore.state.symbolHeight + value.scaleSize.height > minScalingHeight
                            else { return }
                            
                            viewStore.send(.symbolScaled(
                                width: value.scaleSize.width,
                                height: value.scaleSize.height)
                            )
                            
                        case .uniform:
                            guard viewStore.state.symbolWidth + value.scaleValue > minScalingWidth,
                                  viewStore.state.symbolHeight + value.scaleValue > minScalingHeight
                            else { return }
                            
                            viewStore.send(.symbolScaled(
                                width: value.scaleValue,
                                height: value.scaleValue)
                            )
                        }
                    }
                }
                .frame(width: viewStore.symbolWidth,
                       height: viewStore.symbolHeight)
                .position(viewStore.state.artSymbol.location)
                .gesture(DragGesture().onChanged { value in
                    viewStore.send(.symbolMoved(value.location))
                })
        }
    }
}
