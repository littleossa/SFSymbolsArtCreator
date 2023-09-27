//
//  RenderingType.swift
//  SFSymbolsArtCreator
//
//

import SwiftUI

enum RenderingType: String, Equatable, CaseIterable, Identifiable {
    case hierarchical
    case monochrome
    case multiColor
    case palette
    
    var id: String {
        return self.rawValue
    }
    
    var displayLabel: String {
        return self.rawValue.capitalized
    }
    
    var renderingMode: SymbolRenderingMode {
        switch self {
        case .hierarchical:
            return .hierarchical
        case .monochrome:
            return .monochrome
        case .multiColor:
            return .multicolor
        case .palette:
            return .palette
        }
    }
}
