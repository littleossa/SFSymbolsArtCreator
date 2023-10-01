//
//  CatalogSymbolColorSettingFeatureTests.swift
//  SFSymbolsArtCreatorTests
//
//

import ComposableArchitecture
import XCTest
@testable import SFSymbolsArtCreator

final class CatalogSymbolColorSettingFeatureTests: XCTestCase {
    
    private lazy var store: TestStore<CatalogSymbolColorSettingFeature.State, CatalogSymbolColorSettingFeature.Action> = {
        preconditionFailure("store has not been set")
    }()

    override func setUpWithError() throws {
        store = TestStore(
            initialState: CatalogSymbolColorSettingFeature.State(
                renderingType: .monochrome,
                primaryColor: .black,
                secondaryColor: .accentColor,
                tertiaryColor: .white)
        ) {
            CatalogSymbolColorSettingFeature()
        }
    }
    
    func test_colorButtonTapped() async {
        
        store.exhaustivity = .off
        await store.send(.primaryColorButtonTapped) {
            $0.colorPicker = ColorPickerFeature.State(colorType: .primary, selectedColor: $0.primaryColor)
        }
        await store.send(.colorPicker(.presented(.delegate(.selectColor(.primary, .red))))) {
            $0.primaryColor = .red
        }
        
        await store.send(.secondaryColorButtonTapped) {
            $0.colorPicker = ColorPickerFeature.State(colorType: .secondary, selectedColor: $0.secondaryColor)
        }
        await store.send(.colorPicker(.presented(.delegate(.selectColor(.secondary, .yellow))))) {
            $0.secondaryColor = .yellow
        }
        
        await store.send(.tertiaryColorButtonTapped) {
            $0.colorPicker = ColorPickerFeature.State(colorType: .tertiary, selectedColor: $0.tertiaryColor)
        }
        await store.send(.colorPicker(.presented(.delegate(.selectColor(.tertiary, .brown))))) {
            $0.tertiaryColor = .brown
        }
    }
    
    func test_selectRenderingType() async {
        
        store.exhaustivity = .off
        await store.send(.renderingTypeSelected(.palette)) {
            $0.renderingType = .palette
            $0.secondaryColor = .accentColor
            $0.tertiaryColor = .white
        }
        await store.send(.delegate(.renderingTypeSelected(.palette)))
        
        await store.send(.renderingTypeSelected(.monochrome)) {
            $0.renderingType = .monochrome
            $0.secondaryColor = .clear
            $0.tertiaryColor = .clear
        }
        await store.send(.delegate(.renderingTypeSelected(.monochrome)))
        
        await store.send(.renderingTypeSelected(.hierarchical)) {
            $0.renderingType = .hierarchical
        }
        await store.send(.delegate(.renderingTypeSelected(.hierarchical)))
        
        await store.send(.renderingTypeSelected(.multiColor)) {
            $0.renderingType = .multiColor
        }
        await store.send(.delegate(.renderingTypeSelected(.multiColor)))
    }
}
