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
    }
    
    enum Action: Equatable {
        case artSymbolsOrderMoved(IndexSet, Int)
        case deleteButtonTapped(IndexSet)
        case duplicateButtonTapped(id: ArtSymbolFeature.State.ID)
        case hideButtonTapped(id: ArtSymbolFeature.State.ID)
        case overlayTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case .artSymbolsOrderMoved:
                return .none
            case .deleteButtonTapped:
                return .none
            case .duplicateButtonTapped:
                return .none
            case .hideButtonTapped:
                return .none
            case .overlayTapped:
                return .none
            }
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
                
                List {
                    ForEach(viewStore.artSymbols, id: \.self) {
                        
                        ArtSymbolLayerCell(artSymbol: $0) { id in
                            viewStore.send(.hideButtonTapped(id: id))
                        }
                    }
                    .onDelete { viewStore.send(.deleteButtonTapped($0)) }
                    .onMove { viewStore.send(.artSymbolsOrderMoved($0, $1)) }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button {
                            print()
                        } label: {
                            Text("duplicate")
                        }
                        .tint(.gray)
                    }
                }
                .listRowBackground(Rectangle().fill(.clear))
                .frame(width: 280)
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
        symbolName: "checkmark.icloud",
        width: 44,
        height: 44,
        weight: .regular,
        position: CGPoint(x: 50, y: 50),
        renderingType: .monochrome,
        primaryColor: .black,
        secondaryColor: .clear,
        tertiaryColor: .clear
    ),
    ArtSymbolFeature.State(
        id: UUID(),
        symbolName: "checkmark",
        width: 70,
        height: 30,
        weight: .regular,
        position: CGPoint(x: 70, y: 30),
        renderingType: .monochrome,
        primaryColor: .black,
        secondaryColor: .clear,
        tertiaryColor: .clear
    ),
    ArtSymbolFeature.State(
        id: UUID(),
        symbolName: "xmark",
        width: 30,
        height: 70,
        weight: .regular,
        position: CGPoint(x: 30, y: 70),
        renderingType: .monochrome,
        primaryColor: .black,
        secondaryColor: .clear,
        tertiaryColor: .clear,
        rotationDegrees: 45
    ),
  ]
}

//swipe actionの複製メソッド
//swipe delete禁止
