//
//  CatalogSettingsFeatureTests.swift
//  SFSymbolsArtCreatorTests
//
//

import ComposableArchitecture
import XCTest
@testable import SFSymbolsArtCreator

@MainActor
final class CatalogSettingsFeatureTests: XCTestCase {
    
    func test_catalogSettings() async {
        let store = TestStore(
            initialState: CatalogSettingsFeature.State(
                catalogBackgroundColorItem: .white,
                category: .all,
                symbolWeight: .regular,
                currentCanvasColor: .white
            )
        ) {
            CatalogSettingsFeature()
        }
        
        await store.send(.binding(.set(\.$catalogBackgroundColorItem, .black))) {
            $0.catalogBackgroundColorItem = .black
        }
        
        await store.send(.binding(.set(\.$category, .devices))) {
            $0.category = .devices
        }
        
        await store.send(.binding(.set(\.$symbolWeight, .bold))) {
            $0.symbolWeight = .bold
        }
    }
}
