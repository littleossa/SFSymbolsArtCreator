//
//  ArtSymbolLayerTests.swift
//  SFSymbolsArtCreatorTests
//
//

import ComposableArchitecture
import XCTest
@testable import SFSymbolsArtCreator

@MainActor
final class ArtSymbolLayerTests: XCTestCase {

    func test_hideButtonTapped() async {
        
        let store = TestStore(initialState: ArtSymbolLayerFeature.State(appearance: .preview())) {
            ArtSymbolLayerFeature()
        }
        store.exhaustivity = .off
        await store.send(.hideButtonTapped) {
            $0.appearance.isHidden = true
        }
        await store.send(.hideButtonTapped) {
            $0.appearance.isHidden = false
        }
    }
}
