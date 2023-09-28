//
//  ColorItem.swift
//  SFSymbolsArtCreator
//
//

import SwiftUI

struct ColorItem: Equatable, Identifiable {
    let id: String
    let color: Color
    
    // MARK: - Initializers
    init(canvasColor: Color) {
        self.id = canvasColorId
        self.color = canvasColor
    }
    
    init(id: String, color: Color) {
        self.id = id
        self.color = color
    }
    
    private let canvasColorId = "canvas"
    
    var isCanvasColor: Bool {
        return self.id == canvasColorId
    }
}

// MARK: - Static properties
extension ColorItem {
    static let white = ColorItem(id: "white", color: .white)
    static let black = ColorItem(id: "black", color: .black)
}

