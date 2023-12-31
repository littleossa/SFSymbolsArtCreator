//
//  EditPanelTests.swift
//  SFSymbolsArtCreatorTests
//
//

import ComposableArchitecture
import XCTest
@testable import SFSymbolsArtCreator

@MainActor
final class EditPanelTests: XCTestCase {
    
    private lazy var store: TestStore<EditPanelFeature.State, EditPanelFeature.Action> = {
        preconditionFailure("store has not been set")
    }()

    override func setUpWithError() throws {
        store = TestStore(
            initialState: EditPanelFeature.State(
                appearance: .init(
                    name: "xmark",
                    renderingType: .monochrome,
                    primaryColor: .black,
                    secondaryColor: .accentColor,
                    tertiaryColor: .white,
                    weight: .regular,
                    width: 100,
                    height: 100,
                    position: CGPoint(x: 10, y: 10),
                    rotationDegrees: 0
                )
            )) {
                EditPanelFeature()
            }
    }
    
    func test_resizeButtonTapped() async {
        
        await store.send(.resizeButtonTapped) {
            $0.isDisplayAllEditToolOptions = false
        }
        
        await store.send(.resizeButtonTapped) {
            $0.isDisplayAllEditToolOptions = true
        }
    }
    
    func test_bindingEditFormType() async {
        
        store.exhaustivity = .off
        await store.send(.binding(.set(\.$editFormType, EditFormType.uniform))) {
            $0.editFormType = .uniform
        }
        await store.send(.binding(.set(\.$editFormType, EditFormType.freeForm))) {
            $0.editFormType = .freeForm
        }
    }
    
    func test_editButtonToolChangedItsDegrees() async {
        
        store.exhaustivity = .off
        await store.send(.editButtonTool(.delegate(.degreesRotated(45))))
        await store.send(.editStepperTool(.incrementDegreesButtonTapped))
        store.assert {
            $0.editStepperTool.rotationDegrees = 46
        }
        await store.send(.editStepperTool(.decrementDegreesButtonTapped)) {
            $0.editStepperTool.rotationDegrees = 45
        }

    }
}
