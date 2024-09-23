//
//  WeatherImageCache.swift
//  Weather App
//
//  Created by Ron Jurincie on 9/20/24.
//

import Foundation
import SwiftUI

struct WeatherImage: Identifiable {
    let id: String
    let image: AsyncImage<Image>
    
    init(named id: String, image: AsyncImage<Image>) {
        self.id = id
        self.image = image
    }
}

struct WeatherImageCache {
    let maxElements: Int
    var elements = [WeatherImage]()
    
    init(maxElements: Int) {
        self.maxElements = maxElements
    }
}
