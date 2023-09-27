//
//  FlipType.swift
//  SFSymbolsArtCreator
//
//

import Foundation

enum FlipType {
    case horizontal
    case horizontalAndVertical
    case none
    case vertical
    
    var rotationEffectAxis: (x: CGFloat, y: CGFloat, z: CGFloat) {
        
        switch self {
        case .horizontal:
            return (x: 0, y: 1, z: 0)
        case .horizontalAndVertical:
            return (x: 0, y: 0, z: 1)
        case .none:
            return (x: 0, y: 0, z: 0)
        case .vertical:
            return (x: 1, y: 0, z: 0)
        }
    }
}

