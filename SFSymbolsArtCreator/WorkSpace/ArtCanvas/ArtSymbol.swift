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
                              axis: (x: 0, y: 0, z: -1), anchorZ: 1)
            .symbolRenderingMode(state.renderingType.renderingMode)
            .foregroundStyle(state.primaryColor,
                             state.secondaryColor,
                             state.tertiaryColor)
            .frame(width: state.width, height: state.height)
            .position(state.position)
    }
}

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
                                      axis: (x: 0, y: 0, z: -1), anchorZ: 1)
                    .symbolRenderingMode(viewStore.renderingType.renderingMode)
                    .foregroundStyle(viewStore.primaryColor,
                                     viewStore.secondaryColor,
                                     viewStore.tertiaryColor)
                    .boundingBox(position: viewStore.$position,
                                 width: viewStore.width,
                                 height: viewStore.height) { value in
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
    .previewDisplayName("ArtSymbolEditorView")
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
