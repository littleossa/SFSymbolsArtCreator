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
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
