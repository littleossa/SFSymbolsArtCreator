//
//  CatalogItemView.swift
//  SFSymbolsArtCreator
//
//

import ComposableArchitecture
import SFUserFriendlySymbols
import SwiftUI

struct CatalogItemView: View {
    
    let backgroundColor: Color
    let fontWeight: Font.Weight
    let primaryColor: Color
    let renderingType: RenderingType
    let secondaryColor: Color
    let squareLength: CGFloat
    let symbol: SFSymbols
    let selectAction: () -> Void
    let tertiaryColor: Color
    
    init(symbol: SFSymbols,
         weight: Font.Weight,
         primaryColor: Color,
         secondaryColor: Color,
         tertiaryColor: Color,
         renderingType: RenderingType,
         backgroundColor: Color,
         squareLength: CGFloat,
         selectAction: @escaping () -> Void) {
        self.backgroundColor = backgroundColor
        self.fontWeight = weight
        self.primaryColor = primaryColor
        self.renderingType = renderingType
        self.secondaryColor = secondaryColor
        self.squareLength = squareLength
        self.symbol = symbol
        self.selectAction = selectAction
        self.tertiaryColor = tertiaryColor
    }
    
    var imageFontSize: CGFloat {
        return squareLength / 2
    }
    
    var symbolNameHeight: CGFloat {
        return squareLength / 1.75
    }
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 8) {
            
            Spacer()
                .frame(height: 0)
            
            Button {
                selectAction()
            } label: {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(backgroundColor)
                    .frame(width: squareLength,
                           height: squareLength)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.gray, lineWidth: 0.5)
                    )
                    .overlay {
                        Image(symbol: symbol)
                            .font(.system(size: imageFontSize,
                                          weight: fontWeight))
                            .symbolRenderingMode(renderingType.renderingMode)
                            .foregroundStyle(primaryColor,
                                             secondaryColor,
                                             tertiaryColor)
                    }
            }
            
            HStack {
                Spacer()
                
                Text(symbol.rawValue)
                    .frame(width: squareLength,
                           height: symbolNameHeight,
                           alignment: .top)
                    .multilineTextAlignment(.center)
                    .font(.caption)
                    .foregroundStyle(.paleGray)
                
                Spacer()
            }
        }
    }
}

#Preview {
    Color.heavyDarkGray.overlay {
        HStack(spacing: 12) {
            
            CatalogItemView(
                symbol: SFSymbols(rawValue: "xmark")!,
                weight: .regular,
                primaryColor: .black,
                secondaryColor: .accentColor,
                tertiaryColor: .black,
                renderingType: .monochrome,
                backgroundColor: .white,
                squareLength: 72,
                selectAction: {}
            )
            .frame(width: 72)
            
            CatalogItemView(
                symbol: SFSymbols(rawValue: "arrow.right.doc.on.clipboard")!,
                weight: .black,
                primaryColor: .red,
                secondaryColor: .accentColor,
                tertiaryColor: .black,
                renderingType: .hierarchical,
                backgroundColor: .black,
                squareLength: 72,
                selectAction: {}
            )
            .frame(width: 72)
        }
    }
}
