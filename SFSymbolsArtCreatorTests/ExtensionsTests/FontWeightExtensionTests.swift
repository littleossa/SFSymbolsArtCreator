//
//  FontWeightExtensionTests.swift
//  SFSymbolsArtCreatorTests
//
//

import SwiftUI
import XCTest
@testable import SFSymbolsArtCreator

final class FontWeightExtensionTests: XCTestCase {
    
    func test_decreased() {
        var weight: Font.Weight = .black
        weight = weight.decreased()
        XCTAssertEqual(weight, .heavy)
        
        weight = weight.decreased()
        XCTAssertEqual(weight, .bold)
        
        weight = weight.decreased()
        XCTAssertEqual(weight, .semibold)
        
        weight = weight.decreased()
        XCTAssertEqual(weight, .medium)
        
        weight = weight.decreased()
        XCTAssertEqual(weight, .regular)
        
        weight = weight.decreased()
        XCTAssertEqual(weight, .light)
        
        weight = weight.decreased()
        XCTAssertEqual(weight, .thin)
        
        weight = weight.decreased()
        XCTAssertEqual(weight, .ultraLight)
        
        weight = weight.decreased()
        XCTAssertEqual(weight, .ultraLight)
    }
    
    func test_increased() {
        var weight: Font.Weight = .ultraLight
        weight = weight.increased()
        XCTAssertEqual(weight, .thin)
        
        weight = weight.increased()
        XCTAssertEqual(weight, .light)
        
        weight = weight.increased()
        XCTAssertEqual(weight, .regular)
        
        weight = weight.increased()
        XCTAssertEqual(weight, .medium)
        
        weight = weight.increased()
        XCTAssertEqual(weight, .semibold)
        
        weight = weight.increased()
        XCTAssertEqual(weight, .bold)
        
        weight = weight.increased()
        XCTAssertEqual(weight, .heavy)
        
        weight = weight.increased()
        XCTAssertEqual(weight, .black)
        
        weight = weight.increased()
        XCTAssertEqual(weight, .black)
    }
    
    func test_init() {
        XCTContext.runActivity(named: "Font Weight ultraLight for slider Value 1") { _ in
            let value = Font.Weight(sliderValue: 1)
            XCTAssertEqual(value, .ultraLight)
        }
        
        XCTContext.runActivity(named: "Font Weight thin for slider Value 2") { _ in
            let value = Font.Weight(sliderValue: 2)
            XCTAssertEqual(value, .thin)
        }
        
        XCTContext.runActivity(named: "Font Weight light for slider Value 3") { _ in
            let value = Font.Weight(sliderValue: 3)
            XCTAssertEqual(value, .light)
        }
        
        XCTContext.runActivity(named: "Font Weight regular for slider Value 4") { _ in
            let value = Font.Weight(sliderValue: 4)
            XCTAssertEqual(value, .regular)
        }
        
        XCTContext.runActivity(named: "Font Weight medium for slider Value 5") { _ in
            let value = Font.Weight(sliderValue: 5)
            XCTAssertEqual(value, .medium)
        }
        
        XCTContext.runActivity(named: "Font Weight semibold for slider Value 6") { _ in
            let value = Font.Weight(sliderValue: 6)
            XCTAssertEqual(value, .semibold)
        }
        
        XCTContext.runActivity(named: "Font Weight bold for slider Value 7") { _ in
            let value = Font.Weight(sliderValue: 7)
            XCTAssertEqual(value, .bold)
        }
        
        XCTContext.runActivity(named: "Font Weight heavy for slider Value 8") { _ in
            let value = Font.Weight(sliderValue: 8)
            XCTAssertEqual(value, .heavy)
        }
        
        XCTContext.runActivity(named: "Font Weight black for slider Value 9") { _ in
            let value = Font.Weight(sliderValue: 9)
            XCTAssertEqual(value, .black)
        }
    }
    
    func test_sliderValue() {
        XCTAssertEqual(1, Font.Weight.ultraLight.sliderValue)
        XCTAssertEqual(2, Font.Weight.thin.sliderValue)
        XCTAssertEqual(3, Font.Weight.light.sliderValue)
        XCTAssertEqual(4, Font.Weight.regular.sliderValue)
        XCTAssertEqual(5, Font.Weight.medium.sliderValue)
        XCTAssertEqual(6, Font.Weight.semibold.sliderValue)
        XCTAssertEqual(7, Font.Weight.bold.sliderValue)
        XCTAssertEqual(8, Font.Weight.heavy.sliderValue)
        XCTAssertEqual(9, Font.Weight.black.sliderValue)
    }
}
