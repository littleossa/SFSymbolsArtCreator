//
//  CatalogItemListFeatureTests.swift
//  SFSymbolsArtCreatorTests
//
//

import ComposableArchitecture
import SFUserFriendlySymbols
import XCTest
@testable import SFSymbolsArtCreator

@MainActor
final class CatalogItemListFeatureTests: XCTestCase {
    
    func test_catalogItemList() async {
        let store = TestStore(
            initialState: CatalogItemListFeature.State(
                fontWeight: .regular,
                primaryColor: .black,
                secondaryColor: .black,
                tertiaryColor: .clear,
                renderingType: .monochrome,
                backgroundColor: .white,
                category: .all)
        ) {
            CatalogItemListFeature()
        }
        
        await store.send(.binding(.set(\.$searchText, "xmark"))) {
            $0.searchText = "xmark"
        }
        
        XCTAssertTrue(store.state.catalogItems.contains(SFSymbols.xmark))
        XCTAssertTrue(store.state.catalogItems.contains(SFSymbols.xmarkCircle))
        XCTAssertFalse(store.state.catalogItems.contains(SFSymbols._00CircleFill))
        
        await store.send(.binding(.set(\.$searchText, ""))) {
            $0.searchText = ""
        }
    }
}
