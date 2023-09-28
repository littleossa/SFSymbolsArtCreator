//
//  View+BoundingBox.swift
//  SFSymbolsArtCreator
//
//

import SwiftUI

extension View {
    
    func boundingBox(formType: EditFormType,
                         isEditing: Bool,
                         width: Binding<CGFloat>,
                         height: Binding<CGFloat>,
                         position: Binding<CGPoint>) -> some View {
        
        self.modifier(BondingBoxModifier(formType: formType,
                                         isEditing: isEditing,
                                         width: width,
                                         height: height,
                                         position: position))
    }
}

struct BondingBoxModifier: ViewModifier {
    
    let formType: EditFormType
    let isEditing: Bool
    @Binding var width: CGFloat
    @Binding var height: CGFloat
    @Binding var position: CGPoint
    
    func body(content: Content) -> some View {
        
        BoundingBox(formType: formType,
                    isEditing: isEditing,
                    width: $width,
                    height: $height,
                    position: $position) {
            content
        }
    }
}
