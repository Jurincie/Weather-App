//
//  Weather_AppTests.swift
//  Weather AppTests
//
//  Created by Ron Jurincie on 9/23/24.
//

import SwiftUI
import XCTest
@testable import Weather_App

final class Weather_AppTests: XCTestCase {

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

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testGetWindDirectionImage() {
        let viewModel = MainView.ViewModel()
        
        let image000 = Image(systemName: "arrow.down")
        let image045 = Image(systemName: "arrow.down.left")
        let image090 = Image(systemName: "arrow.left")
        let image135 = Image(systemName: "arrow.up.left")
        let image180 = Image(systemName: "arrow.up")
        let image225 = Image(systemName: "arrow.up.right")
        let image270 = Image(systemName: "arrow.right")
        let image315 = Image(systemName: "arrow.down.right")
        
        for _ in 0...10 {
            var rand = Int.random(in: 0..<22)
            var value = rand
            print(value)
            XCTAssertEqual(viewModel.getWindDirectionImage(value), image000)
            
            rand = Int.random(in: 0..<22)
            value = (Bool.random() ? 45+rand : 45-rand)
            print(value)
            XCTAssertEqual(viewModel.getWindDirectionImage(value), image045)
            
            rand = Int.random(in: 0..<22)
            value = (Bool.random() ? 90+rand : 90-rand)
            print(value)
            XCTAssertEqual(viewModel.getWindDirectionImage(90), image090)
            
            rand = Int.random(in: 0..<22)
            value = (Bool.random() ? 135+rand : 135-rand)
            print(value)
            XCTAssertEqual(viewModel.getWindDirectionImage(135), image135)
            
            rand = Int.random(in: 0..<22)
            value = (Bool.random() ? 180+rand : 180-rand)
            print(value)
            XCTAssertEqual(viewModel.getWindDirectionImage(value), image180)
            
            rand = Int.random(in: 0..<22)
            value = (Bool.random() ? 225+rand : 225-rand)
            print(value)
            XCTAssertEqual(viewModel.getWindDirectionImage(value), image225)
            
            rand = Int.random(in: 0..<22)
            value = (Bool.random() ? 270+rand : 270-rand)
            print(value)
            XCTAssertEqual(viewModel.getWindDirectionImage(value), image270)
        }
    }
}
