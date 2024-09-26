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
    func testDistanceConversion() {
        let kph = metersPerSecondToKph(10)
        XCTAssertEqual(kph, 36)
        
        let mph = metersPerSecondToMph(10)
        XCTAssertEqual(floor(mph), 22)
        
    }
    
    func testTemperatureConversion() {
        let celsius = kelvinToCelsius(273.5)
        XCTAssertEqual(floor(celsius), 0)
        
        let fahrenheit = kelvinToFahrenheit(273.5)
        XCTAssertEqual(floor(fahrenheit), 32)
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
        var rand = 0
        
        for _ in 0...20 {
            rand = Int.random(in: 0..<22)
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
