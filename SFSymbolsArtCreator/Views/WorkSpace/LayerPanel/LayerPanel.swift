//
//  LayerPanel.swift
//  SFSymbolsArtCreator
//
//

import ComposableArchitecture
import SwiftUI

struct LayerPanelFeature: Reducer {
    struct State: Equatable {
        let cellHeight: CGFloat = 90
        
        var artSymbols: IdentifiedArrayOf<ArtSymbolFeature.State>
        var editSymbolID: UUID?

        var frameHeight: CGFloat {
            let topSpace: CGFloat = 132
            let cellListHeight = CGFloat(artSymbols.count) * cellHeight + topSpace
            if cellListHeight > 640 {
                return 640
            } else {
                return cellListHeight
            }
        }
    }
    
    enum Action: Equatable {
        case artSymbolsOrderMoved(IndexSet, Int)
        case artSymbol(id: ArtSymbolFeature.State.ID, action: ArtSymbolFeature.Action)
        case deleteButtonTapped(id: ArtSymbolFeature.State.ID)
        case delegate(Delegate)
        case duplicateButtonTapped(id: ArtSymbolFeature.State.ID)
        case overlayTapped
        
        enum Delegate: Equatable {
            case currentEditSymbolLayerTapped
            case editSymbolIDChanged(id: ArtSymbolFeature.State.ID)
            case hideButtonTapped(id: ArtSymbolFeature.State.ID)
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .artSymbolsOrderMoved:
                return .none
            case let .artSymbol(id, action: .layer(.hideButtonTapped)):
                return .run { send in
                    await send(.delegate(.hideButtonTapped(id: id)))
                }
            case let .artSymbol(id, action: .layer(.cellTapped)):
                if state.editSymbolID == id {
                    return .run { send in
                        await send(.delegate(.currentEditSymbolLayerTapped))
                    }
                }
                state.editSymbolID = id
                return .run { send in
                    await send(.delegate(.editSymbolIDChanged(id: id)))
                }
                
            case .artSymbol:
                return .none
            case .deleteButtonTapped:
                return .none
            case .delegate:
                return .none
            case .duplicateButtonTapped:
                return .none
            case .overlayTapped:
                return .none
            }
        }
        .forEach(\.artSymbols, action: /Action.artSymbol(id:action:)) {
            ArtSymbolFeature()
        }
    }
}

struct LayerPanelView: View {
    
    let store: StoreOf<LayerPanelFeature>
    
    var body: some View {
        
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            
            HStack {
                Rectangle()
                    .fill(.heavyDarkGray)
                    .opacity(0.0001)
                    .onTapGesture {
                        viewStore.send(.overlayTapped)
                    }
                
                VStack {
                    
                    List {
                        Text("Layer")
                            .foregroundStyle(.white)
                            .font(.title)
                            .bold()
                            .listRowBackground(Color.clear)
                            .frame(height: 56)
                        
                        ForEachStore(store.scope(
                            state: \.artSymbols,
                            action: LayerPanelFeature.Action.artSymbol)
                        ) { store in
                            
                            store.withState { state in
                                
                                ArtSymbolLayerCell(
                                    store: store.scope(
                                        state: \.layer,
                                        action: ArtSymbolFeature.Action.layer
                                    )
                                )
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    
                                    HStack {
                                        Button {
                                            viewStore.send(.deleteButtonTapped(id: state.id))
                                        } label: {
                                            Text("Delete")
                                        }
                                        .tint(.red)
                                        
                                        Button {
                                            viewStore.send(.duplicateButtonTapped(id: state.id))
                                        } label: {
                                            Text("Duplicate")
                                        }
                                        .tint(.gray)
                                    }
                                }
                                .listRowBackground(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(viewStore.state.editSymbolID == state.id ? Color.accentColor : .heavyDarkGray)
                                        .padding(8)
                                        .frame(height: viewStore.cellHeight)
                                )
                            }
                        }
                        .onMove { viewStore.send(.artSymbolsOrderMoved($0, $1)) }
                        .listRowInsets(.init(top: 8, leading: 4, bottom: 8, trailing: 0))
                        .listRowSeparator(.hidden)
                    }
                    .scrollContentBackground(.hidden)
                    .background(RoundedRectangle(cornerRadius: 16)
                        .fill(.heavyDarkGray2))
                    .frame(width: 280, height: viewStore.frameHeight)
                    .shadow(radius: 10)
                    .padding()
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    LayerPanelView(store: .init(
        initialState: LayerPanelFeature.State(
            artSymbols: IdentifiedArray.mock,
            editSymbolID: nil
        )) {
            LayerPanelFeature()
        }
    )
}

extension IdentifiedArray where ID == ArtSymbolFeature.State.ID, Element == ArtSymbolFeature.State {
  static let mock: Self = [
    ArtSymbolFeature.State(
        id: UUID(),
        appearance: .preview()
    ),
    ArtSymbolFeature.State(
        id: UUID(),
        appearance: .preview()
    ),
    ArtSymbolFeature.State(
        id: UUID(),
        appearance: .preview()
    ),
    ArtSymbolFeature.State(
        id: UUID(),
        appearance: .preview()
    ),
    ArtSymbolFeature.State(
        id: UUID(),
        appearance: .preview()
    ),
    ArtSymbolFeature.State(
        id: UUID(),
        appearance: .preview()
    ),
    ArtSymbolFeature.State(
        id: UUID(),
        appearance: .preview()
    ),
  ]
}
