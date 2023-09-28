//
//  CatalogBackgroundColorSettingView.swift
//  SFSymbolsArtCreator
//
//

import SwiftUI

struct CatalogBackgroundColorSettingView: View {
    
    @Binding var backgroundColorItem: ColorItem
    let canvasColor: Color
    
    private var selectionItems: [ColorItem] {
        return [
            .white,
            .black,
            .init(canvasColor: canvasColor)
        ]
    }
    
    var body: some View {
        AccordionSettingView(title: "Background") {
            
            HStack(spacing: 16) {
                ForEach(selectionItems) { item in
                    
                    Button {
                        backgroundColorItem = item
                    } label: {
                        Circle()
                            .fill(item.color)
                    }
                    .frame(width: 44, height: 44)
                    .overlay {
                        if backgroundColorItem.id == item.id {
                            Circle()
                                .stroke(lineWidth: 4)
                                .foregroundStyle(.tint)
                        }
                    }
                }
                Spacer()
            }
            .padding(.bottom)
            .padding(.trailing)
        }
    }
}

#Preview {
    Color.heavyDarkGray
        .overlay {
            CatalogBackgroundColorSettingView(
                backgroundColorItem: .constant(.white),
                canvasColor: .black
            )
            .frame(width: 284, height: 500)
        }
}
