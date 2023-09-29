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

private extension Font.Weight {
    
    var sliderValue: CGFloat {
        switch self {
        case .black:
            return 9
        case .heavy:
            return 8
        case .bold:
            return 7
        case .semibold:
            return 6
        case .medium:
            return 5
        case .regular:
            return 4
        case .light:
            return 3
        case .thin:
            return 2
        case .ultraLight:
            return 1
        default:
            return 0
        }
    }
    
    init(sliderValue: CGFloat) {
        switch sliderValue {
        case 0:
            self = .regular
        case 1:
            self = .ultraLight
        case 2:
            self = .thin
        case 3:
            self = .light
        case 4:
            self = .regular
        case 5:
            self = .medium
        case 6:
            self = .semibold
        case 7:
            self = .bold
        case 8:
            self = .heavy
        case 9:
            self = .black
        default:
            self = .regular
        }
    }
}
