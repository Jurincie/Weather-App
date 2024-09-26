//
//  SettingsViewModel.swift
//  Weather App
//
//  Created by Ron Jurincie on 9/19/24.
//

import Foundation

extension SettingsView {
    @Observable
    class ViewModel {
        static var shared = ViewModel()
        var isMetric: Bool = false
        var isCelsius: Bool = false
        
        init() {
            isMetric = UserDefaults.standard.bool(forKey: "IsMetric")
            isCelsius = UserDefaults.standard.bool(forKey: "IsCelsius")
        }
    }
}


