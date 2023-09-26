//
//  ColorPickCircleButton.swift
//  SFSymbolsArtCreator
//
//

import SwiftUI

struct ColorPickCircleButton: View {
    
    let color: Color
    let isDisabled: Bool
    let tapAction: () -> Void
    
    var body: some View {
        
        Button {
            tapAction()
        } label: {
            
            if isDisabled {
                Image(symbol: .nosign)
                    .resizable()
                    .foregroundStyle(.paleGray)
                    .fontWeight(.thin)
                    .frame(width: 40, height: 40)
            } else {
                Image(symbol: .circleFill)
                    .resizable()
                    .foregroundStyle(color.gradient)
                    .frame(width: 40, height: 40)
                    .overlay {
                        Circle()
                            .stroke(lineWidth: 1)
                            .foregroundStyle(.paleGray)
                    }
            }
        }
        .disabled(isDisabled)
    }
}

#Preview {
    Color.heavyDarkGray
        .overlay {
            VStack {
                ColorPickCircleButton(color: .red, isDisabled: true, tapAction: {})
                ColorPickCircleButton(color: .red, isDisabled: false, tapAction: {})
            }
        }
}
