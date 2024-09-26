//
//  ConversionManager.swift
//  Weather App
//
//  Created by Ron Jurincie on 9/20/24.
//

import Foundation

func kelvinToCelsius(_ input: Double) -> Double {
    return input - 273.15
}

func kelvinToFahrenheit(_ input: Double) -> Double {
    (input - 273.15) * 1.8 + 32
}

func metersPerSecondToMph(_ mps: Double) -> Double {
    mps * 3.6 * 0.62
}

func metersPerSecondToKph(_ mps: Double) -> Double {
    mps * 3.6
}
