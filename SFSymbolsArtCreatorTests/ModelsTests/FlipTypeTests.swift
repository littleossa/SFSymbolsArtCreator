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
