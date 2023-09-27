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
        store = TestStore(initialState: DrawToolFeature.State()) {
            DrawToolFeature()
        }
    }
    
    func test_editButtonTapped() async {
        
        await store.send(.editButtonTapped) {
            $0.isEditMode = true
        }
        
        await store.send(.editButtonTapped) {
            $0.isEditMode = false
        }
    }
    
    func test_eraserButtonTapped() async {
        
        await store.send(.eraserButtonTapped) {
            $0.isEraserMode = true
        }
        
        await store.send(.eraserButtonTapped) {
            $0.isEraserMode = false
        }
    }
    
    func test_layerButtonTapped() async {
        
        await store.send(.layerButtonTapped) {
            $0.layerPanelIsPresented = true
        }
        
        await store.send(.layerButtonTapped) {
            $0.layerPanelIsPresented = false
        }
    }
    
    func test_renderingChanged() async {
        
        await store.send(.renderingChanged(.multiColor)) {
            $0.renderingType = .multiColor
        }
        
        await store.send(.renderingChanged(.monochrome)) {
            $0.renderingType = .monochrome
        }
    }
}
