//
//  SymbolRenderingMode+Extension.swift
//  SFSymbolsArtCreator
//
//

import SwiftUI

extension SymbolRenderingMode: Equatable {
    
    public static func == (lhs: SymbolRenderingMode, rhs: SymbolRenderingMode) -> Bool {
        return lhs.label == rhs.label
    }
    
    var label: LocalizedStringKey {
        switch self {
        case .hierarchical:
            return "Hierarchical"
        case .monochrome:
            return "Monochrome"
        case .multicolor:
            return "Multicolor"
        case .palette:
            return "Palette"
        default:
            return "Other"
        }
    }
}

