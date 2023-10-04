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
        
        var editingSymbol: ArtSymbolFeature.State? {
            get {
                if let editSymbolID {
                    return artSymbols[id: editSymbolID]
                }
                return nil
            }
            set {
                if let editSymbolID {
                    artSymbols[id: editSymbolID] = newValue
                }
            }
        }
    }
    enum Action: Equatable {
        case artSymbol(id: ArtSymbolFeature.State.ID, action: ArtSymbolFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .artSymbol(id: id, action: .symbolSizeScaled(value)):
                
                guard let symbolState = state.artSymbols[id: id]
                else { return .none }
                
                let scaledWidth: CGFloat
                let scaledHeight: CGFloat
                
                switch state.editFormType {
                case .freeForm:
                    guard symbolState.width + value.scaleSize.width > AppConfig.minScalingWidth,
                          symbolState.height + value.scaleSize.height > AppConfig.minScalingHeight
                    else { return .none }
                    
                    scaledWidth = symbolState.width + value.scaleSize.width
                    scaledHeight = symbolState.height + value.scaleSize.height
                    
                case .uniform:
                    guard symbolState.width + value.scaleValue > AppConfig.minScalingWidth,
                          symbolState.height + value.scaleValue > AppConfig.minScalingHeight
                    else { return .none }
                    
                    scaledWidth = symbolState.width + value.scaleValue
                    scaledHeight = symbolState.height + value.scaleValue
                }
                
                state.editingSymbol?.width = scaledWidth
                state.editingSymbol?.height = scaledHeight
                
                return .none
                
            case .artSymbol(id: _, action: _):
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
                .overlay {
                    ForEachStore(store.scope(state: \.artSymbols, action: ArtCanvasFeature.Action.artSymbol)) { store in
                        
                        store.withState { state in
                            
                            ZStack {
                                if viewStore.editSymbolID == state.id {
                                    ZStack {
                                        ArtSymbolEditorView(store: store)
                                    }
                                } else {
                                    ZStack {
                                        ArtSymbolImage(state: state)
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
