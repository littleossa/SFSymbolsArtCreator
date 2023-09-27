//
//  ActionBar.swift
//  SFSymbolsArtCreator
//
//

import ComposableArchitecture
import SwiftUI

struct ActionBarFeature: Reducer {
    
    struct State: Equatable {
        var drawToolState = DrawToolFeature.State()
        var menuToolState = MenuToolFeature.State()
    }
    
    enum Action: Equatable {
        case drawTool(DrawToolFeature.Action)
        case menuTool(MenuToolFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.drawToolState, action: /Action.drawTool) {
            DrawToolFeature()
        }
        Scope(state: \.menuToolState, action: /Action.menuTool) {
            MenuToolFeature()
        }
    }
}

struct ActionBar: View {
    
    let store: StoreOf<ActionBarFeature>
    
    var body: some View {
        
        HStack(spacing: 0) {
            MenuToolBar(store: store.scope(
                state: \.menuToolState,
                action: ActionBarFeature.Action.menuTool))
            
            DrawToolBar(store: store.scope(
                state: \.drawToolState,
                action: ActionBarFeature.Action.drawTool))
        }
        .background(.heavyDarkGray)
    }
}

#Preview {
    ActionBar(store: .init(initialState: ActionBarFeature.State()) {
        ActionBarFeature()
    })
}
