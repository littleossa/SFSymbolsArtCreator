//
//  EditingPointsView.swift
//  BoundingBox
//

import SwiftUI

struct EditPointsFramedRectangle: View {
    
    let width: CGFloat
    let height: CGFloat
    let scaleChangeAction: (_ value: EditPointScaling.Value) -> Void
    
    var body: some View {
        
        ZStack {
            
            //
            // Top Left Edit point
            //
            EditPoint(editingWidth: width,
                      editingHeight: height,
                      position: .topLeft) { value in
                scaleChangeAction(value)
            }
            
            //
            // Top Center Edit point
            //
            EditPoint(editingWidth: width,
                      editingHeight: height,
                      position: .topCenter) { value in
                scaleChangeAction(value)
            }
            
            //
            // Top Right Edit point
            //
            EditPoint(editingWidth: width,
                      editingHeight: height,
                      position: .topRight) { value in
                scaleChangeAction(value)
            }
            
            //
            // Middle Left Edit point
            //
            EditPoint(editingWidth: width,
                      editingHeight: height,
                      position: .middleLeft) { value in
                scaleChangeAction(value)
            }
            
            //
            // Middle Right Edit point
            //
            EditPoint(editingWidth: width,
                      editingHeight: height,
                      position: .middleRight) { value in
                scaleChangeAction(value)
            }
            
            //
            // Bottom Left Edit point
            //
            EditPoint(editingWidth: width,
                      editingHeight: height,
                      position: .bottomLeft) { value in
                scaleChangeAction(value)
            }
            
            //
            // Bottom Center Edit point
            //
            EditPoint(editingWidth: width,
                      editingHeight: height,
                      position: .bottomCenter) { value in
                scaleChangeAction(value)
            }
            
            //
            // Bottom Right Edit point
            //
            EditPoint(editingWidth: width,
                      editingHeight: height,
                      position: .bottomRight) { value in
                scaleChangeAction(value)
            }
        }
    }
}

#Preview {
    ZStack {
        MovingDashFramedRectangle()
            .frame(width: 100, height: 100)
        EditPointsFramedRectangle(width: 100, height: 100) { _ in }
    }
}
