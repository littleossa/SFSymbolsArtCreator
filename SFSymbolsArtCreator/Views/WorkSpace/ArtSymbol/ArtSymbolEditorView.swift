//
//  ArtSymbolEditorView.swift
//  SFSymbolsArtCreator
//
//

import ComposableArchitecture
import SwiftUI

struct ArtSymbolEditorView: View {
    
    let store: StoreOf<ArtSymbolFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
                
                Image(systemName: viewStore.name)
                    .resizable()
                    .fontWeight(viewStore.weight)
                    .rotation3DEffect(.degrees(180),
                                      axis: (x: viewStore.flipType.value.rotationEffectAxis.x,
                                             y: viewStore.flipType.value.rotationEffectAxis.y,
                                             z: viewStore.flipType.value.rotationEffectAxis.z),
                                      anchorZ: 1)
                    .rotation3DEffect(.degrees(viewStore.rotationDegrees),
                                      axis: (x: 0, y: 0, z: 1), anchorZ: 1)
                    .symbolRenderingMode(viewStore.renderingType.renderingMode)
                    .foregroundStyle(viewStore.primaryColor,
                                     viewStore.secondaryColor,
                                     viewStore.tertiaryColor)
                    .boundingBox(
                        position: viewStore.$position,
                        width: viewStore.width,
                        height: viewStore.height,
                        degrees: viewStore.rotationDegrees
                    ) { value in
                        viewStore.send(.symbolSizeScaled(value))
                    }
        }
    }
}

#Preview {
    ZStack {
        ArtSymbolEditorView(store: .init(
            initialState: ArtSymbolFeature.State(
                id: UUID(),
                symbolName: "checkmark.icloud",
                width: 44,
                height: 44,
                weight: .regular,
                position: CGPoint(x: 50, y: 50),
                renderingType: .monochrome,
                primaryColor: .black,
                secondaryColor: .clear,
                tertiaryColor: .clear
            )) {
                ArtSymbolFeature()
            }
        )
    }
}
