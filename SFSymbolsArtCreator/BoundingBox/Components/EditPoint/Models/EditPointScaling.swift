//
//  EditPointScaling.swift
//  BoundingBox
//

import CoreGraphics

struct EditPointScaling {
    
    /// which points dragged on
    let position: EditPointPosition
    /// translation of DragGesture.Value
    let dragGestureTranslation: CGSize
    
    /// Return EditPointDragGesture.Value with DragGesture.Value.translation
    var value: EditPointScaling.Value {
        return EditPointScaling.Value(scaleValue: self.scaleValue,
                                      scaleSize: self.scaleSize)
    }
    
    /// How scale the size with the dragged edit point
    private var scaleSize: CGSize {
        
        switch position {
        case .topLeft:
            return CGSize(width: dragGestureTranslation.width * -1,
                          height: dragGestureTranslation.height * -1)
        case .topCenter:
            return CGSize(width: 0,
                          height: dragGestureTranslation.height * -1)
        case .topRight:
            return CGSize(width: dragGestureTranslation.width,
                          height: dragGestureTranslation.height * -1)
        case .middleLeft:
            return CGSize(width: dragGestureTranslation.width * -1,
                          height: 0)
        case .middleRight:
            return CGSize(width: dragGestureTranslation.width,
                          height: 0)
        case .bottomLeft:
            return CGSize(width: dragGestureTranslation.width * -1,
                          height: dragGestureTranslation.height)
        case .bottomCenter:
            return CGSize(width: 0,
                          height: dragGestureTranslation.height)
        case .bottomRight:
            return CGSize(width: dragGestureTranslation.width,
                          height: dragGestureTranslation.height)
        }
    }
    
    /// How scale the value with the dragged edit point.top center and bottom center return scaleSize height.
    private var scaleValue: CGFloat {
        
        switch position {
        case .topLeft, .topRight, .middleLeft, .middleRight, .bottomLeft, .bottomRight:
            return scaleSize.width
        case .topCenter, .bottomCenter:
            return scaleSize.height
        }
    }
    
    struct Value {
        let scaleValue: CGFloat
        let scaleSize: CGSize
    }
}
