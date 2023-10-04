//
//  ResizeButton.swift
//  SFSymbolsArtCreator
//
//

import SwiftUI

struct ResizeButton: View {
    
    let isExpanded: Bool
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                Image(symbol: .circleFill)
                    .resizable()
                    .foregroundStyle(.black)
                
                Image(symbol: isExpanded ? .minusCircleFill : .arrowUpLeftAndArrowDownRightCircleFill)
                    .resizable()
            }
            .frame(width: 24, height: 24)
        }
    }
}

#Preview {
    HStack {
        ResizeButton(isExpanded: true, action: {})
        ResizeButton(isExpanded: false, action: {})
    }
}
