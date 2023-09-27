//
//  RenderingMenuButton.swift
//  SFSymbolsArtCreator
//
//

import SwiftUI

struct RenderingMenuButton: View {
    
    let type: RenderingType
    let selectAction: (_ renderingType: RenderingType) -> Void
    
    var body: some View {
        Menu {
            ForEach(RenderingType.allCases) { type in
                
                Button(action: {
                    selectAction(type)
                }, label: {
                    Text(type.displayLabel)
                })
            }
            
        } label: {
            RoundedRectangle(cornerRadius: 8)
                .fill(.paleGray)
                .overlay {
                    Text(self.type.displayLabel)
                    .font(.title2)
                }
        }
    }
}

#Preview {
    Color.black
        .overlay {
            RenderingMenuButton(type: .monochrome) { _ in
            }
            .frame(width: 200, height: 48)
        }
}

