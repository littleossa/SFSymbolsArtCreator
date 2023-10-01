//
//  View+BoundingBox.swift
//  SFSymbolsArtCreator
//
//

import SwiftUI

extension View {
    
    func boundingBox(position: Binding<CGPoint>,
                     width: CGFloat,
                     height: CGFloat,
                     scaleAction: @escaping (EditPointScaling.Value) -> Void) -> some View {
        
        self.modifier(BondingBoxModifier(position: position,
                                         width: width,
                                         height: height,
                                         scaleAction: scaleAction))
    }
}

struct BondingBoxModifier: ViewModifier {
    
    @Binding var position: CGPoint
    let width: CGFloat
    let height: CGFloat
    let scaleAction: (_ scaleValue: EditPointScaling.Value) -> Void
    
    func body(content: Content) -> some View {
        
        BoundingBox(position: $position,
                    width: width,
                    height: height,
                    scaleAction: scaleAction) {
            content
        }
    }
}
