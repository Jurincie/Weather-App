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
        let formatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 0
            return formatter
        }()
        let locationManager = LocationManager.shared
        var showErrorAlert = false
        let settingsViewModel = SettingsViewModel.shared
        var weatherInfo: WeatherInfo?
        var imageCache = AsyncImageCache(maxElements: 10)
        var loading = false
        
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
          NotificationCenter.default.removeObserver(self,
                                                    name:NSNotification.Name(rawValue: "Fetch WeatherInfo"),
                                                    object: String.self)

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
            loading = true
            if let location = locationManager.manager.location {
                locationManager.setWeatherQueryFromReverseGeoLocation(location: location)
            }
            loading = false
        }
    }
}
