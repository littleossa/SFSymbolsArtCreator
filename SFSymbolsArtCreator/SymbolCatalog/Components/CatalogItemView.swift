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
        let primaryColor: Color
        let secondaryColor: Color
        let symbol: SFSymbols
        let tertiaryColor: Color
        
        init(id: UUID = UUID(),
             symbol: SFSymbols,
             primaryColor: Color,
             secondaryColor: Color,
             tertiaryColor: Color,
             canvasColor: Color,
             canvasLength: CGFloat) {
            self.canvasColor = canvasColor
            self.canvasLength = canvasLength
            self.id = id
            self.primaryColor = primaryColor
            self.secondaryColor = secondaryColor
            self.symbol = symbol
            self.tertiaryColor = tertiaryColor
        }
        
        var imageFontSize: CGFloat {
            return canvasLength / 2
        }
        
        var symbolNameHeight: CGFloat {
            return canvasLength / 1.75
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
                        .foregroundColor(.paleGray)
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    Color.heavyDarkGray.overlay {
        HStack(spacing: 12) {
            
            CatalogItemView(store: .init(
                initialState: CatalogItemFeature.State(
                    symbol: SFSymbols(rawValue: "xmark")!,
                primaryColor: .black,
                    secondaryColor: .accentColor,
                    tertiaryColor: .black,
                    canvasColor: .white,
                    canvasLength: 72)) {
                        CatalogItemFeature()
                    }
            )
            .frame(width: 72)
            
            CatalogItemView(store: .init(
                initialState: CatalogItemFeature.State(
                    symbol: SFSymbols(rawValue: "arrow.right.doc.on.clipboard")!,
                    primaryColor: .white,
                    secondaryColor: .accentColor,
                    tertiaryColor: .black,
                    canvasColor: .black,
                    canvasLength: 72)) {
                        CatalogItemFeature()
                    }
            )
            .frame(width: 72)
        }
    }
}
