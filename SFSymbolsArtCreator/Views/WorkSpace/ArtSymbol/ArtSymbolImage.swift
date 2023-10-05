//
//  ArtSymbolImage.swift
//  SFSymbolsArtCreator
//
//

import SwiftUI

struct ArtSymbolImage: View {
    let state: ArtSymbolFeature.State
    
    var body: some View {
        
        Image(systemName: state.name)
            .resizable()
            .fontWeight(state.weight)
            .rotation3DEffect(.degrees(180),
                              axis: (x: state.flipType.value.rotationEffectAxis.x,
                                     y: state.flipType.value.rotationEffectAxis.y,
                                     z: state.flipType.value.rotationEffectAxis.z),
                              anchorZ: 1)
            .rotation3DEffect(.degrees(state.rotationDegrees),
                              axis: (x: 0, y: 0, z: 1), anchorZ: 1)
            .symbolRenderingMode(state.renderingType.renderingMode)
            .foregroundStyle(state.primaryColor,
                             state.secondaryColor,
                             state.tertiaryColor)
            .frame(width: state.width, height: state.height)
            .position(state.position)
    }
}

#Preview {
    ArtSymbolImage(state: .init(
        id: UUID(),
        symbolName: "checkmark.icloud",
        width: 44,
        height: 44,
        weight: .regular,
        position: CGPoint(x: 50, y: 50),
        renderingType: .monochrome,
        primaryColor: .black,
        secondaryColor: .clear,
        tertiaryColor: .clear)
    )
    .previewDisplayName("ArtSymbolImage")
}
