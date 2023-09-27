//
//  MovingDashFramedRectangle.swift
//  BoundingBox
//

import SwiftUI

struct MovingDashFramedRectangle: View {
    
    @State private var dashPhase: CGFloat = 0
    @State private var timerCount: CGFloat = 0
    private let timer = Timer.publish(every: 0.1,
                                      on: .main,
                                      in: .common).autoconnect()
    
    var body: some View {
        Rectangle()
            .stroke(style: StrokeStyle(dash: [6, 6],
                                       dashPhase: dashPhase))
            .onReceive(timer) { _ in
                timerCount = timerCount > 10 ? 0 : timerCount + 1
                dashPhase = timerCount
            }
    }
}

#Preview {
    MovingDashFramedRectangle()
        .frame(width: 100, height: 100)
}
