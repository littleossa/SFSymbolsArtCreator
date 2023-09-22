//
//  SearchBar.swift
//  SFSymbolsArtCreator
//
//

import SFUserFriendlySymbols
import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        Rectangle()
            .fill(.gray)
            .overlay {
                HStack(spacing: 4) {
                    
                    Image(symbol: .magnifyingglass)
                        .foregroundStyle(Color(uiColor: .placeholderText))
                    
                    TextField(
                        "Search text",
                        text: $text,
                        prompt: Text("Look for SF Symbols...")
                    )
                    .foregroundStyle(.black)
                    
                    if text != "" {
                        
                        Button {
                            text = ""
                        } label: {
                            Image(symbol: .xCircleFill)
                                .resizable()
                                .frame(width: 16, height: 16)
                                .scaledToFit()
                        }
                        .foregroundStyle(.gray)
                    }
                }
                .padding(.horizontal, 8)
            }
            .frame(height: 36)
            .cornerRadius(8)
    }
}

#Preview {
    SearchBar(text: .constant(""))
        .frame(width: 300)
}
