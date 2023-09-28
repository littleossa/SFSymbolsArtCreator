//
//  BoundingBox.swift
//  BoundingBox
//

import SwiftUI

// MARK: - Initializer
extension BoundingBox {
    
    init(formType: EditFormType,
         isEditing: Bool,
         width: Binding<CGFloat>,
         height: Binding<CGFloat>,
         position: Binding<CGPoint>,
         @ViewBuilder content: () -> Content) {
        
        _width = width
        _height = height
        _position = position
        self.formType = formType
        self.isEditing = isEditing

        self.content = content()
    }
}

struct BoundingBox<Content: View>: View {
    
    @Binding var height: CGFloat
    @Binding var width: CGFloat
    @Binding var position: CGPoint
    let isEditing: Bool
    let content: Content
    let formType: EditFormType
    
    private let minScalingWidth: CGFloat = 10
    private let minScalingHeight: CGFloat = 10
    
    private var dragGesture: some Gesture {
        DragGesture().onChanged { value in
            position = value.location
        }
    }
    
    var body: some View {
        
        ZStack {
            
            if isEditing {
                
                content
                    .overlay {
                        MovingDashFramedRectangle()
                        
                        EditPointsFramedRectangle(width: width,
                                                  height: height) { value in
                            
                            switch formType {
                            case .freeForm:
                                guard width + value.scaleSize.width > minScalingWidth,
                                      height + value.scaleSize.height > minScalingHeight
                                else { return }
                                
                                width += value.scaleSize.width
                                height += value.scaleSize.height
                                
                            case .uniform:
                                guard width + value.scaleValue > minScalingWidth,
                                      height + value.scaleValue > minScalingHeight
                                else { return }
                                
                                width += value.scaleValue
                                height += value.scaleValue
                            }
                        }
                    }
                    .frame(width: width,
                           height: height)
                    .position(position)
                    .gesture(dragGesture)
                
            } else {
                
                content
                    .frame(width: width,
                           height: height)
                    .position(position)
            }
        }
    }
}

#Preview {
    BoundingBox(formType: .freeForm,
                isEditing: true,
                width: .constant(100),
                height: .constant(100),
                position: .constant(CGPoint(x: 100, y: 100))) {
        Image(systemName: "circle")
                        .resizable()
    }
}
