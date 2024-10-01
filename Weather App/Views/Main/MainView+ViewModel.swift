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
        let settingsViewModel = SettingsView.ViewModel.shared
        var weatherInfo: WeatherInfo?
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
                    let str = notification.object as! String
                    weatherInfo = try await ApiService.fetch(from:str.lowercased())
                } catch {
                    showErrorAlert = true
                }
            }
        }
        
        /// This method should only be called on initial launch
        /// This method calls setWeatherQueryFromReverseGeoLocation
        /// Since the location might not be available it waits via repeat loop with sleep(1)
        /// 
        func loadWeather() async throws {
            isLoading = true
            if (UserDefaults.standard.string(forKey: "LastQueryString") != nil) {
                locationManager.weatherQueryString = UserDefaults.standard.string(forKey: "LastQueryString")!
            } else {
                if locationManager.manager.location == nil {
                    repeat {
                        print("No location yet")
                        sleep(1)
                    } while (locationManager.manager.location == nil)
                }
        
                locationManager.setWeatherQueryFromReverseGeoLocation(location: locationManager.manager.location!)
                isLoading = false

            }
        }
    }
}
