//
//  GabTextViewDemoUITests.swift
//  GabTextViewDemoUITests
//
//  Created by Gab on 2024/07/26.
//

import XCTest

final class GabTextViewDemoUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
//        let textview =  app.staticTexts["GabTextView"].firstMatch
        let textView = app.textViews["GabTextView"].firstMatch
        
        XCTAssertNotNil(textView)
        
        textView.tap()
//        textView.typeText("Hi Nice to meet you")
        textView.typeText("h\nq\nw\ne\nr\nt\ny\n")
        textView.typeText("limit count test")
        
        let hideText = app.staticTexts["키보드 내려"].firstMatch
        
        XCTAssertNotNil(hideText)
        
        hideText.tap()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testTextConfiguration() throws {
        let app = XCUIApplication()
        app.launch()
        
        let textView = app.textViews["GabTextView"].firstMatch
        
        XCTAssertNotNil(textView)
        
        textView.tap()
        textView.typeText("속성 테스트 컬러 변경")
        
        let hideText = app.staticTexts["키보드 내려"].firstMatch
        
        XCTAssertNotNil(hideText)
        
        hideText.tap()
        
        let changeText = app.staticTexts["속성 변경"].firstMatch
        
        XCTAssertNotNil(changeText)
        
        changeText.tap()
    }
    
    
    func testReceiveModifier() throws {
        let app = XCUIApplication()
        app.launch()
        
        let textView = app.textViews["GabTextView"].firstMatch
        
        XCTAssertNotNil(textView)
        
        textView.tap()
        textView.typeText("가나다라마바사\n")
        textView.typeText("아아  이것은 퇴근이다")
        
        let breakView = app.otherElements["lineWithContinuousWhiteSpace 변경"].firstMatch
        
        XCTAssertNotNil(breakView)
        
        breakView.tap()
        
        textView.typeText("가\n나\n다\n라\n")
    }
    
    func testReassembleModifier() throws {
        let app = XCUIApplication()
        app.launch()
        
        let textView = app.textViews["GabTextView"].firstMatch
        
        XCTAssertNotNil(textView)
        
        let appendBtn = app.otherElements["Text 변경"].firstMatch
        print("상갑 logEvent \(#function) appendBtn: \(appendBtn)")
        XCTAssertNotNil(appendBtn)
        
        appendBtn.tap()
        appendBtn.tap()
        appendBtn.tap()
        
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
