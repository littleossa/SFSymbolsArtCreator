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
    
    var value: Self.Value {
        switch self {
        case .horizontal:
            return Value(isFlippedHorizontal: true,
                         isFlippedVertical: false,
                         rotationEffectAxis: .init(x: 0, y: 1, z: 0))
        case .horizontalAndVertical:
            return Value(isFlippedHorizontal: true,
                         isFlippedVertical: true,
                         rotationEffectAxis: .init(x: 0, y: 0, z: 1))
        case .none:
            return Value(isFlippedHorizontal: false,
                         isFlippedVertical: false,
                         rotationEffectAxis: .init(x: 0, y: 0, z: 0))
        case .vertical:
            return Value(isFlippedHorizontal: false,
                         isFlippedVertical: true,
                         rotationEffectAxis: .init(x: 1, y: 0, z: 0))
        }
    }
    
    struct Value {
        let isFlippedHorizontal: Bool
        let isFlippedVertical: Bool
        let rotationEffectAxis: RotationEffectAxis
    }
}
