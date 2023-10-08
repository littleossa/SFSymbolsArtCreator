//
//  ArtSymbolAppearance.swift
//  SFSymbolsArtCreator
//
//

import SwiftUI

// MARK: - State Initializer

struct ArtSymbolAppearance: Equatable {
    let name: String
    var renderingType: RenderingType
    var primaryColor: Color
    var secondaryColor: Color
    var tertiaryColor: Color
    var weight: Font.Weight
    var width: CGFloat
    var height: CGFloat
    var position: CGPoint
    var flipType: FlipType = .none
    var rotationDegrees: Double = 0
    var isHidden = false
}

extension ArtSymbolAppearance {
    static func preview(name: String = "checkmark.icloud",
                        renderingType: RenderingType = .monochrome,
                        primaryColor: Color = .black,
                        secondaryColor: Color = .clear,
                        tertiaryColor: Color = .clear,
                        weight: Font.Weight = .regular,
                        width: CGFloat = 44,
                        height: CGFloat = 44,
                        position: CGPoint = CGPoint(x: 50, y: 50),
                        flipType: FlipType = .none,
                        rotationDegrees: Double = 0) -> ArtSymbolAppearance {
        return .init(name: name,
                     renderingType: renderingType,
                     primaryColor: primaryColor,
                     secondaryColor: secondaryColor,
                     tertiaryColor: tertiaryColor,
                     weight: weight,
                     width: width,
                     height: height,
                     position: position,
                     flipType: flipType,
                     rotationDegrees: rotationDegrees)
    }
}

// MARK: - Initializer
extension ArtSymbolAppearance {
    
    init(catalogItem: CatalogItem,
         width: CGFloat,
         height: CGFloat,
         position: CGPoint,
         rotationDegrees: Double = 0,
         flipType: FlipType = .none,
         isHidden: Bool = false) {
        self.flipType = flipType
        self.height = height
        self.isHidden = isHidden
        self.position = position
        self.name = catalogItem.symbolName
        self.primaryColor = catalogItem.primaryColor
        self.renderingType = catalogItem.renderingType
        self.rotationDegrees = rotationDegrees
        self.secondaryColor = catalogItem.secondaryColor
        self.tertiaryColor = catalogItem.tertiaryColor
        self.weight = catalogItem.fontWeight
        self.width = width
    }
}

