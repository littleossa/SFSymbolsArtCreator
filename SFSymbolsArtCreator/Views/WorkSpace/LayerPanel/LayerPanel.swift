//
//  LayerPanel.swift
//  SFSymbolsArtCreator
//
//

import ComposableArchitecture
import SwiftUI

struct LayerPanelFeature: Reducer {
    struct State: Equatable {
        var artSymbols: IdentifiedArrayOf<ArtSymbolFeature.State>
        
        var frameHeight: CGFloat {
            let topSpace = 132
            let cellFrameWithPadding = 90
            let height = artSymbols.count * cellFrameWithPadding + topSpace
            if height > 640 {
                return 640
            } else {
                return CGFloat(height)
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
                            ArtSymbolLayerCell(
                                store: store.scope(
                                    state: \.layer,
                                    action: ArtSymbolFeature.Action.layer
                                )
                            )
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                
                                HStack {
                                    Button {
                                        print()
                                    } label: {
                                        Text("Delete")
                                    }
                                    .tint(.red)
                                    
                                    Button {
                                        print()
                                    } label: {
                                        Text("Duplicate")
                                    }
                                    .tint(.gray)
                                }
                            }
                        }
                        .onMove { viewStore.send(.artSymbolsOrderMoved($0, $1)) }
                        .listRowInsets(.init(top: 8, leading: 4, bottom: 8, trailing: 0))
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.heavyDarkGray2)
                                .padding(8)
                        )
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
            artSymbols: IdentifiedArray.mock
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
