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
        
        for _ in 0...20 {
            var rand = Int.random(in: 0..<22)
            XCTAssertEqual(viewModel.getWindDirectionImage(rand), image000)
            
            rand = Int.random(in: 22..<67)
            XCTAssertEqual(viewModel.getWindDirectionImage(rand), image045)
            
            rand = Int.random(in: 67..<112)
            XCTAssertEqual(viewModel.getWindDirectionImage(rand), image090)
            
            rand = Int.random(in: 112..<157)
            XCTAssertEqual(viewModel.getWindDirectionImage(rand), image135)
            
            rand = Int.random(in: 157..<202)
            XCTAssertEqual(viewModel.getWindDirectionImage(rand), image180)
            
            rand = Int.random(in: 202..<247)
            XCTAssertEqual(viewModel.getWindDirectionImage(rand), image225)
            
            rand = Int.random(in: 247..<292)
            XCTAssertEqual(viewModel.getWindDirectionImage(rand), image270)
            
            rand = Int.random(in: 292..<337)
            XCTAssertEqual(viewModel.getWindDirectionImage(rand), image315)
            
            rand = Int.random(in: 337..<360)
            XCTAssertEqual(viewModel.getWindDirectionImage(rand), image000)
        }
    }
}
