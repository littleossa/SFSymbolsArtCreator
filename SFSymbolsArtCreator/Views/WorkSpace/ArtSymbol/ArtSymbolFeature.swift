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
        let name: String
        var renderingType: RenderingType
        var primaryColor: Color
        var secondaryColor: Color
        var tertiaryColor: Color
        var weight: Font.Weight
        var width: CGFloat
        var height: CGFloat
        @BindingState var position: CGPoint
        var flipType: FlipType = .none
        var rotationDegrees: Double = 0
        var isHidden = false
    }
    
    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case symbolSizeScaled(EditPointScaling.Value)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
    }
}

// MARK: - State Initializer
extension ArtSymbolFeature.State {
    init(id: UUID,
         symbolName: String,
         width: CGFloat,
         height: CGFloat,
         weight: Font.Weight,
         position: CGPoint,
         renderingType: RenderingType,
         primaryColor: Color,
         secondaryColor: Color,
         tertiaryColor: Color,
         rotationDegrees: Double = 0,
         flipType: FlipType = .none,
         isHidden: Bool = false) {
        self.flipType = flipType
        self.height = height
        self.id = id
        self.isHidden = isHidden
        self.position = position
        self.name = symbolName
        self.primaryColor = primaryColor
        self.renderingType = renderingType
        self.rotationDegrees = rotationDegrees
        self.secondaryColor = secondaryColor
        self.tertiaryColor = tertiaryColor
        self.weight = weight
        self.width = width
    }
    
    init(id: UUID,
         catalogItem: CatalogItem,
         width: CGFloat,
         height: CGFloat,
         position: CGPoint,
         rotationDegrees: Double = 0,
         flipType: FlipType = .none,
         isHidden: Bool = false) {
        self.flipType = flipType
        self.height = height
        self.id = id
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
