//
//  FlipTypeTests.swift
//  SFSymbolsArtCreatorTests
//
//

import XCTest
@testable import SFSymbolsArtCreator

final class FlipTypeTests: XCTestCase {

    func test_init() {
        
        var value = FlipType(isFlippedHorizontal: true, isFlippedVertical: false)
        XCTAssertEqual(value, .horizontal)
        
        value = FlipType(isFlippedHorizontal: true, isFlippedVertical: true)
        XCTAssertEqual(value, .horizontalAndVertical)

        value = FlipType(isFlippedHorizontal: false, isFlippedVertical: true)
        XCTAssertEqual(value, .vertical)
        
        value = FlipType(isFlippedHorizontal: false, isFlippedVertical: false)
        XCTAssertEqual(value, .none)
    }
    
    func test_isFlippedHorizontal() {
        XCTAssertTrue(FlipType.horizontal.value.isFlippedHorizontal)
        XCTAssertTrue(FlipType.horizontalAndVertical.value.isFlippedHorizontal)
        XCTAssertFalse(FlipType.none.value.isFlippedHorizontal)
        XCTAssertFalse(FlipType.vertical.value.isFlippedHorizontal)
    }
    
    func test_isFlippedVertical() {
        XCTAssertFalse(FlipType.horizontal.value.isFlippedVertical)
        XCTAssertTrue(FlipType.horizontalAndVertical.value.isFlippedVertical)
        XCTAssertFalse(FlipType.none.value.isFlippedVertical)
        XCTAssertTrue(FlipType.vertical.value.isFlippedVertical)
    }
    
    func test_rotationEffectAxis() {
        
        XCTAssertEqual(RotationEffectAxis(x: 0, y: 1, z: 0),
                       FlipType.horizontal.value.rotationEffectAxis)
        
        XCTAssertEqual(RotationEffectAxis(x: 0, y: 0, z: 1),
                       FlipType.horizontalAndVertical.value.rotationEffectAxis)
        
        XCTAssertEqual(RotationEffectAxis(x: 1, y: 0, z: 0),
                       FlipType.vertical.value.rotationEffectAxis)
        
        XCTAssertEqual(RotationEffectAxis(x: 0, y: 0, z: 0),
                       FlipType.none.value.rotationEffectAxis)
    }
}
