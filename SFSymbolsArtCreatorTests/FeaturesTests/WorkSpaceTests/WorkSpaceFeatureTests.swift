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
    
    func test_catalogItemSelected() async {
        
        store.exhaustivity = .off
        let item = CatalogItem(symbolName: "xmark",
                               renderingType: .palette,
                               primaryColor: .red,
                               secondaryColor: .yellow,
                               tertiaryColor: .green,
                               fontWeight: .regular)
        await store.send(.symbolCatalog(.catalogItemList(.delegate(.catalogItemSelected(item))))) {
            $0.drawToolState.isEditMode = true
            
            $0.drawToolState.renderingType = .palette
            $0.colorToolState.primaryColor = .red
            $0.colorToolState.secondaryColor = .yellow
            $0.colorToolState.tertiaryColor = .green
        }
        XCTAssertNotNil(store.state.artCanvasState.editSymbolID)
    }

    func test_changePrimaryColor() async {
        
        store.exhaustivity = .off
        
        let item = CatalogItem(symbolName: "xmark",
                               renderingType: .monochrome,
                               primaryColor: .black,
                               secondaryColor: .accentColor,
                               tertiaryColor: .white,
                               fontWeight: .regular)
        await store.send(.symbolCatalog(.catalogItemList(.delegate(.catalogItemSelected(item)))))
        await store.send(.colorTool(.primaryColorButtonTapped)) {
            $0.colorToolState.colorPicker = .init(colorType: .primary, selectedColor: .black)
        }
        await store.send(.colorTool(.colorPicker(.presented(.delegate(.selectColor(.primary, .yellow))))))
        await store.send(.colorTool(.delegate(.primaryColorChanged(.yellow))))
        store.assert {
            $0.colorToolState.primaryColor = .yellow
            $0.artCanvasState.editingSymbolAppearance?.primaryColor = .yellow
        }
    }
    
    func test_changeSecondaryColor() async {
        
        store.exhaustivity = .off
        
        let item = CatalogItem(symbolName: "xmark",
                               renderingType: .monochrome,
                               primaryColor: .black,
                               secondaryColor: .accentColor,
                               tertiaryColor: .white,
                               fontWeight: .regular)
        await store.send(.symbolCatalog(.catalogItemList(.delegate(.catalogItemSelected(item)))))
        await store.send(.colorTool(.secondaryColorButtonTapped)) {
            $0.colorToolState.colorPicker = .init(colorType: .secondary, selectedColor: .accentColor)
        }
        await store.send(.colorTool(.colorPicker(.presented(.delegate(.selectColor(.secondary, .red))))))
        await store.send(.colorTool(.delegate(.secondaryColorChanged(.red))))
        store.assert {
            $0.colorToolState.secondaryColor = .red
            $0.artCanvasState.editingSymbolAppearance?.secondaryColor = .red
        }
    }
    
    func test_changeTertiaryColor() async {
        
        store.exhaustivity = .off
        
        let item = CatalogItem(symbolName: "xmark",
                               renderingType: .monochrome,
                               primaryColor: .black,
                               secondaryColor: .accentColor,
                               tertiaryColor: .white,
                               fontWeight: .regular)
        await store.send(.symbolCatalog(.catalogItemList(.delegate(.catalogItemSelected(item)))))
        await store.send(.colorTool(.tertiaryColorButtonTapped)) {
            $0.colorToolState.colorPicker = .init(colorType: .tertiary, selectedColor: .white)
        }
        await store.send(.colorTool(.colorPicker(.presented(.delegate(.selectColor(.tertiary, .green))))))
        await store.send(.colorTool(.delegate(.tertiaryColorChanged(.green))))
        store.assert {
            $0.colorToolState.tertiaryColor = .green
            $0.artCanvasState.editingSymbolAppearance?.tertiaryColor = .green
        }
    }
    
    func test_changeRenderingType() async {
        
        store.exhaustivity = .off
        
        let item = CatalogItem(symbolName: "xmark",
                               renderingType: .monochrome,
                               primaryColor: .black,
                               secondaryColor: .accentColor,
                               tertiaryColor: .white,
                               fontWeight: .regular)
        await store.send(.symbolCatalog(.catalogItemList(.delegate(.catalogItemSelected(item)))))
        await store.send(.drawTool(.renderingTypeChanged(.palette)))
        store.assert {
            $0.drawToolState.renderingType = .palette
            $0.colorToolState.renderingType = .palette
            $0.artCanvasState.editingSymbolAppearance?.secondaryColor = .accentColor
            $0.artCanvasState.editingSymbolAppearance?.tertiaryColor = .white
        }
        XCTAssertFalse(store.state.colorToolState.isOnlyPrimaryColorEnabled)
        
        await store.send(.drawTool(.renderingTypeChanged(.hierarchical)))
        store.assert {
            $0.drawToolState.renderingType = .hierarchical
            $0.colorToolState.renderingType = .hierarchical
            $0.artCanvasState.editingSymbolAppearance?.secondaryColor = .clear
            $0.artCanvasState.editingSymbolAppearance?.tertiaryColor = .clear
        }
        XCTAssertTrue(store.state.colorToolState.isOnlyPrimaryColorEnabled)
        
        await store.send(.drawTool(.renderingTypeChanged(.monochrome)))
        store.assert {
            $0.drawToolState.renderingType = .monochrome
            $0.colorToolState.renderingType = .monochrome
        }
        XCTAssertTrue(store.state.colorToolState.isOnlyPrimaryColorEnabled)
        
        await store.send(.drawTool(.renderingTypeChanged(.multiColor)))
        store.assert {
            $0.drawToolState.renderingType = .multiColor
            $0.colorToolState.renderingType = .multiColor
        }
        XCTAssertTrue(store.state.colorToolState.isOnlyPrimaryColorEnabled)
    }
    
    func test_editButtonToggled() async {
        
        store.exhaustivity = .off
        let item = CatalogItem(symbolName: "xmark",
                               renderingType: .palette,
                               primaryColor: .red,
                               secondaryColor: .yellow,
                               tertiaryColor: .green,
                               fontWeight: .regular)
        await store.send(.symbolCatalog(.catalogItemList(.delegate(.catalogItemSelected(item)))))
        await store.send(.drawTool(.editButtonTapped)) {
            $0.drawToolState.isEditMode = false
        }
        await store.send(.drawTool(.delegate(.editButtonToggled(false)))) {
            $0.artCanvasState.editSymbolID = nil
        }
        
        await store.send(.drawTool(.renderingTypeChanged(.monochrome))) {
            $0.drawToolState.renderingType = .monochrome
            $0.colorToolState.primaryColor = .red
            $0.colorToolState.secondaryColor = .clear
            $0.colorToolState.tertiaryColor = .clear
        }
        await store.send(.drawTool(.editButtonTapped)) {
            $0.drawToolState.isEditMode = true
        }
        await store.send(.drawTool(.delegate(.editButtonToggled(true)))) {
            $0.artCanvasState.editSymbolID = $0.artCanvasState.artSymbols.last?.id
            $0.drawToolState.renderingType = .palette
            $0.colorToolState.primaryColor = .red
            $0.colorToolState.secondaryColor = .yellow
            $0.colorToolState.tertiaryColor = .green
        }
    }
    
    func test_editFormType() async {
        
        XCTAssertEqual(store.state.artCanvasState.editFormType, .freeForm)
        store.exhaustivity = .off
        let item = CatalogItem(symbolName: "xmark",
                               renderingType: .palette,
                               primaryColor: .red,
                               secondaryColor: .yellow,
                               tertiaryColor: .green,
                               fontWeight: .regular)
        await store.send(.symbolCatalog(.catalogItemList(.delegate(.catalogItemSelected(item))))) {
            $0.editPanelState?.editFormType = .freeForm
        }
        await store.send(.editPanel(.binding(.set(\.$editFormType, .uniform)))) {
            $0.editPanelState?.editFormType = .uniform
        }
        await store.send(.drawTool(.editButtonTapped))
        await store.send(.drawTool(.editButtonTapped))
        
        XCTAssertEqual(store.state.artCanvasState.editFormType, .uniform)
        XCTAssertEqual(store.state.artCanvasState.editFormType, .uniform)
        
        let item2 = CatalogItem(symbolName: "xmark",
                               renderingType: .palette,
                               primaryColor: .red,
                               secondaryColor: .yellow,
                               tertiaryColor: .green,
                               fontWeight: .regular)
        await store.send(.symbolCatalog(.catalogItemList(.delegate(.catalogItemSelected(item2)))))
        
        XCTAssertEqual(store.state.artCanvasState.editFormType, .uniform)
        XCTAssertEqual(store.state.artCanvasState.editFormType, .uniform)
    }
}
