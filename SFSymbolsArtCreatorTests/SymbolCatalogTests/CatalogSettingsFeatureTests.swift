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
                backgroundColor: .white,
                category: .all,
                symbolWeight: .regular
            )
        ) {
            CatalogSettingsFeature()
        }
        
        await store.send(.binding(.set(\.$backgroundColor, .black))) {
            $0.backgroundColor = .black
        }
        
        await store.send(.binding(.set(\.$category, .devices))) {
            $0.category = .devices
        }
        
        await store.send(.binding(.set(\.$symbolWeight, .bold))) {
            $0.symbolWeight = .bold
        }
    }
}
