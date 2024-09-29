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
    
    @MainActor
    func testLoadWeather() async throws {
        let viewModel = MainView.ViewModel()
        let lastQuery = "https://api.openweathermap.org/data/2.5/weather?q=New%20York,NY,UnitedStates&appid=b3660824db9ee07a39128f01914989bc"
     
        viewModel.locationManager.weatherQueryString = lastQuery
            
        XCTAssertNotNil(viewModel.locationManager)
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

@MainActor
final class FetcherTests: XCTestCase {
    // Given
    let viewModel = MainView.ViewModel()

    func testWeatherInfoFetching() async throws {
        // When
        let apiService = ApiService.self

        // Then
        /// The image URL in this example returns a random image.
        /// I recommend mocking outgoing network requests as a best practice:
        /// https://avanderlee.com/swift/mocking-alamofire-urlsession-requests/
        let query = viewModel.locationManager.weatherQueryString
        let response: WeatherInfo = try await apiService.fetch(from: query)
        XCTAssertNotNil(response.weather?.description)
    }
    
    func testImageFetching() async throws {
        let queryString = viewModel.locationManager.weatherIconQueryPrefix + "10d" + viewModel.locationManager.weatherIconQuerySuffix
        if let url = URL(string: queryString) {
            let asyncimage = AsyncCachedImage(url: url) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .font(.title)
            } placeholder: {
                ActivityIndicator()
            }
            
            XCTAssertNotNil(asyncimage)
        }
    }
}
