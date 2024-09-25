//
//  ViewModel+MainViewExtension.swift
//  Weather App
//
//  Created by Ron Jurincie on 9/19/24.
//

import Foundation
import CoreLocation
import SwiftUI

extension MainView {
    @Observable
    class ViewModel {
        var lastLocation: String?
        let formatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 0
            return formatter
        }()
        let locationManager = LocationManager.shared
        var showErrorAlert = false
        let settingsViewModel = SettingsView.ViewModel.shared
        var weatherInfo: WeatherInfo?
//        var imageCache = WeatherImageCache(maxElements: 10)
        var isLoading = false
        
        init() {
            let center = NotificationCenter.default
            center.addObserver(self,
                               selector: #selector(fetchWeatherInfo),
                               name: Notification.Name("Fetch WeatherInfo"),
                               object: nil)
            Task {
                try await loadWeather()
            }
        }
        
        deinit
        {
            let center = NotificationCenter.default
            center.removeObserver(self,
                                  name:NSNotification.Name(rawValue: "Fetch WeatherInfo"),
                                  object: String.self)
        }
        
        func getWindDirectionImage(_ degrees: Int) -> Image {
            switch degrees {
            case 0..<22:
                return Image(systemName: "arrow.down")
            case 22..<67:
                return Image(systemName: "arrow.down.left")
            case 67..<112:
                return Image(systemName: "arrow.left")
            case 112..<157:
                return Image(systemName: "arrow.up.left")
            case 157..<202:
                return Image(systemName: "arrow.up")
            case 202..<247:
                return Image(systemName: "arrow.up.right")
            case 247..<292:
                return Image(systemName: "arrow.right")
            case 292..<337:
                return Image(systemName: "arrow.down.right")
            case 337..<360:
                return Image(systemName: "arrow.down")
            default:
                return Image(systemName: "arrow.down")
            }
        }
        
        @objc func fetchWeatherInfo(notification: Notification) {
            Task {
                do {
                    weatherInfo = try await ApiService.fetch(from: notification.object as! String)
                } catch {
                    showErrorAlert = true
                }
            }
        }
        
        func loadWeather() async throws {
            isLoading = true
            if let location = locationManager.manager.location {
                locationManager.setWeatherQueryFromReverseGeoLocation(location: location)
            }
            isLoading = false
        }
    }
}
