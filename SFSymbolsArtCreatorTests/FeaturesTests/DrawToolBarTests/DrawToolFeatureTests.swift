//
//  DrawToolFeatureTests.swift
//  SFSymbolsArtCreatorTests
//
//

import ComposableArchitecture
import XCTest
@testable import SFSymbolsArtCreator

@MainActor
final class DrawToolFeatureTests: XCTestCase {
    
    private lazy var store: TestStore<DrawToolFeature.State, DrawToolFeature.Action> = {
        preconditionFailure("store has not been set")
    }()

    override func setUpWithError() throws {
        store = TestStore(initialState: DrawToolFeature.State(renderingType: .monochrome)) {
            DrawToolFeature()
        }
    }
    
    func test_editButtonTapped() async {
        
        store.exhaustivity = .off
        await store.send(.editButtonTapped) {
            $0.isEditMode = true
        }
        await store.send(.delegate(.editButtonToggled(true)))
        
        await store.send(.editButtonTapped) {
            $0.isEditMode = false
        }
        await store.send(.delegate(.editButtonToggled(false)))
    }
    
    func test_layerButtonTapped() async {
        
        store.exhaustivity = .off
        await store.send(.layerButtonTapped) {
            $0.layerPanelIsPresented = true
        }
        
        await store.send(.layerButtonTapped) {
            $0.layerPanelIsPresented = false
        }
    }
    
    func test_layerIsPresented() async {
        
        store.exhaustivity = .off
        await store.send(.layerButtonTapped) {
            $0.layerPanelIsPresented = true
        }
        await store.send(.editButtonTapped)
        store.assert {
            $0.layerPanelIsPresented = false
        }
        
        await store.send(.layerButtonTapped) {
            $0.layerPanelIsPresented = true
        }
        await store.send(.renderingTypeChanged(.hierarchical))
        store.assert {
            $0.layerPanelIsPresented = false
        }
    }
    
    func test_renderingChanged() async {
        
        await store.send(.renderingTypeChanged(.multiColor)) {
            $0.renderingType = .multiColor
        }
                
        await store.send(.renderingTypeChanged(.monochrome)) {
            $0.renderingType = .monochrome
        }
    }
}
