//
//  EditFormType.swift
//  SFSymbolsArtCreator
//
//

import Foundation

enum EditFormType: String, CaseIterable, Identifiable {
        
    case freeForm = "Free form"
    case uniform = "Uniform"
    
    var id: String {
        return self.rawValue
    }
}
