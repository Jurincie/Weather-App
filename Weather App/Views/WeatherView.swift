//
//  WeatherView.swift
//  Weather App
//
//  Created by Ron Jurincie on 9/22/24.
//

import SwiftUI

struct WeatherView: View {
    @Environment(\.sizeCategory) var sizeCategory
    var mainViewModel: MainView.ViewModel
    
    var body: some View {
        VStack {
            Text(String(mainViewModel.weatherInfo?.name ?? ""))
                .font(.largeTitle)
                .foregroundStyle(.white)
            Text("Current Conditions")
                .font(.headline)
                .foregroundStyle(.white)
            VStack(alignment: .leading) {
                ImageView(mainViewModel: mainViewModel)
                    .padding(.horizontal, 10)
                WindView(mainViewModel: mainViewModel)
                HumidityView(mainViewModel: mainViewModel)
                PressureView(mainViewModel: mainViewModel)
            }
            .minimumScaleFactor(sizeCategory.customMinScaleFactor)
            .font(.subheadline)
            .foregroundStyle(.white)
            .padding()
            .border(.primary, width: 1)
        }
    }
}

#Preview {
    WeatherView(mainViewModel: MainView.ViewModel())
}

struct ImageView: View {
    var mainViewModel: MainView.ViewModel
    
    var body: some View {
        HStack {
            if let iconName = mainViewModel.weatherInfo?.weather?[0].icon {
                HStack {
                    let queryString = mainViewModel.locationManager.weatherIconQueryPrefix + iconName + mainViewModel.locationManager.weatherIconQuerySuffix
                    AsyncImage(url: URL(string: queryString))
                        .scaledToFit()
                        .font(.largeTitle)
                    Spacer()
                    if mainViewModel.weatherInfo?.main?.temp != nil {
                        let temperature = mainViewModel.settingsViewModel.isCelcius ? kelvinToCelcius((mainViewModel.weatherInfo?.main?.temp)!) : kelvinToFahrenheit(
                            (mainViewModel.weatherInfo?.main?.temp)!
                        )
                        if let str = mainViewModel.formatter.string(
                            for: temperature
                        ) {
                            Text(str)
                                .font(.largeTitle)
                                .foregroundStyle(.white)
                            Text(
                                mainViewModel.settingsViewModel.isCelcius ? "°C" : "°F"
                            )
                            .font(.largeTitle)
                            .foregroundStyle(.white)
                        }
                    }
                }
            }
        }
    }
}

struct WindView: View {
    var mainViewModel: MainView.ViewModel
    var body: some View {
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
    }
}

struct HumidityView: View {
    var mainViewModel: MainView.ViewModel
    var body: some View {
        if mainViewModel.weatherInfo?.main?.humidity != nil {
            HStack {
                Image(systemName: "humidity")
                Text("Humidity:")
                Text("\(mainViewModel.weatherInfo?.main?.humidity ?? 0)°")
            }
        }
    }
}

struct PressureView: View {
    var mainViewModel: MainView.ViewModel
    var body: some View {
        if mainViewModel.weatherInfo?.main?.pressure != nil {
            HStack {
                Image(systemName: "barometer")
                Text("Pressure:")
                Text("\(mainViewModel.weatherInfo?.main?.pressure ?? 0) mb")
            }
        }
    }
}
