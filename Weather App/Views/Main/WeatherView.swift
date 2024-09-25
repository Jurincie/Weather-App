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
        if let temp = mainViewModel.weatherInfo?.main?.temp {
            if let iconName = mainViewModel.weatherInfo?.weather?[0].icon {
                let temperature = mainViewModel.settingsViewModel.isCelcius ? kelvinToCelcius(temp) : kelvinToFahrenheit(temp)
                if let str = mainViewModel.formatter.string(for: temperature) {
                    let queryString = mainViewModel.locationManager.weatherIconQueryPrefix + iconName + mainViewModel.locationManager.weatherIconQuerySuffix
                    let url = URL(string: queryString)!
                    HStack {
                        AsyncCachedImage(url: url) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            ProgressView()
                        }
                        Spacer()
                        Text(str)
                            .font(.largeTitle)
                            .foregroundStyle(.white)
                        Text(mainViewModel.settingsViewModel.isCelcius ? "°C" : "°F")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                    }
                    .accessibilityElement(children: .combine)
                }
            }
        }
    }
}

struct WindView: View {
    var mainViewModel: MainView.ViewModel
    var body: some View {
        if mainViewModel.weatherInfo?.wind?.speed != nil,
           let windSpeed = mainViewModel.weatherInfo?.wind?.speed {
            let adjustedWindSpeed =  mainViewModel.settingsViewModel.isMetric ? metersPerSecondToKph(windSpeed) : metersPerSecondToMph(windSpeed)
            if let str = mainViewModel.formatter.string(for: adjustedWindSpeed) {
                HStack {
                    Image(systemName: "wind")
                    Text(str)
                    Text(mainViewModel.settingsViewModel.isMetric ? "KPH" : "MPH")
                    if let degrees = mainViewModel.weatherInfo?.wind?.deg {
                        mainViewModel.getWindDirectionImage(degrees)
                    }
                }
                .accessibilityElement(children: .combine)
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
            .accessibilityElement(children: .combine)
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
            .accessibilityElement(children: .combine)
        }
    }
}
