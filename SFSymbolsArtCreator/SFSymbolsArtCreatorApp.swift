//
//  SFSymbolsArtCreatorApp.swift
//  SFSymbolsArtCreator
//
//

import SwiftUI

@main
struct SFSymbolsArtCreatorApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            SymbolCatalogView(store: .init(
                initialState: SymbolCatalogFeature.State()) {
                    SymbolCatalogFeature()
                        ._printChanges()
                })
        }
    }
}
