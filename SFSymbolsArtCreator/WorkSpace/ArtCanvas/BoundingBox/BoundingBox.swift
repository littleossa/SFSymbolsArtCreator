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
         degrees: Double,
         scaleAction: @escaping (EditPointScaling.Value) -> Void,
         @ViewBuilder content: () -> Content) {
        _position = position
        self.width = width
        self.height = height
        self.degrees = degrees
        self.scaleAction = scaleAction
        self.content = content()
    }
}

struct BoundingBox<Content: View>: View {
    
    @Binding var position: CGPoint
    let width: CGFloat
    let height: CGFloat
    let degrees: Double
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
                ZStack {
                    MovingDashFramedRectangle()
                    
                    EditPointsFramedRectangle(
                        width: width,
                        height: height
                    ) { value in
                        scaleAction(value)
                    }
                }
                .rotation3DEffect(.degrees(degrees),
                                  axis: (x: 0, y: 0, z: 1), anchorZ: 1)
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
                height: 100,
                degrees: 0) { _ in } content: {
        Image(systemName: "circle")
            .resizable()
    }
}
