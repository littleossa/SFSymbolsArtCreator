//
//  FontWeight+Extension.swift
//  SFSymbolsArtCreator
//
//

import SwiftUI

// MARK: - Initializer
extension Font.Weight {
    
    init(sliderValue: CGFloat) {
        switch sliderValue {
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
            fatalError("\(sliderValue) is not determined as a slider value")
        }
    }
}

extension Font.Weight {
    
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
            fatalError("\(self) is not determined for slider value")
        }
    }
    
    /// Decrease Font.Weight if the weight is not ultra light
    func decreased() -> Font.Weight {
        if self == .ultraLight {
            return self
        }
        
        let value = self.sliderValue
        let decreasedValue = value - 1
        
        return Font.Weight(sliderValue: decreasedValue)
    }
    
    /// increase Font.Weight if the weight is not black
    func increased() -> Font.Weight {
        if self == .black {
            return self
        }
        
        let value = self.sliderValue
        let increasedValue = value + 1
        
        return Font.Weight(sliderValue: increasedValue)
    }
}

