//
//  Weather_UIAppTests.swift
//  Weather UIAppTests
//
//  Created by Ron Jurincie on 9/23/24.
//

import XCTest

final class Weather_UIAppTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    // Mark: MainView
    @MainActor
    func testMainView() {
        let app = XCUIApplication()
        app.launch()
        
        // When
        let humidityText = app.textViews["Humidity"]
        let pressureText = app.textViews["preaaure"]
        let windImage = app.images["wind"]
        
        // Then
        XCTAssert(humidityText.exists)
        XCTAssert(pressureText.exists)
        XCTAssert(windImage.exists)
    }
    
    @MainActor
    func testIsCelciusWorksProperly() {
        let app = XCUIApplication()
        app.launch()
        
    }
    
    @MainActor
    func testMainViewSettingsButton() {
        let app = XCUIApplication()
        app.launch()
        
        // When
        let settingsButton = app.buttons["Settings"]
        XCTAssert(settingsButton.exists)
        
        // Then
        settingsButton.tap()
        XCTAssert(!settingsButton.exists) // should no longer be a settingsButton
        
        let windImage = app.images["wind"]
        XCTAssert(windImage.exists)
    }
}
