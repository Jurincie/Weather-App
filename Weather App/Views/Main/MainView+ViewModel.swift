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
        let center = NotificationCenter.default
        
        init() {
            center.addObserver(self,
                               selector: #selector(fetchWeatherInfo),
                               name: Notification.Name("Fetch WeatherInfo"),
                               object: nil)
        }
        
        deinit
        {
            center.removeObserver(self,
                                  name:NSNotification.Name(rawValue: "Fetch WeatherInfo"),
                                  object: String.self)
        }
        
        func getWindDirectionText(_ degrees: Int) -> String {
            switch degrees {
            case 22..<67:
                return "SouthWest"
            case 67..<112:
                return "West"
            case 112..<157:
                return "NorthWest"
            case 157..<202:
                return "North"
            case 202..<247:
                return "NorthEast"
            case 247..<292:
                return "East"
            case 292..<337:
                return "SouthEast"
            default:
                return "South"
            }
        }
        
        @objc func fetchWeatherInfo(notification: Notification) {
            Task {
                do {
                    let str = notification.object as! String
                    weatherInfo = try await ApiService.fetch(from:str)
                    print("xx")
                } catch {
                    showErrorAlert = true
                }
            }
        }
    }
}
