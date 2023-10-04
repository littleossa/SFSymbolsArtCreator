//
//  VerticalSymbolLabelButton.swift
//  SFSymbolsArtCreator
//
//

import SFUserFriendlySymbols
import SwiftUI

struct VerticalSymbolLabelButton: View {
    let title: LocalizedStringKey
    let symbol: SFSymbols
    let action: () -> Void
    
    var body: some View {
        VerticalLabelButton(title: title) {
            action()
        } content: {
            Image(symbol: symbol)
                .resizable()
                .scaledToFit()
                .frame(width: 28, height: 28)
        }
    }
}

#Preview {
    Color.heavyDarkGray
        .overlay {
            VerticalSymbolLabelButton(
                title: "Flip Horizontal",
                symbol: ._00CircleFill
            ) {}
            .frame(width: 88, height: 44)
            .foregroundStyle(.white)
        }
}
