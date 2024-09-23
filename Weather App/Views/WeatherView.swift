//
//  WeatherView.swift
//  Weather App
//
//  Created by Ron Jurincie on 9/22/24.
//

import SwiftUI

struct WeatherView: View {
    var mainViewModel: MainView.ViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            if let iconName = mainViewModel.weatherInfo?.weather?[0].icon {
                if let index = mainViewModel.imageCache.elements.firstIndex(where: { weatherImageStruct in
                    weatherImageStruct.id == iconName
                }) {
                    // how show image here?
                    mainViewModel.imageCache.elements[index].image as AsyncImage
                } else {
                    // image not in cache
                    let queryString = mainViewModel.locationManager.weatherIconQueryPrefix + iconName + mainViewModel.locationManager.weatherIconQuerySuffix
                    AsyncImage(url: URL(string: queryString))
                        .frame(width: 80, height: 80)
                }
            }
            if mainViewModel.weatherInfo?.wind?.speed != nil {
                HStack {
                    if let windSpeed = mainViewModel.weatherInfo?.wind?.speed {
                        let adjustedWindSpeed =  mainViewModel.settingsViewModel.isMetric ? mpsToKph(windSpeed) : mpsToMph(
                            windSpeed
                        )
                        Image(systemName: "wind")
                        if let str = mainViewModel.formatter.string(
                            for: adjustedWindSpeed
                        ) {
                            Text(str)
                            Text(mainViewModel.settingsViewModel.isMetric ? "KPH" : "MPH")
                        }
                        if let degrees = mainViewModel.weatherInfo?.wind?.deg {
                            mainViewModel.getWindDirectionImage(degrees)
                        }
                    }
                }
            }
            if mainViewModel.weatherInfo?.main?.humidity != nil {
                HStack {
                    Text("Humidity:")
                    Text("\(mainViewModel.weatherInfo?.main?.humidity ?? 0)°")
                }
            }
        }
        .padding()
        .border(.primary, width: 2)
    }
}

#Preview {
    WeatherView(mainViewModel: MainView.ViewModel())
}
