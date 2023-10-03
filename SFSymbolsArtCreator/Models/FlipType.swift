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
    
    var isFlippedHorizontal: Bool {
        switch self {
        case .horizontal:
            return true
        case .horizontalAndVertical:
            return true
        case .none:
            return false
        case .vertical:
            return false
        }
    }
    
    var isFlippedVertical: Bool {
        switch self {
        case .horizontal:
            return false
        case .horizontalAndVertical:
            return true
        case .none:
            return false
        case .vertical:
            return true
        }
    }
    
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
