//
//  CatalogItemView.swift
//  SFSymbolsArtCreator
//
//

import SFUserFriendlySymbols
import SwiftUI

struct CatalogItemView: View {
    
    let symbol: SFSymbols
    let canvasLength: CGFloat
    let selectAction: (_ symbol: SFSymbols) -> Void
    
    private var halfCanvasLength: CGFloat {
        return canvasLength / 2
    }
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 8) {
            
            Spacer()
                .frame(height: 0)
            
            Button {
                selectAction(symbol)
            } label: {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(.white)
                    .frame(width: canvasLength, height: canvasLength)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.gray, lineWidth: 0.5)
                    )
                    .overlay {
                        Image(systemName: symbol.rawValue)
                            .font(.system(size: halfCanvasLength))
                            .foregroundColor(.black)
                    }
            }
            
            HStack {
                Spacer()
                
                Text(symbol.rawValue)
                    .frame(width: canvasLength, height: halfCanvasLength, alignment: .top)
                    .multilineTextAlignment(.center)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
            }
        }
    }
}

#Preview {
    Color.black.overlay {
        HStack(spacing: 12) {
                        
            CatalogItemView(
                symbol: .init(rawValue: "xmark")!,
                canvasLength: 72,
                selectAction: { _ in }
            )
            .frame(width: 72)
            
            CatalogItemView(
                symbol: .init(rawValue: "arrow.right.doc.on.clipboard")!,
                canvasLength: 72,
                selectAction: { _ in }
            )
            .frame(width: 72)
        }
    }
}
