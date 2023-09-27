//
//  ArtSymbol.swift
//  SFSymbolsArtCreator
//
//

import ComposableArchitecture
import SwiftUI

struct ArtSymbolFeature: Reducer {
    struct State: Equatable {
        var flipType: FlipType = .none
        var height: CGFloat
        var id: UUID
        var isEditing = true
        var isHidden = false
        var location: CGPoint
        let name: String
        var primaryColor: Color
        var renderingType: RenderingType
        var rotationDegrees: Double = 0
        var secondaryColor: Color
        var tertiaryColor: Color
        var weight: Font.Weight
        var width: CGFloat
        
        init(id: UUID,
             symbolName: String,
             width: CGFloat,
             height: CGFloat,
             weight: Font.Weight,
             location: CGPoint,
             renderingType: RenderingType,
             primaryColor: Color,
             secondaryColor: Color,
             tertiaryColor: Color,
             rotationDegrees: Double = 0,
             flipType: FlipType = .none,
             isEditing: Bool = true,
             isHidden: Bool = false) {
            self.flipType = flipType
            self.height = height
            self.id = id
            self.isEditing = isEditing
            self.isHidden = isHidden
            self.location = location
            self.name = symbolName
            self.primaryColor = primaryColor
            self.renderingType = renderingType
            self.rotationDegrees = rotationDegrees
            self.secondaryColor = secondaryColor
            self.tertiaryColor = tertiaryColor
            self.weight = weight
            self.width = width
        }
    }
    
    // TODO: Add Action
    enum Action: Equatable {
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            }
        }
    }
}

struct ArtSymbolView: View {
    
    let store: StoreOf<ArtSymbolFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            
            Image(systemName: viewStore.name)
                .resizable()
                .frame(width: viewStore.width, height: viewStore.height)
                .position(viewStore.location)
                .rotation3DEffect(.degrees(180),
                                  axis: viewStore.flipType.rotationEffectAxis,
                                  anchorZ: 1)
                .rotation3DEffect(.degrees(viewStore.rotationDegrees),
                                  axis: (x: 0, y: 0, z: -1), anchorZ: 1)
                .rotation3DEffect(
                    .degrees(180),
                    axis: viewStore.flipType.rotationEffectAxis,
                    anchorZ: 1
                )
                .symbolRenderingMode(viewStore.renderingType.renderingMode)
                .foregroundStyle(viewStore.primaryColor,
                                 viewStore.secondaryColor,
                                 viewStore.tertiaryColor)
        }
    }
}

#Preview {
    ArtSymbolView(store: .init(
        initialState: ArtSymbolFeature.State(
            id: UUID(),
            symbolName: "checkmark.icloud",
            width: 44,
            height: 44,
            weight: .regular,
            location: CGPoint(x: 50, y: 50),
            renderingType: .monochrome,
            primaryColor: .black,
            secondaryColor: .clear,
            tertiaryColor: .clear
        )) {
            ArtSymbolFeature()
        }
    )
}

enum FlipType {
    case none
    case horizontal
    case vertical
    case horizontalAndVertical
    
    var rotationEffectAxis: (x: CGFloat, y: CGFloat, z: CGFloat) {
        
        switch self {
        case .none:
            return (x: 0, y: 0, z: 0)
        case .horizontal:
            return (x: 0, y: 1, z: 0)
        case .vertical:
            return (x: 1, y: 0, z: 0)
        case .horizontalAndVertical:
            return (x: 0, y: 0, z: 1)
        }
    }
}
