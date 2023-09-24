//
//  CatalogBackgroundColorSettingView.swift
//  SFSymbolsArtCreator
//
//

import SwiftUI

struct CatalogBackgroundColorSettingView: View {
    
    @Binding var color: Color
    private let selection: [Color] = [
        .white,
        .black
    ]
    
    var body: some View {
        AccordionSettingView(title: "Background") {
            
            HStack(spacing: 16) {
                ForEach(selection, id: \.self) { color in
                    
                    Button {
                        self.color = color
                    } label: {
                        Circle()
                            .fill(color)
                    }
                    .frame(width: 48, height: 48)
                    .overlay {
                        if self.color == color {
                            Circle()
                                .stroke(lineWidth: 4)
                                .foregroundStyle(.tint)
                        }
                    }
                }
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    Color.heavyDarkGray
        .overlay {
            CatalogBackgroundColorSettingView(color: .constant(.black))
                .frame(width: 284, height: 500)
        }
}
