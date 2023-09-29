//
//  WorkSpaceFeatureTests.swift
//  SFSymbolsArtCreatorTests
//
//

import ComposableArchitecture
import XCTest
@testable import SFSymbolsArtCreator

@MainActor
final class WorkSpaceFeatureTests: XCTestCase {
    
    private lazy var store: TestStore<WorkSpaceFeature.State, WorkSpaceFeature.Action> = {
        preconditionFailure("store has not been set")
    }()
    
    override func setUpWithError() throws {
        store = TestStore(
            initialState: WorkSpaceFeature.State()) {
            WorkSpaceFeature()
        }
    }

    func test_changePrimaryColor() async {
        
        store.exhaustivity = .off
        await store.send(.colorTool(.primaryColorButtonTapped)) {
            $0.colorToolState.colorPicker = .init(colorType: .primary, selectedColor: .black)
        }
        await store.send(.colorTool(.colorPicker(.presented(.delegate(.selectColor(.primary, .yellow))))))
        await store.send(.colorTool(.delegate(.changePrimaryColor(.yellow))))
        store.assert {
            $0.colorToolState.primaryColor = .yellow
            $0.symbolCatalogState.catalogItemListState.primaryColor = .yellow
        }
    }
    
    func test_changeSecondaryColor() async {
        
        store.exhaustivity = .off
        await store.send(.colorTool(.secondaryColorButtonTapped)) {
            $0.colorToolState.colorPicker = .init(colorType: .secondary, selectedColor: .accentColor)
        }
        await store.send(.colorTool(.colorPicker(.presented(.delegate(.selectColor(.secondary, .red))))))
        await store.send(.colorTool(.delegate(.changeSecondaryColor(.red))))
        store.assert {
            $0.colorToolState.secondaryColor = .red
            $0.symbolCatalogState.catalogItemListState.secondaryColor = .red
        }
    }
    
    func test_changeTertiaryColor() async {
        
        store.exhaustivity = .off
        await store.send(.colorTool(.tertiaryColorButtonTapped)) {
            $0.colorToolState.colorPicker = .init(colorType: .tertiary, selectedColor: .white)
        }
        await store.send(.colorTool(.colorPicker(.presented(.delegate(.selectColor(.tertiary, .green))))))
        await store.send(.colorTool(.delegate(.changeTertiaryColor(.green))))
        store.assert {
            $0.colorToolState.tertiaryColor = .green
            $0.symbolCatalogState.catalogItemListState.tertiaryColor = .green
        }
    }
}
