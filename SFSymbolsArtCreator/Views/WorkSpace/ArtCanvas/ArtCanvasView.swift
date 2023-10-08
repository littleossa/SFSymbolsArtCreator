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
        var canvasColor: Color
        var editFormType: EditFormType
        var editSymbolID: UUID?
        
        var editingSymbolAppearance: ArtSymbolAppearance? {
            get {
                if let editSymbolID {
                    return artSymbols[id: editSymbolID]?.appearance
                }
                return nil
            }
            set {
                if let editSymbolID,
                   let appearance = newValue {
                    artSymbols[id: editSymbolID]?.appearance = appearance
                    artSymbols[id: editSymbolID]?.editor.appearance = appearance
                    artSymbols[id: editSymbolID]?.layer.appearance = appearance
                }
            }
        }
    }
    enum Action: Equatable {
        case artSymbol(id: ArtSymbolFeature.State.ID, action: ArtSymbolFeature.Action)
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case editingAppearanceChanged(ArtSymbolAppearance)
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .artSymbol(id: _, action: .editor(.symbolPositionChanged(position))):
                state.editingSymbolAppearance?.position = position
                return sendEditingAppearanceChanged(state.editingSymbolAppearance)
                
            case let .artSymbol(id: _, action: .editor(.symbolSizeScaled(value))):
                
                guard let appearance = state.editingSymbolAppearance
                else { return .none }
                
                let scaledWidth = state.editFormType.scaledWidth(by: value,
                                                                 beforeWidth: appearance.width)
                let scaledHeight = state.editFormType.scaledHeight(by: value,
                                                                  beforeHeight: appearance.height)
                state.editingSymbolAppearance?.width = scaledWidth
                state.editingSymbolAppearance?.height = scaledHeight
                
                return sendEditingAppearanceChanged(state.editingSymbolAppearance)
                
            case .artSymbol(id: _, action: _):
                return .none
            case .delegate:
                return .none
            }
        }
        .forEach(\.artSymbols, action: /Action.artSymbol(id:action:)) {
            ArtSymbolFeature()
        }
    }
    
    private func sendEditingAppearanceChanged(_ appearance: ArtSymbolAppearance?) -> Effect<Action> {
        guard let appearance else { return .none }
        
        return .run { send in
            await send(.delegate(.editingAppearanceChanged(appearance)))
        }
    }
}

struct ArtCanvasView: View {
    
    let store: StoreOf<ArtCanvasFeature>
    
    var body: some View {
        
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            
            Rectangle()
                .fill(viewStore.canvasColor)
                .overlay {
                    ForEachStore(store.scope(state: \.artSymbols, action: ArtCanvasFeature.Action.artSymbol)) { store in
                        
                        store.withState { state in
                            
                            ZStack {
                                if viewStore.editSymbolID == state.id {
                                    ZStack {
                                        ArtSymbolEditorView(
                                            store: store.scope(
                                                state: \.editor,
                                                action: ArtSymbolFeature.Action.editor)
                                        )
                                    }
                                } else {
                                    ZStack {
                                        ArtSymbolImage(appearance: state.appearance)
                                    }
                                }
                            }
                        }
                    }
                }
        }
    }
}

#Preview {
    
    ZStack(alignment: .center) {
        
        Rectangle()
            .fill(.black)
            .opacity(0.9)
            .blur(radius: 2)
            .ignoresSafeArea(edges: .bottom)
        
        ArtCanvasView(store: .init(
            initialState: ArtCanvasFeature.State(
                artSymbols: [],
                canvasColor: .white,
                editFormType: .freeForm)
        ) {
            ArtCanvasFeature()
        })
        .frame(width: 400, height: 400)
    }
}
