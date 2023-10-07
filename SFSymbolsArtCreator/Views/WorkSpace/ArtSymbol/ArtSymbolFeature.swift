//
//  ArtSymbol.swift
//  SFSymbolsArtCreator
//
//

import ComposableArchitecture
import SwiftUI

struct ArtSymbolFeature: Reducer {
    struct State: Equatable, Identifiable {
        var id: UUID
        var appearance: ArtSymbolAppearance
        var editor: ArtSymbolEditorFeature.State
        var layer: ArtSymbolLayerFeature.State
        
        init(id: UUID, appearance: ArtSymbolAppearance) {
            self.id = id
            self.appearance = appearance
            self.editor = .init(appearance: appearance)
            self.layer = .init(appearance: appearance)
        }
    }
    
    enum Action: Equatable {
        case editor(ArtSymbolEditorFeature.Action)
        case layer(ArtSymbolLayerFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .editor:
                return .none
            case .layer:
                return .none
            }
        }
        Scope(state: \.editor, action: /Action.editor) {
            ArtSymbolEditorFeature()
        }
        Scope(state: \.layer, action: /Action.layer) {
            ArtSymbolLayerFeature()
        }
    }
}

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
