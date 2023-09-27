//
//  EditPointMark.swift
//  BoundingBox
//

import SwiftUI

struct EditPointMark: View {
    
    let editPointFrame = EditPointFrame()
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundStyle(.white)
                .shadow(radius: 1)
                .frame(width: editPointFrame.outerCircleDiameter,
                       height: editPointFrame.outerCircleDiameter)
            Circle()
                .foregroundStyle(Color.accentColor)
                .frame(width: editPointFrame.innerCircleDiameter,
                       height: editPointFrame.innerCircleDiameter)
        }
    }
}

#Preview {
    EditPointMark()
}
