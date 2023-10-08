//
//  EditFormType.swift
//  SFSymbolsArtCreator
//
//

import Foundation

enum EditFormType: String, CaseIterable, Identifiable {
    
    case freeForm = "Free form"
    case uniform = "Uniform"
    
    var id: String {
        return self.rawValue
    }
    
    func scaledHeight(by scalingValue: EditPointScaling.Value, beforeHeight: CGFloat) -> CGFloat {
        
        let scaledHeight: CGFloat
        
        switch self {
        case .freeForm:
            scaledHeight = beforeHeight + scalingValue.scaleSize.height
        case .uniform:
            scaledHeight = beforeHeight + scalingValue.scaleValue
        }
        
        if scaledHeight > AppConfig.minScalingHeight {
            return scaledHeight
        } else {
            return beforeHeight
        }
    }
    
    func scaledWidth(by scalingValue: EditPointScaling.Value, beforeWidth: CGFloat) -> CGFloat {
        
        let scaledWidth: CGFloat
        
        switch self {
        case .freeForm:
            scaledWidth = beforeWidth + scalingValue.scaleSize.width
        case .uniform:
            scaledWidth = beforeWidth + scalingValue.scaleValue
        }
        
        if scaledWidth > AppConfig.minScalingWidth {
            return scaledWidth
        } else {
            return beforeWidth
        }
    }
}
