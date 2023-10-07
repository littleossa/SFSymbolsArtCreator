//
//  ArtSymbolEditorView.swift
//  SFSymbolsArtCreator
//
//

import ComposableArchitecture
import SwiftUI

struct ArtSymbolEditorFeature: Reducer {
    struct State: Equatable {
        var appearance: ArtSymbolAppearance
    }
    enum Action: Equatable {
        case symbolPositionChanged(CGPoint)
        case symbolSizeScaled(EditPointScaling.Value)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .symbolPositionChanged:
                return .none
            case .symbolSizeScaled:
                return .none
            }
        }
    }
}

struct ArtSymbolEditorView: View {
    
    let store: StoreOf<ArtSymbolEditorFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
                
            Image(systemName: viewStore.appearance.name)
                    .resizable()
                    .fontWeight(viewStore.appearance.weight)
                    .rotation3DEffect(.degrees(180),
                                      axis: (x: viewStore.appearance.flipType.value.rotationEffectAxis.x,
                                             y: viewStore.appearance.flipType.value.rotationEffectAxis.y,
                                             z: viewStore.appearance.flipType.value.rotationEffectAxis.z),
                                      anchorZ: 1)
                    .rotation3DEffect(.degrees(viewStore.appearance.rotationDegrees),
                                      axis: (x: 0, y: 0, z: 1), anchorZ: 1)
                    .symbolRenderingMode(viewStore.appearance.renderingType.renderingMode)
                    .foregroundStyle(viewStore.appearance.primaryColor,
                                     viewStore.appearance.secondaryColor,
                                     viewStore.appearance.tertiaryColor)
                    .boundingBox(
                        position: viewStore.binding(
                            get: \.appearance.position,
                            send: ArtSymbolEditorFeature.Action.symbolPositionChanged
                        ),
                        width: viewStore.appearance.width,
                        height: viewStore.appearance.height,
                        degrees: viewStore.appearance.rotationDegrees
                    ) { value in
                        viewStore.send(.symbolSizeScaled(value))
                    }
        }
    }
}

#Preview {
    ZStack {
        ArtSymbolEditorView(store: .init(
            initialState: ArtSymbolEditorFeature.State(
                appearance: .preview()
            )) {
                ArtSymbolEditorFeature()
            }
        )
    }
}
