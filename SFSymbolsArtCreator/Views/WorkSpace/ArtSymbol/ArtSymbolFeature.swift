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
            didSet {
                editor.appearance = appearance
                layer.appearance = appearance
            }
        }
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

