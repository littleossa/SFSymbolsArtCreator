//
//  DrawToolBar.swift
//  SFSymbolsArtCreator
//
//

import ComposableArchitecture
import SwiftUI

struct DrawToolFeature: Reducer {
    struct State: Equatable {
        var isEditMode = false
        var layerPanelIsPresented = false
        var renderingType: RenderingType
    }
    enum Action: Equatable {
        case editButtonTapped
        case delegate(Delegate)
        case layerButtonTapped
        case renderingTypeChanged(RenderingType)
        
        enum Delegate: Equatable {
            case editButtonToggled(Bool)
            case layerButtonToggled(Bool)
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .editButtonTapped:
                state.layerPanelIsPresented = false
                state.isEditMode.toggle()
                return .run { [isEditMode = state.isEditMode] send in
                    await send(.delegate(.editButtonToggled(isEditMode)))
                }
                
            case .delegate:
                return .none
                
            case .layerButtonTapped:
                state.layerPanelIsPresented.toggle()
                return .run { [isPresented = state.layerPanelIsPresented] send in
                    await send(.delegate(.layerButtonToggled(isPresented)))
                }
                
            case let .renderingTypeChanged(renderingType):
                state.layerPanelIsPresented = false
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
                    viewStore.send(.editButtonTapped)
                } label: {
                    Image(symbol: .squareshapeSquareshapeDashed)
                        .resizable()
                        .scaledToFit()
                }
                .frame(width: 44, height: 44)
                .foregroundStyle(viewStore.isEditMode ? Color.accentColor : .paleGray)
                
                Button {
                    viewStore.send(.layerButtonTapped)
                } label: {
                    Image(symbol: .square3Stack3DTopFilled)
                        .resizable()
                        .scaledToFit()
                }
                .frame(width: 44, height: 44)
                .foregroundStyle(viewStore.layerPanelIsPresented ? Color.accentColor : .paleGray)
                
                RenderingMenuButton(type: viewStore.renderingType) { type in
                    viewStore.send(.renderingTypeChanged(type))
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
                initialState: DrawToolFeature.State(renderingType: .monochrome)
            ) {
                DrawToolFeature()
            })
        }
}
