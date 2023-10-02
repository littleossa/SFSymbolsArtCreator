//
//  VerticalLabelButton.swift
//  SFSymbolsArtCreator
//
//

import SwiftUI

struct VerticalLabelButton<Content: View>: View {
    
    let title: LocalizedStringKey
    let action: () -> Void
    let content: Content

    init(title: LocalizedStringKey,
         action: @escaping () -> Void,
         @ViewBuilder content: () -> Content) {
        self.action = action
        self.content = content()
        self.title = title
    }
    
    var body: some View {
        
        VStack {
            Button(action: {
                action()
            }, label: {
                content
            })
            
            Text(title)
                .font(.caption)
        }
    }
}

#Preview {
    Color.heavyDarkGray
        .overlay {
            VerticalLabelButton(title: "Flip Horizontal", action: {
            }, content: {
                Image(symbol: .arrowLeftAndRightRighttriangleLeftRighttriangleRightFill)
                    .font(.system(size: 32))
            })
            .frame(width: 88, height: 44)
            .foregroundStyle(.white)
        }
}

