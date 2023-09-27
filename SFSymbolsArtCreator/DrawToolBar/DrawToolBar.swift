//
//  DrawToolBar.swift
//  SFSymbolsArtCreator
//
//

import ComposableArchitecture
import SwiftUI

struct DrawToolFeature: Reducer {
    struct State: Equatable {
        var inEraserMode = false
        var isEditMode = false
        var layerPanelIsPresented = false
        var renderingType: RenderingType = .monochrome
    }
    enum Action: Equatable {
        case editButtonTapped
        case eraserButtonTapped
        case layerButtonTapped
        case renderingChanged(RenderingType)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .editButtonTapped:
                state.isEditMode.toggle()
                return .none
                
            case .eraserButtonTapped:
                state.inEraserMode.toggle()
                return .none
                
            case .layerButtonTapped:
                state.layerPanelIsPresented.toggle()
                return .none
                
            case let .renderingChanged(renderingType):
                state.renderingType = renderingType
                return .none
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
                .frame(width: 48, height: 48)
                .foregroundStyle(viewStore.isEditMode ? Color.accentColor : .paleGray)
                
                Button {
                    store.send(.eraserButtonTapped)
                } label: {
                    // FIXME: SFUserFriendlySymbols is not supported for eraser
                    Image(systemName: "eraser.fill")
                        .resizable()
                        .scaledToFit()
                }
                .frame(width: 48, height: 48)
                .foregroundStyle(viewStore.inEraserMode ? Color.accentColor : .paleGray)
                
                Button {
                    store.send(.layerButtonTapped)
                } label: {
                    Image(symbol: .square3Stack3DTopFilled)
                        .resizable()
                        .scaledToFit()
                }
                .frame(width: 48, height: 48)
                .foregroundStyle(viewStore.layerPanelIsPresented ? Color.accentColor : .paleGray)
                
                RenderingMenuButton(type: viewStore.renderingType) { type in
                    viewStore.send(.renderingChanged(type))
                }
                .bold()
                .frame(width: 200, height: 48)
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

struct RenderingMenuButton: View {
    
    let type: RenderingType
    let selectAction: (_ renderingType: RenderingType) -> Void
    
    var body: some View {
        Menu {
            ForEach(RenderingType.allCases) { type in
                
                Button(action: {
                    selectAction(type)
                }, label: {
                    Text(type.displayLabel)
                })
            }
            
        } label: {
            RoundedRectangle(cornerRadius: 8)
                .fill(.paleGray)
                .overlay {
                    Text(self.type.displayLabel)
                    .font(.title2)
                }
        }
    }
}

#Preview {
    Color.black
        .overlay {
            RenderingMenuButton(type: .monochrome) { _ in
            }
            .frame(width: 200, height: 48)
        }
}
