//
//  ColorPickRectangleButton.swift
//  SFSymbolsArtCreator
//
//

import SwiftUI

struct ColorPickRectangleButton: View {
    
    let color: Color
    let tapAction: () -> Void
    
    var body: some View {
        
        Button {
            tapAction()
        } label: {
            
            Image(symbol: .squareFill)
                .resizable()
                .foregroundStyle(color.gradient)
                .frame(width: 40, height: 40)
                .overlay {
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(lineWidth: 1)
                        .foregroundStyle(.paleGray)
                }
        }
    }
}

#Preview {
    Color.heavyDarkGray
        .overlay {
            ColorPickRectangleButton(color: .red, tapAction: {})
        }
}
