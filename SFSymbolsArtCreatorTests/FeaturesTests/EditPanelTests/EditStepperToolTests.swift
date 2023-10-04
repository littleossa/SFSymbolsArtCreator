//
//  EditStepperToolTests.swift
//  SFSymbolsArtCreatorTests
//
//

import ComposableArchitecture
import XCTest
@testable import SFSymbolsArtCreator

@MainActor
final class EditStepperToolTests: XCTestCase {

    private lazy var store: TestStore<EditStepperToolFeature.State, EditStepperToolFeature.Action> = {
       preconditionFailure("store has not been set")
    }()
    
    override func setUp() async throws {
        store = TestStore(
            initialState: EditStepperToolFeature.State(
                width: 11,
                height: 11,
                positionX: 10,
                positionY: 0,
                rotationDegrees: 0)
        ) {
            EditStepperToolFeature()
        }
    }

    func test_decrementDegreesButtonTapped() async {
        await store.send(.decrementDegreesButtonTapped) {
            $0.rotationDegrees = 359
        }
    }
    
    func test_decrementHightButtonTapped() async {
        await store.send(.decrementHeightButtonTapped) {
            $0.height = 10
        }
    }
    
    func test_decrementHightButtonTapped_keeps_minScalingHeight() async {
        store.exhaustivity = .off
        await store.send(.decrementHeightButtonTapped)
        await store.send(.decrementHeightButtonTapped)
        store.assert { state in
            state.height = 10
        }
    }
    
    func test_decrementWidthButtonTapped() async {
        await store.send(.decrementWidthButtonTapped) {
            $0.width = 10
        }
    }
    
    func test_decrementWidthButtonTapped_keeps_minScalingWidth() async {
        store.exhaustivity = .off
        await store.send(.decrementWidthButtonTapped)
        await store.send(.decrementWidthButtonTapped)
        store.assert { state in
            state.width = 10
        }
    }
    
    func test_decrementXPositionButtonTapped() async {
        await store.send(.decrementXPositionButtonTapped) {
            $0.positionX = 9
        }
    }
    
    func test_decrementYPositionButtonTapped() async {
        await store.send(.decrementYPositionButtonTapped) {
            $0.positionY = -1
        }
    }
    
    func test_incrementDegreesButtonTapped() async {
        await store.send(.incrementDegreesButtonTapped) {
            $0.rotationDegrees = 1
        }
    }
    
    func test_incrementHeightButtonTapped() async {
        await store.send(.incrementHeightButtonTapped) {
            $0.height = 12
        }
    }
    
    func test_incrementWidthButtonTapped() async {
        await store.send(.incrementWidthButtonTapped) {
            $0.width = 12
        }
    }
    
    func test_incrementXPositionButtonTapped() async {
        await store.send(.incrementXPositionButtonTapped) {
            $0.positionX = 11
        }
    }
    
    func test_incrementYPositionButtonTapped() async {
        await store.send(.incrementYPositionButtonTapped) {
            $0.positionY = 1
        }
    }
}
