//
//  RainbowTests.swift
//  RainbowTests
//
//  Created by WANG WEI on 2015/12/22.
//  Copyright © 2015年 OneV's Den. All rights reserved.
//

import XCTest
@testable import Rainbow

class RainbowTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExtractModesNotMatch() {
        let result1 = Rainbow.extractModesForString("abc")
        XCTAssertNil(result1.color)
        XCTAssertNil(result1.backgroundColor)
        XCTAssertNil(result1.styles)
        XCTAssertEqual(result1.text, "abc")
        
        let result2 = Rainbow.extractModesForString("\u{001B}[0mHello\u{001B}")
        XCTAssertNil(result2.color)
        XCTAssertNil(result2.backgroundColor)
        XCTAssertNil(result2.styles)
        XCTAssertEqual(result2.text, "\u{001B}[0mHello\u{001B}")
        
        let result3 = Rainbow.extractModesForString("\u{001B}[fg0,0,0;Hello\u{001B}")
        XCTAssertNil(result3.color)
        XCTAssertNil(result3.backgroundColor)
        XCTAssertNil(result3.styles)
        XCTAssertEqual(result3.text, "\u{001B}[fg0,0,0;Hello\u{001B}")
    }
    
    func testExtractModes() {
        let result1 = Rainbow.extractModesForString("\u{001B}[0m\u{001B}[0m")
        XCTAssertNil(result1.color)
        XCTAssertNil(result1.backgroundColor)
        XCTAssertEqual(result1.styles!, [.Default])
        XCTAssertEqual(result1.text, "")
        
        let result2 = Rainbow.extractModesForString("\u{001B}[31mHello World\u{001B}[0m")
        XCTAssertEqual(result2.color!, Color.Red)
        XCTAssertNil(result2.backgroundColor)
        XCTAssertNil(result2.styles)
        XCTAssertEqual(result2.text, "Hello World")
        
        let result3 = Rainbow.extractModesForString("\u{001B}[4;31;42;93;5mHello World\u{001B}[0m")
        XCTAssertEqual(result3.color!, Color.LightYellow)
        XCTAssertEqual(result3.backgroundColor, BackgroundColor.Green)
        XCTAssertEqual(result3.styles!, [.Underline, .Blink])
        XCTAssertEqual(result3.text, "Hello World")
        
        let result4 = Rainbow.extractModesForString("\u{001B}[31m\u{001B}[4;31;93mHello World\u{001B}[0m\u{001B}[0m")
        XCTAssertEqual(result4.color!, Color.Red)
        XCTAssertNil(result4.backgroundColor)
        XCTAssertNil(result4.styles)
        XCTAssertEqual(result4.text, "\u{001B}[4;31;93mHello World\u{001B}[0m")
        
        let result5 = Rainbow.extractModesForString("\u{001B}[fg0,0,0;Hello\u{001B}[;")
        XCTAssertEqual(result5.color!, Color.Black)
        XCTAssertNil(result5.backgroundColor)
        XCTAssertNil(result5.styles)
        XCTAssertEqual(result5.text, "Hello")
        
        let result6 = Rainbow.extractModesForString("\u{001B}[fg0,0,0;\u{001B}[bg255,0,0;Hello\u{001B}[;")
        XCTAssertEqual(result6.color!, Color.Black)
        XCTAssertEqual(result6.backgroundColor, BackgroundColor.Red)
        XCTAssertNil(result6.styles)
        XCTAssertEqual(result6.text, "Hello")
    }
    
    func testGenerateConsoleStringWithCodes() {
        
        Rainbow.outputTarget = .Console
        
        let result1 = Rainbow.generateStringForColor(nil, backgroundColor: nil, styles: nil, text: "Hello")
        XCTAssertEqual(result1, "Hello")
        
        let result2 = Rainbow.generateStringForColor(.Red, backgroundColor: nil, styles: nil, text: "Hello")
        XCTAssertEqual(result2, "\u{001B}[31mHello\u{001B}[0m")
        
        let result3 = Rainbow.generateStringForColor(.LightYellow, backgroundColor: .Magenta, styles: [.Bold, .Blink], text: "Hello")
        XCTAssertEqual(result3, "\u{001B}[93;45;1;5mHello\u{001B}[0m")
    }
    
    func testGenerateXcodeColorsStringWithCodes() {
        
        Rainbow.outputTarget = .XcodeColors
        
        let result1 = Rainbow.generateStringForColor(nil, backgroundColor: nil, styles: nil, text: "Hello")
        XCTAssertEqual(result1, "Hello")
        
        let result2 = Rainbow.generateStringForColor(.Red, backgroundColor: nil, styles: nil, text: "Hello")
        XCTAssertEqual(result2, "\u{001B}[fg255,0,0;Hello\u{001B}[;")
        
        let result3 = Rainbow.generateStringForColor(.LightYellow, backgroundColor: .Magenta, styles: [.Bold, .Blink], text: "Hello")
        XCTAssertEqual(result3, "\u{001B}[fg255,255,102;\u{001B}[bg255,0,255;Hello\u{001B}[;")
    }
    
    func testGenerateUnknownStringWithCodes() {
        Rainbow.outputTarget = .Unknown
        
        let result1 = Rainbow.generateStringForColor(nil, backgroundColor: nil, styles: nil, text: "Hello")
        XCTAssertEqual(result1, "Hello")
        
        let result2 = Rainbow.generateStringForColor(.Red, backgroundColor: nil, styles: nil, text: "Hello")
        XCTAssertEqual(result2, "Hello")
        
        let result3 = Rainbow.generateStringForColor(.LightYellow, backgroundColor: .Magenta, styles: [.Bold, .Blink], text: "Hello")
        XCTAssertEqual(result3, "Hello")
    }
    
    func testRainbowEnabled() {
        Rainbow.outputTarget = .Console
        
        let result1 = "Hello".red
        XCTAssertEqual(result1, "\u{001B}[31mHello\u{001B}[0m")
        
        Rainbow.enabled = false
        
        let result2 = "Hello".red
        XCTAssertEqual(result2, "Hello")

        Rainbow.enabled = true
    }
}
