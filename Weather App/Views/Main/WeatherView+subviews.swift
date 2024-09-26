//
//  WeatherView.swift
//  Weather App
//
//  Created by Ron Jurincie on 9/22/24.
//

import SwiftUI

struct WeatherView: View {
    @Environment(\.sizeCategory) var sizeCategory
    var ViewModel: MainView.ViewModel
    
    var body: some View {
        VStack {
            ViewThatFits {
                VStack {
                    Text(String(ViewModel.weatherInfo?.name ?? ""))
                        .foregroundStyle(.white)
                        .font(.largeTitle)
                    Text("Current Conditions")
                        .font(.title)
                }
                VStack {
                    Text(String(ViewModel.weatherInfo?.name ?? ""))
                        .font(.headline)
                    Text("Current Conditions")
                        .font(.caption)
                }
            }
            .foregroundStyle(.white)
            VStack(alignment: .leading) {
                TemperatureView(mainViewModel: ViewModel)
                ImageView(mainViewModel: ViewModel)
                    .padding(.bottom)
                WindView(mainViewModel: ViewModel)
                HumidityView(mainViewModel: ViewModel)
                PressureView(mainViewModel: ViewModel)
            }
            .minimumScaleFactor(sizeCategory.customMinScaleFactor)
            .foregroundStyle(.white)
            .padding()
            .border(.primary, width: 1)
        }
    }
}

#Preview {
    WeatherView(ViewModel: MainView.ViewModel())
}

struct ImageView: View {
    var mainViewModel: MainView.ViewModel
    
    var body: some View {
        HStack {
            Spacer()
            if let iconName = mainViewModel.weatherInfo?.weather?[0].icon {
                let queryString = mainViewModel.locationManager.weatherIconQueryPrefix + iconName + mainViewModel.locationManager.weatherIconQuerySuffix
                if let url = URL(string: queryString) {
                    ZStack {
                        AsyncCachedImage(url: url) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            ActivityIndicator()
                        }
                        .font(.title)
                        
                        AsyncCachedImage(url: url) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .font(.headline)
                        } placeholder: {
                            ActivityIndicator()
                        }
                        .overlay(
                            Text(mainViewModel.weatherInfo?.weather?[0].description ?? "")
                                .foregroundColor(.white)
                                .font(.title)
                                .padding()
                                .background(Color.clear), alignment: .bottom)
                    }
                }
            }
            Spacer()
        }
    }
}

struct TemperatureView: View {
    var mainViewModel: MainView.ViewModel
    
    var body: some View {
        if let temp = mainViewModel.weatherInfo?.main?.temp {
            if let iconName = mainViewModel.weatherInfo?.weather?[0].icon {
                let temperature = mainViewModel.settingsViewModel.isCelcius ? kelvinToCelcius(temp) : kelvinToFahrenheit(temp)
                if let str = mainViewModel.formatter.string(for: temperature) {
                    HStack {
                        Spacer()
                        Text(str)
                        Text(mainViewModel.settingsViewModel.isCelcius ? "°C" : "°F")
                    }
                    .font(.title)
                    .foregroundStyle(.white)
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
                .font(.title)
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
            .font(.title)
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
            .font(.title)
            .accessibilityElement(children: .combine)
        }
    }
}
