//
//  NSNumberFormatter+currencyExtension.swift
//  Weather App
//
//  Created by Ron Jurincie on 9/19/24.
//

import Foundation

extension NumberFormatter {
    static var currency: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }
}
