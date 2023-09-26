//
//  SymbolCatalogFeatureTests.swift
//  SFSymbolsArtCreatorTests
//
//

import ComposableArchitecture
import XCTest
@testable import SFSymbolsArtCreator

@MainActor
final class SymbolCatalogFeatureTests: XCTestCase {
    
    private var store = TestStore(
        initialState: SymbolCatalogFeature.State()
    ) {
        SymbolCatalogFeature()
    }

    override func setUpWithError() throws {
        store = TestStore(
            initialState: SymbolCatalogFeature.State()
        ) {
            SymbolCatalogFeature()
        }
    }
    
    func test_changeBackground() async {
        await store.send(.catalogSettings(.binding(.set(\.$backgroundColor, .black)))) {
            $0.catalogItemListState.backgroundColor = .black
            $0.catalogSettingsState.backgroundColor = .black
        }
    }
    
    func test_changeCategory() async {
        await store.send(.catalogSettings(.binding(.set(\.$category, .communication)))) {
            $0.catalogItemListState.category = .communication
            $0.catalogSettingsState.category = .communication
        }
    }
    
    func test_changeFontWeight() async {
        await store.send(.catalogSettings(.binding(.set(\.$symbolWeight, .light)))) {
            $0.catalogItemListState.fontWeight = .light
            $0.catalogSettingsState.symbolWeight = .light
        }
    }
}
