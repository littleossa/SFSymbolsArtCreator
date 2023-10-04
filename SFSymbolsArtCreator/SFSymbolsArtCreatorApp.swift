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
            WorkSpaceView(store: .init(initialState: WorkSpaceFeature.State()) {
                WorkSpaceFeature()
                    ._printChanges()
            })
            .onAppear {
                UISegmentedControl.setAppearance()
            }
        }
    }
}
