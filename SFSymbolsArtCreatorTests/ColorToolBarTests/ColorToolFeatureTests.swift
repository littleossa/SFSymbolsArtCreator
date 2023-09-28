//
//  ColorToolFeatureTests.swift
//  SFSymbolsArtCreatorTests
//
//

import ComposableArchitecture
import XCTest
@testable import SFSymbolsArtCreator

@MainActor
final class ColorToolFeatureTests: XCTestCase {

    func test_colorButtonTapped() async {
        let store = TestStore(initialState: ColorToolFeature.State(renderingType: .monochrome)) {
            ColorToolFeature()
        }
        
        await store.send(.primaryColorButtonTapped) {
            $0.colorPicker = ColorPickerFeature.State(colorType: .primary, selectedColor: $0.primaryColor)
        }
        
        await store.send(.secondaryColorButtonTapped) {
            $0.colorPicker = ColorPickerFeature.State(colorType: .secondary, selectedColor: $0.secondaryColor)
        }
        
        await store.send(.tertiaryColorButtonTapped) {
            $0.colorPicker = ColorPickerFeature.State(colorType: .tertiary, selectedColor: $0.tertiaryColor)
        }
        
        await store.send(.canvasColorButtonTapped) {
            $0.colorPicker = ColorPickerFeature.State(colorType: .canvas, selectedColor: $0.canvasColor)
        }
    }
    
    func test_isOnlyPrimaryColorEnabled() async {
        
        XCTContext.runActivity(named: "Monochrome is only primary color enabled") { _ in
            let store = TestStore(initialState: ColorToolFeature.State(renderingType: .monochrome)) {
                ColorToolFeature()
            }
            XCTAssertTrue(store.state.isOnlyPrimaryColorEnabled)
        }
        
        XCTContext.runActivity(named: "MultiColor is only primary color enabled") { _ in
            let store = TestStore(initialState: ColorToolFeature.State(renderingType: .multiColor)) {
                ColorToolFeature()
            }
            XCTAssertTrue(store.state.isOnlyPrimaryColorEnabled)
        }
        
        XCTContext.runActivity(named: "Hierarchical is only primary color enabled") { _ in
            let store = TestStore(initialState: ColorToolFeature.State(renderingType: .hierarchical)) {
                ColorToolFeature()
            }
            XCTAssertTrue(store.state.isOnlyPrimaryColorEnabled)
        }
        
        XCTContext.runActivity(named: "Palette is not only primary color enabled") { _ in
            let store = TestStore(initialState: ColorToolFeature.State(renderingType: .palette)) {
                ColorToolFeature()
            }
            XCTAssertFalse(store.state.isOnlyPrimaryColorEnabled)
        }
    }
}
