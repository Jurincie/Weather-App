//
//  ContentSizeCatagory+ScaledText.swift
//  Weather App
//
//  Created by Ron Jurincie on 9/24/24.
//

import Foundation
import SwiftUI

extension ContentSizeCategory {
    var customMinScaleFactor: CGFloat {
        switch self {
        case .extraSmall: fallthrough
        case .small: fallthrough
        case .medium: fallthrough
        case .large:  return 1.0
        default: return 0.7
        }
    }
}
