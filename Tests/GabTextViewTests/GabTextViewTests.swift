//
//  GabTextViewTests.swift
//  GabTextViewTests
//
//  Created by Gab on 2024/07/26.
//

import XCTest
import SwiftUI

@testable import GabTextView

final class GabTextViewTests: XCTestCase {
    private var text: String = ""
    var textView: TextView!
    
    override func setUp() {
        super.setUp()
        
        self.text = ""
        self.textView = TextView(text: .init(get: { self.text },
                                             set: { self.text = $0 }))
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testScrollEnabled() {
        XCTAssertNotNil(self.textView)
        
        let _ = self.textView.isScrollEnabled(false)
        
        XCTAssertFalse(self.textView.viewModel(\.scrollViewState.isScrollEnabled))
    }
    
    func testEditable() {
        XCTAssertNotNil(self.textView)
        
        let _ = self.textView.isEditable(false)
        
        XCTAssertFalse(self.textView.viewModel(\.viewState.isEditable))
    }
    
    func testSelectable() {
        XCTAssertNotNil(self.textView)
        
        let _ = self.textView.isSelectable(false)
        
        XCTAssertFalse(self.textView.viewModel(\.viewState.isSelectable))
    }
    
    func testInputModel() {
        XCTAssertNotNil(self.textView)
        
        XCTAssertEqual(TextViewAppearanceModel.default, self.textView.viewModel(\.styleState.appearance))
        
        let focusStyle: TextAppearance = TextAppearance(font: .boldSystemFont(ofSize: 16),
                                              color: .red)
        
        let noneFocusStyle: TextAppearance = TextAppearance(font: .boldSystemFont(ofSize: 16),
                                                  color: .orange)
        
        let _ = self.textView.setTextViewAppearanceModel(TextViewAppearanceModel(noneFocus: noneFocusStyle,
                                                                                 focus: focusStyle))
        
        XCTAssertEqual(noneFocusStyle, self.textView.viewModel(\.styleState.appearance).noneFocus)
        XCTAssertEqual(focusStyle, self.textView.viewModel(\.styleState.appearance).focus)
    }
    
    func testLimtCount() {
        XCTAssertNotNil(self.textView)
        
        self.text = "hohohohohoho"
        
        let _ = self.textView.limitCount(100)
        
        XCTAssertLessThan(self.text.count, self.textView.viewModel(\.styleState.limitCount))
        
        self.text = "GabGabGabGabGabGabGabGabGabGabGabGabGabGabGabGabGabGabGabGabGabGabGabGabGabGabGabGabGabGabGabGabGabGabGabGabGabGabGabGabGabGabGabGabGabGab"
        
        let _ = self.textView.limitCount(150)
        
        XCTAssertLessThan(self.text.count, self.textView.viewModel(\.styleState.limitCount))
    }
    
    func testReceiveTextCount() throws {
        let textView = try XCTUnwrap(self.textView)
        
        let _ = textView.trimMode(.blankWithWhitespacesAndNewlines)
        textView.text = "아나다 아나다 아나다 아나다\n아나다"
        print("상갑 logEvent \(#function) : \(textView.text.count)")
        
        XCTAssertEqual(textView.viewModel(\.styleState.trimMode), .blankWithWhitespacesAndNewlines)
        
        
    }
    
    
    func testAsyncTask() {
        var resultTask: String?
        
//        let exp = expectation(description: "APIProvider Error")
        let exp2 = expectation(description: "Gab Error")
//        let test = XCTestExpectation(description: "hihihi")
        let apiProvider = APIProvider()
        
        XCTAssertNil(resultTask, "미리 할당됨")
        
        apiProvider.asyncTask { text in
            resultTask = text
//            exp.fulfill()
            exp2.fulfill()
//            test.fulfill()
        }
        
//        wait(for: [exp, exp2], timeout: 3)
        waitForExpectations(timeout: 3, handler: nil)
//        wait(for: [test], timeout: 3)
        
        XCTAssertNotNil(resultTask, "작업 안된듯?")
        
//        print(resultTask)
        
        // wait과 waitForExpectations의 차이점은
        // wait은 수동으로 생성된 기대를 wait??
        // waitForExpectations은 기대를 생성하고 그들이 충족되기를 기다리는" 여러 개의 개별 시퀀스를 연결할 수 있습니다. 즉, 기대를 여러개 만들고 여러개의 기대를 이거 하나로 통제할 수 있다.
        // waitForExpectations은 XCTestExpectation은 안기다림
        // wait은 waitForExpectations와 다르게 다 기다림
        
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testClosureTextView2() throws {
        let textview = TextView(text: .init(get: { self.text }, set: { self.text = $0})).textViewConfiguration { textView in
            textView.text = "hi nice to meet you"
        }
        
        XCTAssertNotNil(textview.configuration)
        
        print(textview.text)
    }
    
    override func tearDown() {
        super.tearDown()
        self.text = ""
        self.textView = nil
    }
    
}


class APIProvider {
    func asyncTask(completionHandler: @escaping (String?) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            completionHandler("Hello World !!!")
        }
    }
}
