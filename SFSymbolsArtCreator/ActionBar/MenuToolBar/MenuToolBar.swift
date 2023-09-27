//
//  MenuToolBar.swift
//  SFSymbolsArtCreator
//
//

import ComposableArchitecture
import SwiftUI

// TODO: まだやることがまとまっていない為、後で更新
struct MenuToolFeature: Reducer {
    struct State: Equatable {
    }
    
    enum Action: Equatable {
        case artWorksButtonTapped
        case shareButtonTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .artWorksButtonTapped:
                print("Back to artworks")
                return .none
            case .shareButtonTapped:
                print("present share")
                return .none
            }
        }
    }
}

struct MenuToolBar: View {
    
    let store: StoreOf<MenuToolFeature>
    
    var body: some View {
        
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            HStack(spacing: 48) {
                
                Button {
                } label: {
                    Label("Art works", systemImage: "chevron.left")
                        .font(.title)
                        .bold()
                }
                .foregroundStyle(.paleGray)
                .padding(.leading)
                
                Button {
                } label: {
                    Image(symbol: .squareAndArrowUpCircleFill)
                        .resizable()
                        .scaledToFit()
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.paleGray, .black)
                }
                .frame(width: 44, height: 44)
                .foregroundStyle(.paleGray)
                
                Spacer()
            }
            .frame(height: 72)
            .background(.heavyDarkGray)
        }
    }
}

#Preview {
    Color.black
        .overlay {
            MenuToolBar(store: .init(
                initialState: MenuToolFeature.State()) {
                    MenuToolFeature()
                }
            )
        }
}
