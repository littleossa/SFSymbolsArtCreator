//
//  BoundingBox.swift
//  BoundingBox
//

import SwiftUI

// MARK: - Initializer
extension BoundingBox {
    
    init(position: Binding<CGPoint>,
         width: CGFloat,
         height: CGFloat,
         scaleAction: @escaping (EditPointScaling.Value) -> Void,
         @ViewBuilder content: () -> Content) {
        _position = position
        self.width = width
        self.height = height
        self.scaleAction = scaleAction
        self.content = content()
    }
}

struct BoundingBox<Content: View>: View {
    
    @Binding var position: CGPoint
    let width: CGFloat
    let height: CGFloat
    let scaleAction: (_ scaleValue: EditPointScaling.Value) -> Void
    let content: Content
    
    private var dragGesture: some Gesture {
        DragGesture().onChanged { value in
            position = value.location
        }
    }
    
    var body: some View {
        
        content
            .overlay {
                MovingDashFramedRectangle()
                
                EditPointsFramedRectangle(width: width,
                                          height: height) { value in
                    scaleAction(value)
                }
            }
            .frame(width: width,
                   height: height)
            .position(position)
            .gesture(dragGesture)
    }
}

#Preview {
    BoundingBox(position: .constant(CGPoint(x: 100, y: 100)),
                width: 100,
                height: 100) { _ in } content: {
        Image(systemName: "circle")
            .resizable()
    }
}
