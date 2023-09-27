//
//  ArtSymbol.swift
//  SFSymbolsArtCreator
//
//

import ComposableArchitecture
import SwiftUI

struct ArtSymbolFeature: Reducer {
    struct State: Equatable {
        var editFormType: EditFormType
        var flipType: FlipType = .none
        @BindingState var height: CGFloat
        var id: UUID
        var isEditing = true
        var isHidden = false
        let name: String
        @BindingState var position: CGPoint
        var primaryColor: Color
        var renderingType: RenderingType
        var rotationDegrees: Double = 0
        var secondaryColor: Color
        var tertiaryColor: Color
        var weight: Font.Weight
        @BindingState var width: CGFloat
        
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
             editFormType: EditFormType,
             isEditing: Bool = true,
             isHidden: Bool = false) {
            self.editFormType = editFormType
            self.flipType = flipType
            self.height = height
            self.id = id
            self.isEditing = isEditing
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
    }
    
    // TODO: Add Action
    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
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
                    .rotation3DEffect(.degrees(180),
                                      axis: viewStore.flipType.rotationEffectAxis,
                                      anchorZ: 1)
                    .rotation3DEffect(.degrees(viewStore.rotationDegrees),
                                      axis: (x: 0, y: 0, z: -1), anchorZ: 1)
                    .symbolRenderingMode(viewStore.renderingType.renderingMode)
                    .foregroundStyle(viewStore.primaryColor,
                                     viewStore.secondaryColor,
                                     viewStore.tertiaryColor)
                    .boundingBox(formType: viewStore.editFormType,
                                 isEditing: viewStore.isEditing,
                                 width: viewStore.$width,
                                 height: viewStore.$height,
                                 position: viewStore.$position)
        }
    }
}

#Preview {
    
    ZStack {
        ArtSymbolView(store: .init(
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
                tertiaryColor: .clear,
                editFormType: .freeForm
            )) {
                ArtSymbolFeature()
            }
        )
    }
}
