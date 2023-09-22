//
//  CatalogItemView.swift
//  SFSymbolsArtCreator
//
//

import ComposableArchitecture
import SFUserFriendlySymbols
import SwiftUI

struct CatalogItemFeature: Reducer {
    
    struct State: Equatable, Identifiable {
        let canvasColor: Color
        let canvasLength: CGFloat
        let id: UUID
        let symbol: SFSymbols
        
        var imageFontSize: CGFloat {
            return canvasLength / 2
        }
        
        var symbolNameHeight: CGFloat {
            return canvasLength / 3
        }
    }
    
    enum Action: Equatable {
        case delegate(Delegate)
        case symbolTapped
        
        enum Delegate: Equatable {
            case selectSymbol(SFSymbols)
        }
    }
    
    var body: some ReducerOf<Self> {
        
        Reduce { state, action in
            switch action {
                
            case .delegate:
                return .none
            case .symbolTapped:
                return .run { [symbol = state.symbol] send in
                    await send(.delegate(.selectSymbol(symbol)))
                }
            }
        }
    }
}

struct CatalogItemView: View {
    
    let store: StoreOf<CatalogItemFeature>
    
    var body: some View {
        
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(alignment: .center, spacing: 8) {
                
                Spacer()
                    .frame(height: 0)
                
                Button {
                    viewStore.send(.symbolTapped)
                } label: {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(.white)
                        .frame(width: viewStore.canvasLength,
                               height: viewStore.canvasLength)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.gray, lineWidth: 0.5)
                        )
                        .overlay {
                            Image(symbol: viewStore.symbol)
                                .font(.system(size: viewStore.imageFontSize))
                                .foregroundColor(.black)
                        }
                }
                
                HStack {
                    Spacer()
                    
                    Text(viewStore.state.symbol.rawValue)
                        .frame(width: viewStore.canvasLength,
                               height: viewStore.symbolNameHeight,
                               alignment: .top)
                        .multilineTextAlignment(.center)
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    Color.black.overlay {
        HStack(spacing: 12) {
            
            CatalogItemView(store: .init(
                initialState: CatalogItemFeature.State(
                    canvasColor: .white,
                    canvasLength: 72,
                    id: UUID(),
                    symbol: SFSymbols(rawValue: "xmark")!)) {
                        CatalogItemFeature()
                    }
            )
            .frame(width: 72)
            
            CatalogItemView(store: .init(
                initialState: CatalogItemFeature.State(
                    canvasColor: .white,
                    canvasLength: 72,
                    id: UUID(),
                    symbol: SFSymbols(rawValue: "arrow.right.doc.on.clipboard")!)) {
                        CatalogItemFeature()
                    }
            )
            .frame(width: 72)
        }
    }
}
