//
//  EditFormTypeTests.swift
//  SFSymbolsArtCreatorTests
//
//

import XCTest
@testable import SFSymbolsArtCreator

final class EditFormTypeTests: XCTestCase {
    
    func test_scaledWidth_with_freeForm() {
        
        let editForm: EditFormType = .freeForm
        
        var scaling = EditPointScaling(position: .bottomRight,
                                     dragGestureTranslation: CGSize(width: 150, height: 100))
        var width = editForm.scaledWidth(by: scaling.value, beforeWidth: 100)
        XCTAssertEqual(width, 250)
        
        XCTContext.runActivity(named: "Scaling below Minimum Width is nil") { _ in
            
            XCTAssertEqual(AppConfig.minScalingWidth, 10)
            
            scaling = EditPointScaling(position: .topLeft,
                                         dragGestureTranslation: CGSize(width: 89, height: 100))
            width = editForm.scaledWidth(by: scaling.value, beforeWidth: 100)
            XCTAssertEqual(width, 11)
                        
            scaling = EditPointScaling(position: .topLeft,
                                         dragGestureTranslation: CGSize(width: 90, height: 100))
            width = editForm.scaledWidth(by: scaling.value, beforeWidth: 100)
            XCTAssertNil(width)
            
            scaling = EditPointScaling(position: .topLeft,
                                         dragGestureTranslation: CGSize(width: 91, height: 100))
            width = editForm.scaledWidth(by: scaling.value, beforeWidth: 100)
            XCTAssertNil(width)
        }
    }
    
    func test_scaledHeight_with_freeForm() {
        
        let editForm: EditFormType = .freeForm
        
        var scaling = EditPointScaling(position: .bottomRight,
                                     dragGestureTranslation: CGSize(width: 150, height: 100))
        var height = editForm.scaledHeight(by: scaling.value, beforeHeight: 80)
        XCTAssertEqual(height, 180)
        
        XCTContext.runActivity(named: "Scaling below Minimum Height is nil") { _ in
            
            XCTAssertEqual(AppConfig.minScalingHeight, 10)
            
            scaling = EditPointScaling(position: .topLeft,
                                         dragGestureTranslation: CGSize(width: 89, height: 69))
            height = editForm.scaledHeight(by: scaling.value, beforeHeight: 80)
            XCTAssertEqual(height, 11)
                        
            scaling = EditPointScaling(position: .topRight,
                                         dragGestureTranslation: CGSize(width: 90, height: 70))
            height = editForm.scaledHeight(by: scaling.value, beforeHeight: 80)
            XCTAssertNil(height)
            
            scaling = EditPointScaling(position: .topRight,
                                         dragGestureTranslation: CGSize(width: 91, height: 71))
            height = editForm.scaledHeight(by: scaling.value, beforeHeight: 80)
            XCTAssertNil(height)
        }
    }
    
    func test_scaledWidth_with_uniform() {
        
        let editForm: EditFormType = .uniform
        
        var scaling = EditPointScaling(position: .topCenter,
                                       dragGestureTranslation: CGSize(width: 150, height: 100))
        var width = editForm.scaledWidth(by: scaling.value, beforeWidth: 200)
        XCTAssertEqual(width, 100)
        
        XCTContext.runActivity(named: "Scaling below Minimum Width is nil") { _ in
            
            XCTAssertEqual(AppConfig.minScalingWidth, 10)
            
            scaling = EditPointScaling(position: .topCenter,
                                       dragGestureTranslation: CGSize(width: 150, height: 189))
            width = editForm.scaledWidth(by: scaling.value, beforeWidth: 200)
            XCTAssertEqual(width, 11)
            
            scaling = EditPointScaling(position: .topCenter,
                                       dragGestureTranslation: CGSize(width: 150, height: 190))
            width = editForm.scaledWidth(by: scaling.value, beforeWidth: 200)
            XCTAssertNil(width)
            
            scaling = EditPointScaling(position: .topCenter,
                                       dragGestureTranslation: CGSize(width: 150, height: 191))
            width = editForm.scaledWidth(by: scaling.value, beforeWidth: 200)
            XCTAssertNil(width)
        }
    }
    
    func test_scaledHeight_with_uniform() {
        
        let editForm: EditFormType = .freeForm
        
        var scaling = EditPointScaling(position: .bottomRight,
                                     dragGestureTranslation: CGSize(width: 150, height: 100))
        var height = editForm.scaledHeight(by: scaling.value, beforeHeight: 80)
        XCTAssertEqual(height, 180)
        
        XCTContext.runActivity(named: "Scaling below Minimum Height is nil") { _ in
            
            XCTAssertEqual(AppConfig.minScalingHeight, 10)
            
            scaling = EditPointScaling(position: .topLeft,
                                         dragGestureTranslation: CGSize(width: 89, height: 69))
            height = editForm.scaledHeight(by: scaling.value, beforeHeight: 80)
            XCTAssertEqual(height, 11)
                        
            scaling = EditPointScaling(position: .topRight,
                                         dragGestureTranslation: CGSize(width: 90, height: 70))
            height = editForm.scaledHeight(by: scaling.value, beforeHeight: 80)
            XCTAssertNil(height)
            
            scaling = EditPointScaling(position: .topRight,
                                         dragGestureTranslation: CGSize(width: 91, height: 71))
            height = editForm.scaledHeight(by: scaling.value, beforeHeight: 80)
            XCTAssertNil(height)
        }
    }
}
