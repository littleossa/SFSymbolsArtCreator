//
//  RenderingType.swift
//  SFSymbolsArtCreator
//
//

import SwiftUI

enum RenderingType: LocalizedStringKey, Equatable {
    case hierarchical
    case monochrome
    case multiColor
    case palette
    
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
