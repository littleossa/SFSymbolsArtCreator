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
        
        await store.send(.symbolCatalog(.delegate(.selectSymbol(._00Circle))))
        await store.send(.colorTool(.primaryColorButtonTapped)) {
            $0.colorToolState.colorPicker = .init(colorType: .primary, selectedColor: .black)
        }
        await store.send(.colorTool(.colorPicker(.presented(.delegate(.selectColor(.primary, .yellow))))))
        await store.send(.colorTool(.delegate(.changePrimaryColor(.yellow))))
        store.assert {
            $0.colorToolState.primaryColor = .yellow
            $0.artCanvasState.editingSymbol?.primaryColor = .yellow
        }
    }
    
    func test_changeSecondaryColor() async {
        
        store.exhaustivity = .off
        
        await store.send(.symbolCatalog(.delegate(.selectSymbol(._00Circle))))
        await store.send(.colorTool(.secondaryColorButtonTapped)) {
            $0.colorToolState.colorPicker = .init(colorType: .secondary, selectedColor: .accentColor)
        }
        await store.send(.colorTool(.colorPicker(.presented(.delegate(.selectColor(.secondary, .red))))))
        await store.send(.colorTool(.delegate(.changeSecondaryColor(.red))))
        store.assert {
            $0.colorToolState.secondaryColor = .red
            $0.artCanvasState.editingSymbol?.secondaryColor = .red
        }
    }
    
    func test_changeTertiaryColor() async {
        
        store.exhaustivity = .off
        
        await store.send(.symbolCatalog(.delegate(.selectSymbol(._00Circle))))
        await store.send(.colorTool(.tertiaryColorButtonTapped)) {
            $0.colorToolState.colorPicker = .init(colorType: .tertiary, selectedColor: .white)
        }
        await store.send(.colorTool(.colorPicker(.presented(.delegate(.selectColor(.tertiary, .green))))))
        await store.send(.colorTool(.delegate(.changeTertiaryColor(.green))))
        store.assert {
            $0.colorToolState.tertiaryColor = .green
            $0.artCanvasState.editingSymbol?.tertiaryColor = .green
        }
    }
    
    func test_changeRenderingType() async {
        
        store.exhaustivity = .off
        
        await store.send(.symbolCatalog(.delegate(.selectSymbol(._00Circle))))
        
        await store.send(.drawTool(.renderingChanged(.palette)))
        await store.send(.drawTool(.delegate(.changeRenderingType(.palette))))
        store.assert {
            $0.drawToolState.renderingType = .palette
            $0.colorToolState.renderingType = .palette
            $0.artCanvasState.editingSymbol?.secondaryColor = .accentColor
            $0.artCanvasState.editingSymbol?.tertiaryColor = .white
        }
        XCTAssertFalse(store.state.colorToolState.isOnlyPrimaryColorEnabled)
        
        await store.send(.drawTool(.renderingChanged(.hierarchical)))
        await store.send(.drawTool(.delegate(.changeRenderingType(.hierarchical))))
        store.assert {
            $0.drawToolState.renderingType = .hierarchical
            $0.colorToolState.renderingType = .hierarchical
            $0.artCanvasState.editingSymbol?.secondaryColor = .clear
            $0.artCanvasState.editingSymbol?.tertiaryColor = .clear
        }
        XCTAssertTrue(store.state.colorToolState.isOnlyPrimaryColorEnabled)
        
        await store.send(.drawTool(.renderingChanged(.monochrome)))
        await store.send(.drawTool(.delegate(.changeRenderingType(.monochrome))))
        store.assert {
            $0.drawToolState.renderingType = .monochrome
            $0.colorToolState.renderingType = .monochrome
        }
        XCTAssertTrue(store.state.colorToolState.isOnlyPrimaryColorEnabled)
        
        await store.send(.drawTool(.renderingChanged(.multiColor)))
        await store.send(.drawTool(.delegate(.changeRenderingType(.multiColor))))
        store.assert {
            $0.drawToolState.renderingType = .multiColor
            $0.colorToolState.renderingType = .multiColor
        }
        XCTAssertTrue(store.state.colorToolState.isOnlyPrimaryColorEnabled)
    }
}
