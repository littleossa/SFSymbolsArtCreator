//
//  ArtSymbolLayerCell.swift
//  SFSymbolsArtCreator
//
//

import SwiftUI

struct ArtSymbolLayerCell: View {
    
    let artSymbol: ArtSymbolFeature.State
    let hideButtonAction: (_ id: UUID) -> Void
    
    var body: some View {
        
        HStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(.white)
                .frame(width: 44, height: 44)
                .overlay {
                    Image(systemName: artSymbol.name)
                        .fontWeight(artSymbol.weight)
                        .rotation3DEffect(.degrees(180),
                                          axis: (x: artSymbol.flipType.value.rotationEffectAxis.x,
                                                 y: artSymbol.flipType.value.rotationEffectAxis.y,
                                                 z: artSymbol.flipType.value.rotationEffectAxis.z),
                                          anchorZ: 1)
                        .rotation3DEffect(.degrees(artSymbol.rotationDegrees),
                                          axis: (x: 0, y: 0, z: 1), anchorZ: 1)
                        .symbolRenderingMode(artSymbol.renderingType.renderingMode)
                        .foregroundStyle(artSymbol.primaryColor,
                                         artSymbol.secondaryColor,
                                         artSymbol.tertiaryColor)
                }
            
            Spacer()
            
            Button {
                hideButtonAction(artSymbol.id)
            } label: {
                Image(symbol: artSymbol.isHidden ? .eyeSlash : .eye)
                    .font(.system(size: 24))
                    .foregroundStyle(.paleGray)
            }
            .frame(width: 44, height: 44)
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(.heavyDarkGray)
        }
        .frame(width: 200, height: 96)
    }
}

#Preview {
    
    VStack {
        ArtSymbolLayerCell(artSymbol: .init(
            id: UUID(),
            symbolName: "checkmark.icloud",
            width: 44,
            height: 44,
            weight: .regular,
            position: CGPoint(x: 50, y: 50),
            renderingType: .monochrome,
            primaryColor: .black,
            secondaryColor: .clear,
            tertiaryColor: .clear,
            rotationDegrees: 45,
            flipType: .horizontal), hideButtonAction: { _ in }
        )
        
        ArtSymbolLayerCell(artSymbol: .init(
            id: UUID(),
            symbolName: "checkmark.icloud",
            width: 44,
            height: 44,
            weight: .regular,
            position: CGPoint(x: 50, y: 50),
            renderingType: .monochrome,
            primaryColor: .black,
            secondaryColor: .clear,
            tertiaryColor: .clear,
            rotationDegrees: 45,
            flipType: .horizontal,
            isHidden: true), hideButtonAction: { _ in }
        )
    }
}
