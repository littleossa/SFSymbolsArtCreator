//
//  DrawToolBar.swift
//  SFSymbolsArtCreator
//
//

import ComposableArchitecture
import SwiftUI

struct DrawToolFeature: Reducer {
    struct State: Equatable {
        var isEraserMode = false
        var isEditMode = false
        var layerPanelIsPresented = false
        var renderingType: RenderingType = .monochrome
    }
    enum Action: Equatable {
        case editButtonTapped
        case eraserButtonTapped
        case delegate(Delegate)
        case layerButtonTapped
        case renderingChanged(RenderingType)
        
        enum Delegate: Equatable {
            case changeRenderingType(RenderingType)
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .editButtonTapped:
                state.isEditMode.toggle()
                return .none
                
            case .eraserButtonTapped:
                state.isEraserMode.toggle()
                return .none
                
            case .delegate:
                return .none
                
            case .layerButtonTapped:
                state.layerPanelIsPresented.toggle()
                return .none
                
            case let .renderingChanged(renderingType):
                state.renderingType = renderingType
                return .run { send in
                    await send(.delegate(.changeRenderingType(renderingType)))
                }
            }
        }
    }
}

struct DrawToolBar: View {
    
    let store: StoreOf<DrawToolFeature>
    
    var body: some View {
        
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            HStack(spacing: 48) {
                Spacer()
                
                Button {
                    store.send(.editButtonTapped)
                } label: {
                    Image(symbol: .squareshapeSquareshapeDashed)
                        .resizable()
                        .scaledToFit()
                }
                .frame(width: 44, height: 44)
                .foregroundStyle(viewStore.isEditMode ? Color.accentColor : .paleGray)
                
                Button {
                    store.send(.eraserButtonTapped)
                } label: {
                    // FIXME: SFUserFriendlySymbols is not supported for eraser
                    Image(systemName: "eraser.fill")
                        .resizable()
                        .scaledToFit()
                }
                .frame(width: 44, height: 44)
                .foregroundStyle(viewStore.isEraserMode ? Color.accentColor : .paleGray)
                
                Button {
                    store.send(.layerButtonTapped)
                } label: {
                    Image(symbol: .square3Stack3DTopFilled)
                        .resizable()
                        .scaledToFit()
                }
                .frame(width: 44, height: 44)
                .foregroundStyle(viewStore.layerPanelIsPresented ? Color.accentColor : .paleGray)
                
                RenderingMenuButton(type: viewStore.renderingType) { type in
                    viewStore.send(.renderingChanged(type))
                }
                .bold()
                .frame(width: 180, height: 44)
                .padding(.trailing)
            }
            .frame(height: 72)
            .background(.heavyDarkGray)
        }
    }
}

#Preview {
    Color.black
        .overlay {
            DrawToolBar(store: .init(
                initialState: DrawToolFeature.State()
            ) {
                DrawToolFeature()
            })
        }
}
