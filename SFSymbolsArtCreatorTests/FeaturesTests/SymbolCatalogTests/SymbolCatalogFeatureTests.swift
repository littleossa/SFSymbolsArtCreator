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
    
    private lazy var store: TestStore<SymbolCatalogFeature.State, SymbolCatalogFeature.Action> = {
        preconditionFailure("store has not been set")
    }()

    override func setUpWithError() throws {
        store = TestStore(
            initialState: SymbolCatalogFeature.State(
                renderingType: .monochrome,
                primaryColor: .black,
                secondaryColor: .accentColor,
                tertiaryColor: .white,
                canvasColor: .white
            )
        ) {
            SymbolCatalogFeature()
        }
    }
    
    func test_changeBackground() async {
        await store.send(.catalogSettings(.binding(.set(\.$catalogBackgroundColorItem, .black)))) {
            $0.catalogItemListState.backgroundColor = .black
            $0.catalogSettingsState.catalogBackgroundColorItem = .black
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
    
    func test_changeRenderingType() async {
        await store.send(.catalogSettings(.catalogSymbolColorSetting(.delegate(.renderingTypeSelected(.palette))))) {
            $0.catalogItemListState.renderingType = .palette
            $0.catalogItemListState.secondaryColor = .accentColor
            $0.catalogItemListState.tertiaryColor = .white
            $0.catalogSettingsState.catalogSymbolColorSettingState.secondaryColor = .accentColor
            $0.catalogSettingsState.catalogSymbolColorSettingState.tertiaryColor = .white
        }
        
        await store.send(.catalogSettings(.catalogSymbolColorSetting(.delegate(.renderingTypeSelected(.monochrome))))) {
            $0.catalogItemListState.renderingType = .monochrome
            $0.catalogItemListState.secondaryColor = .clear
            $0.catalogItemListState.tertiaryColor = .clear
            $0.catalogSettingsState.catalogSymbolColorSettingState.secondaryColor = .clear
            $0.catalogSettingsState.catalogSymbolColorSettingState.tertiaryColor = .clear

        }
        
        await store.send(.catalogSettings(.catalogSymbolColorSetting(.delegate(.renderingTypeSelected(.multiColor))))) {
            $0.catalogItemListState.renderingType = .multiColor
        }
        
        await store.send(.catalogSettings(.catalogSymbolColorSetting(.delegate(.renderingTypeSelected(.hierarchical))))) {
            $0.catalogItemListState.renderingType = .hierarchical
        }
    }
    
    func test_changeForegroundColor() async {
        
        await store.send(.catalogSettings(.catalogSymbolColorSetting(.delegate(.primaryColorChanged(.blue))))) {
            $0.catalogItemListState.primaryColor = .blue
        }
        
        await store.send(.catalogSettings(.catalogSymbolColorSetting(.delegate(.secondaryColorChanged(.yellow))))) {
            $0.catalogItemListState.secondaryColor = .yellow
        }
        
        await store.send(.catalogSettings(.catalogSymbolColorSetting(.delegate(.tertiaryColorChanged(.red))))) {
            $0.catalogItemListState.tertiaryColor = .red
        }
    }
    
    func test_isKeyboardClosed() async {
        await store.send(.keyboardOpened) {
            $0.isKeyboardClosed = false
        }
        
        await store.send(.keyboardClosed) {
            $0.isKeyboardClosed = true
        }
    }
}
