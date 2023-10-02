//
//  Double+Extension.swift
//  SFSymbolsArtCreator
//
//

import Foundation

extension Double {
    
    /// Rotates within a 360-degree range by the specified degrees.
    /// - Parameter degrees: The degrees to rotate by.
    /// - Returns: The resulting degrees after rotation. If it exceeds 360 degrees, it starts again from 0 degrees.
    func rotatingWithin360ByDegrees(_ degrees: Double) -> Double {
        let sumDegrees = self + degrees
        return sumDegrees > 360 ? sumDegrees - 360 : sumDegrees
    }
}
