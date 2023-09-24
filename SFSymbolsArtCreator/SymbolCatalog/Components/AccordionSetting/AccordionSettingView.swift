//
//  AccordionSettingView.swift
//  SFSymbolsArtCreator
//
//

import SwiftUI

struct AccordionSettingView<Content: View>: View {
    
    let content: Content
    @State private var isOpen = false
    let title: LocalizedStringKey
    
    init(title: LocalizedStringKey,
         @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        
        VStack(spacing: 8) {
            HStack {
                Text(title)
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.white)
                
                Spacer()
                
                Button {
                    withAnimation {
                        isOpen.toggle()
                    }
                } label: {
                    Image(symbol: .chevronRight)
                        .bold()
                        .rotationEffect(.degrees(isOpen ? 90 : 0))
                }
                .foregroundStyle(.tint)
                .frame(width: 44, height: 44)
            }
            
            if isOpen {
                content
            }
            
            Divider()
                .background(.gray)
        }
    }
}

#Preview {
    
    Color.heavyDarkGray
        .overlay {
            AccordionSettingView(title: "メニュー") {
                Text("Content")
            }
                .frame(width: 284, height: 500)
        }
}
