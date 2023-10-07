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
    
    func scaledHeight(by scalingValue: EditPointScaling.Value, beforeHeight: CGFloat) -> CGFloat? {
        
        let scaledHeight: CGFloat
        
        switch self {
        case .freeForm:
            scaledHeight = beforeHeight + scalingValue.scaleSize.height
        case .uniform:
            scaledHeight = beforeHeight + scalingValue.scaleValue
        }
        
        guard scaledHeight > AppConfig.minScalingHeight
        else { return nil }
        
        return scaledHeight
    }
    
    func scaledWidth(by scalingValue: EditPointScaling.Value, beforeWidth: CGFloat) -> CGFloat? {
        
        let scaledWidth: CGFloat
        
        switch self {
        case .freeForm:
            scaledWidth = beforeWidth + scalingValue.scaleSize.width
        case .uniform:
            scaledWidth = beforeWidth + scalingValue.scaleValue
        }
        
        guard scaledWidth > AppConfig.minScalingWidth
        else { return nil }
        
        return scaledWidth
    }
}
