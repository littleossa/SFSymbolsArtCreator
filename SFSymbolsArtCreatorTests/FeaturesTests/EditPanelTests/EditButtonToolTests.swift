//
//  EditButtonToolTests.swift
//  SFSymbolsArtCreatorTests
//
//

import ComposableArchitecture
import XCTest
@testable import SFSymbolsArtCreator

@MainActor
final class EditButtonToolTests: XCTestCase {
    
    private lazy var store: TestStore<EditButtonToolFeature.State, EditButtonToolFeature.Action> = {
        preconditionFailure("store has not been set")
    }()
    
    override func setUp() async throws {
        store = TestStore(
            initialState: EditButtonToolFeature.State(
                fontWight: .regular,
                isFlippedHorizontal: false,
                isFlippedVertical: false,
                rotationDegrees: 0)
        ) {
            EditButtonToolFeature()
        }
    }

    func test_decrementWeightButtonTapped() async {
        
        store.exhaustivity = .off
        await store.send(.decrementWeightButtonTapped) {
            $0.fontWight = .light
        }
        XCTAssertFalse(store.state.decrementWeightButtonDisabled)
        
        await store.send(.decrementWeightButtonTapped) {
            $0.fontWight = .thin
        }
        XCTAssertFalse(store.state.decrementWeightButtonDisabled)
        
        await store.send(.decrementWeightButtonTapped) {
            $0.fontWight = .ultraLight
        }
        XCTAssertTrue(store.state.decrementWeightButtonDisabled)
    }
    
    func test_flipHorizontalButtonTapped() async {
        
        store.exhaustivity = .off
        await store.send(.flipHorizontalButtonTapped) {
            $0.isFlippedHorizontal = true
        }
        
        await store.send(.flipHorizontalButtonTapped) {
            $0.isFlippedHorizontal = false
        }
    }
    
    func test_flipVerticalButtonTapped() async {
        
        store.exhaustivity = .off
        await store.send(.flipVerticalButtonTapped) {
            $0.isFlippedVertical = true
        }
        
        await store.send(.flipVerticalButtonTapped) {
            $0.isFlippedVertical = false
        }
    }
    
    func test_incrementWeightButtonTapped() async {
        
        store.exhaustivity = .off
        await store.send(.incrementWeightButtonTapped) {
            $0.fontWight = .medium
        }
        XCTAssertFalse(store.state.incrementWeightButtonDisabled)
        
        await store.send(.incrementWeightButtonTapped) {
            $0.fontWight = .semibold
        }
        XCTAssertFalse(store.state.incrementWeightButtonDisabled)
        
        await store.send(.incrementWeightButtonTapped) {
            $0.fontWight = .bold
        }
        XCTAssertFalse(store.state.incrementWeightButtonDisabled)
        
        await store.send(.incrementWeightButtonTapped) {
            $0.fontWight = .heavy
        }
        XCTAssertFalse(store.state.incrementWeightButtonDisabled)
        
        await store.send(.incrementWeightButtonTapped) {
            $0.fontWight = .black
        }
        XCTAssertTrue(store.state.incrementWeightButtonDisabled)
    }
    
    func test_rotate45ButtonTapped() async {
        
        store.exhaustivity = .off
        await store.send(.rotate45ButtonTapped) {
            $0.rotationDegrees = 45
        }
        await store.send(.rotate45ButtonTapped) {
            $0.rotationDegrees = 90
        }
        await store.send(.rotate45ButtonTapped) {
            $0.rotationDegrees = 135
        }
        await store.send(.rotate45ButtonTapped) {
            $0.rotationDegrees = 180
        }
        await store.send(.rotate45ButtonTapped) {
            $0.rotationDegrees = 225
        }
        await store.send(.rotate45ButtonTapped) {
            $0.rotationDegrees = 270
        }
        await store.send(.rotate45ButtonTapped) {
            $0.rotationDegrees = 315
        }
        await store.send(.rotate45ButtonTapped) {
            $0.rotationDegrees = 360
        }
        await store.send(.rotate45ButtonTapped) {
            $0.rotationDegrees = 45
        }
    }
}
