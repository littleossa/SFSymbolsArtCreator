//
//  EditPointScalingTests.swift
//  SFSymbolsArtCreatorTests
//
//

import XCTest
@testable import SFSymbolsArtCreator

final class EditPointScalingTests: XCTestCase {
    
    func test_scaleSize() {
        
        var scaling = EditPointScaling(position: .topLeft,
                                     dragGestureTranslation: CGSize(width: 100, height: 100))
        XCTAssertEqual(scaling.value.scaleSize, CGSize(width: -100, height: -100))
        
        scaling = EditPointScaling(position: .topCenter,
                                     dragGestureTranslation: CGSize(width: 100, height: 100))
        XCTAssertEqual(scaling.value.scaleSize, CGSize(width: 0, height: -100))
        
        scaling = EditPointScaling(position: .topRight,
                                     dragGestureTranslation: CGSize(width: 100, height: 100))
        XCTAssertEqual(scaling.value.scaleSize, CGSize(width: 100, height: -100))
        
        scaling = EditPointScaling(position: .middleLeft,
                                     dragGestureTranslation: CGSize(width: 100, height: 100))
        XCTAssertEqual(scaling.value.scaleSize, CGSize(width: -100, height: 0))
        
        scaling = EditPointScaling(position: .middleRight,
                                     dragGestureTranslation: CGSize(width: 100, height: 100))
        XCTAssertEqual(scaling.value.scaleSize, CGSize(width: 100, height: 0))
        
        scaling = EditPointScaling(position: .bottomLeft,
                                     dragGestureTranslation: CGSize(width: 100, height: 100))
        XCTAssertEqual(scaling.value.scaleSize, CGSize(width: -100, height: 100))
        
        scaling = EditPointScaling(position: .bottomCenter,
                                     dragGestureTranslation: CGSize(width: 100, height: 100))
        XCTAssertEqual(scaling.value.scaleSize, CGSize(width: 0, height: 100))
        
        scaling = EditPointScaling(position: .bottomRight,
                                     dragGestureTranslation: CGSize(width: 100, height: 100))
        XCTAssertEqual(scaling.value.scaleSize, CGSize(width: 100, height: 100))
    }
    
    func test_scaleValue() {
        
        var scaling = EditPointScaling(position: .topLeft,
                                     dragGestureTranslation: CGSize(width: 150, height: 100))
        XCTAssertEqual(scaling.value.scaleValue, -150)
        
        scaling = EditPointScaling(position: .topCenter,
                                     dragGestureTranslation: CGSize(width: 150, height: 100))
        XCTAssertEqual(scaling.value.scaleValue, -100)
        
        scaling = EditPointScaling(position: .topRight,
                                     dragGestureTranslation: CGSize(width: 150, height: 100))
        XCTAssertEqual(scaling.value.scaleValue, 150)

        scaling = EditPointScaling(position: .middleLeft,
                                     dragGestureTranslation: CGSize(width: 150, height: 100))
        XCTAssertEqual(scaling.value.scaleValue, -150)

        scaling = EditPointScaling(position: .middleRight,
                                     dragGestureTranslation: CGSize(width: 150, height: 100))
        XCTAssertEqual(scaling.value.scaleValue, 150)

        scaling = EditPointScaling(position: .bottomLeft,
                                     dragGestureTranslation: CGSize(width: 150, height: 100))
        XCTAssertEqual(scaling.value.scaleValue, -150)

        scaling = EditPointScaling(position: .bottomCenter,
                                     dragGestureTranslation: CGSize(width: 150, height: 100))
        XCTAssertEqual(scaling.value.scaleValue, 100)

        scaling = EditPointScaling(position: .bottomRight,
                                     dragGestureTranslation: CGSize(width: 150, height: 100))
        XCTAssertEqual(scaling.value.scaleValue, 150)
    }
}
