//
//  DoubleExtensionTests.swift
//  SFSymbolsArtCreatorTests
//
//

import XCTest
@testable import SFSymbolsArtCreator

final class DoubleExtensionTests: XCTestCase {
    
    func test_rotatingWithin360ByDegrees() {
        
        XCTContext.runActivity(named: "Rotate By Specified Degrees") { _ in
            let value: Double = 10
            let rotatedValue = value.rotatingWithin360ByDegrees(45)
            XCTAssertEqual(rotatedValue, 55)
        }
        
        XCTContext.runActivity(named: "Rotate Up To 0 Degrees") { _ in
            let value: Double = 0
            let rotatedValue = value.rotatingWithin360ByDegrees(0)
            XCTAssertEqual(rotatedValue, 0)
        }
        
        XCTContext.runActivity(named: "Rotate Up To 360 Degrees") { _ in
            let value: Double = 100
            let rotatedValue = value.rotatingWithin360ByDegrees(260)
            XCTAssertEqual(rotatedValue, 360)
        }
        
        XCTContext.runActivity(named: "Rotate Beyond 360 Degrees") { _ in
            let value: Double = 320
            let rotatedValue = value.rotatingWithin360ByDegrees(41)
            XCTAssertEqual(rotatedValue, 1)
        }
        
        XCTContext.runActivity(named: "Rotate Negative Degrees Within 360 Degrees") { _ in
            let value: Double = 0
            let rotatedValue = value.rotatingWithin360ByDegrees(-1)
            XCTAssertEqual(rotatedValue, 359)
        }
    }
}
