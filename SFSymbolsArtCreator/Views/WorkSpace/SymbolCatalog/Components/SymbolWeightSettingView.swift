//
//  SymbolWeightSettingView.swift
//  SFSymbolsArtCreator
//
//

import SwiftUI

struct SymbolWeightSettingView: View {
    
    @Binding var weight: Font.Weight
    var body: some View {
        
        AccordionSettingView(title: "Weight") {
            Slider(
                value: .init(
                    get: { weight.sliderValue },
                    set: { weight = Font.Weight(sliderValue: $0) }
                ),
                in: 1...9,
                step: 1
            )
            .padding(.bottom)
            .padding(.trailing)
        }
    }
}

#Preview {
    Color.heavyDarkGray
        .overlay {
            SymbolWeightSettingView(weight: .constant(.bold))
                .frame(width: 284, height: 500)
    }
}
