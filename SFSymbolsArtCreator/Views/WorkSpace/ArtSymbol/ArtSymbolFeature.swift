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
        var appearance: ArtSymbolAppearance {
            get {
                ArtSymbolAppearance(
                    name: editor.appearance.name,
                    renderingType: editor.appearance.renderingType,
                    primaryColor: editor.appearance.primaryColor,
                    secondaryColor: editor.appearance.secondaryColor,
                    tertiaryColor: editor.appearance.tertiaryColor,
                    weight: editor.appearance.weight,
                    width: editor.appearance.width,
                    height: editor.appearance.height,
                    position: editor.appearance.position,
                    isHidden: layer.appearance.isHidden
                )
            }
            set {
                editor.appearance = newValue
                layer.appearance = newValue
            }
        }
        var editor: ArtSymbolEditorFeature.State
        var layer: ArtSymbolLayerFeature.State
        
        init(id: UUID, appearance: ArtSymbolAppearance) {
            self.id = id
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

