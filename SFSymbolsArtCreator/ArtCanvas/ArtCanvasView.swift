//
//  ArtCanvasView.swift
//  SFSymbolsArtCreator
//
//

import ComposableArchitecture
import SwiftUI

struct ArtCanvasFeature: Reducer {
    struct State: Equatable {
        var artSymbols: IdentifiedArrayOf<ArtSymbolFeature.State>
        let canvasColor: Color
    }
    enum Action: Equatable {
        case artSymbol(id: ArtSymbolFeature.State.ID, action: ArtSymbolFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .artSymbol(id, action):
                return .none
            }
        }
        .forEach(\.artSymbols, action: /Action.artSymbol(id:action:)) {
            ArtSymbolFeature()
        }
    }
}

struct ArtCanvasView: View {
    
    let store: StoreOf<ArtCanvasFeature>
    
    var body: some View {
        
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            
                Rectangle()
                    .fill(viewStore.canvasColor)
                    .frame(width: 500, height: 500)
                    .overlay {
                        ForEachStore(store.scope(state: \.artSymbols, action: ArtCanvasFeature.Action.artSymbol)) {
                            ArtSymbolView(store: $0)
                        }
                    }
        }
    }
}
