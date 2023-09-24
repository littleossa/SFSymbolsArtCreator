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
    
        let backgroundColor: Color
        let fontWeight: Font.Weight
        let id: UUID
        let primaryColor: Color
        let renderingType: RenderingType
        let secondaryColor: Color
        let squareLength: CGFloat
        let symbol: SFSymbols
        let tertiaryColor: Color
        
        init(id: UUID = UUID(),
             symbol: SFSymbols,
             weight: Font.Weight,
             primaryColor: Color,
             secondaryColor: Color,
             tertiaryColor: Color,
             renderingType: RenderingType,
             backgroundColor: Color,
             squareLength: CGFloat) {
            self.backgroundColor = backgroundColor
            self.fontWeight = weight
            self.id = id
            self.primaryColor = primaryColor
            self.renderingType = renderingType
            self.secondaryColor = secondaryColor
            self.squareLength = squareLength
            self.symbol = symbol
            self.tertiaryColor = tertiaryColor
        }
        
        var imageFontSize: CGFloat {
            return squareLength / 2
        }
        
        var symbolNameHeight: CGFloat {
            return squareLength / 1.75
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
                        .foregroundColor(viewStore.backgroundColor)
                        .frame(width: viewStore.squareLength,
                               height: viewStore.squareLength)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.gray, lineWidth: 0.5)
                        )
                        .overlay {
                            Image(symbol: viewStore.symbol)
                                .font(.system(size: viewStore.imageFontSize,
                                              weight: viewStore.fontWeight))
                                .symbolRenderingMode(viewStore.renderingType.renderingMode)
                                .foregroundStyle(viewStore.primaryColor,
                                                 viewStore.secondaryColor,
                                                 viewStore.tertiaryColor)
                        }
                }
                
                HStack {
                    Spacer()
                    
                    Text(viewStore.state.symbol.rawValue)
                        .frame(width: viewStore.squareLength,
                               height: viewStore.symbolNameHeight,
                               alignment: .top)
                        .multilineTextAlignment(.center)
                        .font(.caption)
                        .foregroundStyle(.paleGray)
                    
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
                    weight: .regular,
                    primaryColor: .black,
                    secondaryColor: .accentColor,
                    tertiaryColor: .black,
                    renderingType: .monochrome,
                    backgroundColor: .white,
                    squareLength: 72)) {
                        CatalogItemFeature()
                    }
            )
            .frame(width: 72)
            
            CatalogItemView(store: .init(
                initialState: CatalogItemFeature.State(
                    symbol: SFSymbols(rawValue: "arrow.right.doc.on.clipboard")!,
                    weight: .black,
                    primaryColor: .red,
                    secondaryColor: .accentColor,
                    tertiaryColor: .black,
                    renderingType: .hierarchical,
                    backgroundColor: .black,
                    squareLength: 72)) {
                        CatalogItemFeature()
                    }
            )
            .frame(width: 72)
        }
    }
}
