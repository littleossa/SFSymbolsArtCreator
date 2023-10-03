//
//  FlipType.swift
//  SFSymbolsArtCreator
//
//

import Foundation

extension FlipType {
    
    init(isFlippedHorizontal: Bool, isFlippedVertical: Bool) {
        if isFlippedHorizontal,
           isFlippedVertical {
            self = .horizontalAndVertical
        } else if isFlippedHorizontal {
            self = .horizontal
        } else if isFlippedVertical {
            self = .vertical
        } else {
            self = .none
        }
    }
}

enum FlipType {
    case horizontal
    case horizontalAndVertical
    case none
    case vertical
    
    var rotationEffectAxis: RotationEffectAxis {
        
        switch self {
        case .horizontal:
            return .init(x: 0, y: 1, z: 0)
        case .horizontalAndVertical:
            return .init(x: 0, y: 0, z: 1)
        case .none:
            return .init(x: 0, y: 0, z: 0)
        case .vertical:
            return .init(x: 1, y: 0, z: 0)
        }
    }
}
