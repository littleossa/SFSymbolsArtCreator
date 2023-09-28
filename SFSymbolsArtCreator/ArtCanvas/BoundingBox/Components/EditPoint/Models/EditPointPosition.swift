//
//  EditPointPosition.swift
//  BoundingBox
//

import SwiftUI

enum EditPointPosition {
    case topLeft
    case topCenter
    case topRight
    case middleLeft
    case middleRight
    case bottomLeft
    case bottomCenter
    case bottomRight
    
    var alignment: Alignment {
        switch self {
        case .topLeft:
            return .topLeading
        case .topCenter:
            return .top
        case .topRight:
            return .topTrailing
        case .middleLeft:
            return .leading
        case .middleRight:
            return .trailing
        case .bottomLeft:
            return .bottomLeading
        case .bottomCenter:
            return .bottom
        case .bottomRight:
            return .bottomTrailing
        }
    }
    
    var offset: Offset {
        
        let editPointFrame = EditPointFrame()
        let radius = editPointFrame.outerCircleRadius
        
        switch self {
        case .topLeft:
            return Offset(x: -radius, y: -radius)
        case .topCenter:
            return Offset(x: 0, y: -radius)
        case .topRight:
            return Offset(x: radius, y: -radius)
        case .middleLeft:
            return Offset(x: -radius, y: 0)
        case .middleRight:
            return Offset(x: radius, y: 0)
        case .bottomLeft:
            return Offset(x: -radius, y: radius)
        case .bottomCenter:
            return Offset(x: 0, y: radius)
        case .bottomRight:
            return Offset(x: radius, y: radius)
        }
    }
    
    struct Offset {
        let x: CGFloat
        let y: CGFloat
    }
}
