//
//  ArtSymbolLayerCell.swift
//  SFSymbolsArtCreator
//
//

import ComposableArchitecture
import SwiftUI

struct ArtSymbolLayerFeature: Reducer {
    struct State: Equatable {
        var appearance: ArtSymbolAppearance
    }
    enum Action: Equatable {
        case hideButtonTapped
    }
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .hideButtonTapped:
                return .none
            }
        }
    }
}

struct ArtSymbolLayerCell: View {
    
    let store: StoreOf<ArtSymbolLayerFeature>
    
    var body: some View {
        
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            HStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.white)
                    .frame(width: 44, height: 44)
                    .overlay {
                        Image(systemName: viewStore.appearance.name)
                            .fontWeight(viewStore.appearance.weight)
                            .rotation3DEffect(.degrees(180),
                                              axis: (x: viewStore.appearance.flipType.value.rotationEffectAxis.x,
                                                     y: viewStore.appearance.flipType.value.rotationEffectAxis.y,
                                                     z: viewStore.appearance.flipType.value.rotationEffectAxis.z),
                                              anchorZ: 1)
                            .rotation3DEffect(.degrees(viewStore.appearance.rotationDegrees),
                                              axis: (x: 0, y: 0, z: 1), anchorZ: 1)
                            .symbolRenderingMode(viewStore.appearance.renderingType.renderingMode)
                            .foregroundStyle(viewStore.appearance.primaryColor,
                                             viewStore.appearance.secondaryColor,
                                             viewStore.appearance.tertiaryColor)
                    }
                
                Spacer()
                
                Button {
                    viewStore.send(.hideButtonTapped)
                } label: {
                    Image(symbol: viewStore.appearance.isHidden ? .eyeSlash : .eye)
                        .font(.system(size: 24))
                        .foregroundStyle(.paleGray)
                }
                .frame(width: 44, height: 44)
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.heavyDarkGray)
            }
        }
    }
}

#Preview {
    
    VStack {
        ArtSymbolLayerCell(store: .init(
            initialState: ArtSymbolLayerFeature.State(
                appearance: .preview())
        ) {
            ArtSymbolLayerFeature()
        })
        .frame(width: 200, height: 96)
        
        ArtSymbolLayerCell(store: .init(
            initialState: ArtSymbolLayerFeature.State(
                appearance: .preview(
                    name: "xmark",
                    renderingType: .palette,
                    primaryColor: .red,
                    secondaryColor: .blue
                )
            )
        ) {
            ArtSymbolLayerFeature()
        })
        .frame(width: 200, height: 96)
    }
}
