//
//  ArtSymbolImage.swift
//  SFSymbolsArtCreator
//
//

import SwiftUI

struct ArtSymbolImage: View {
    let appearance: ArtSymbolAppearance
    
    var body: some View {
        
        Image(systemName: appearance.name)
            .resizable()
            .fontWeight(appearance.weight)
            .rotation3DEffect(.degrees(180),
                              axis: (x: appearance.flipType.value.rotationEffectAxis.x,
                                     y: appearance.flipType.value.rotationEffectAxis.y,
                                     z: appearance.flipType.value.rotationEffectAxis.z),
                              anchorZ: 1)
            .rotation3DEffect(.degrees(appearance.rotationDegrees),
                              axis: (x: 0, y: 0, z: 1), anchorZ: 1)
            .symbolRenderingMode(appearance.renderingType.renderingMode)
            .foregroundStyle(appearance.primaryColor,
                             appearance.secondaryColor,
                             appearance.tertiaryColor)
            .frame(width: appearance.width, height: appearance.height)
            .position(appearance.position)
    }
}

#Preview {
    ArtSymbolImage(appearance: .preview())
}
