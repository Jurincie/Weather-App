//
//  ContentView.swift
//  Weather App
//
//  Created by Ron Jurincie on 9/19/24.
//

import SwiftUI

struct MainView: View {
    @Environment(AppCoordinator.self) var appCoordinator
    @State var locationSearchService: LocationSearchService
    @State var showSearchSheet = false
    let mainViewModel = ViewModel()
    
    var body: some View {
        ZStack {
            Color.blue
            VStack(alignment: .leading) {
                if mainViewModel.loading {
                    ProgressView()
                } else {
                    NavigationStack {
                        VStack(alignment: .leading) {
                            Text(Date.now, format: .dateTime.day().month().year().hour().minute())
                                .font(.caption)
                            
                            HStack {
                                Text(String(mainViewModel.weatherInfo?.name ?? ""))
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
                                        Text(
                                            mainViewModel.settingsViewModel.isCelcius ? "°C" : "°F"
                                        )
                                        .font(.largeTitle)
                                    }
                                }
                            }
                        }
                        Spacer()
                        WeatherView(mainViewModel: mainViewModel)
                        Spacer()
                    }
                    .navigationTitle("Weather")
                    .padding()
                }
            }
            .sheet(isPresented: $showSearchSheet) {
                CitySearchView(locationService: LocationService(),
                               viewModel: mainViewModel)
                .presentationBackground(.thinMaterial)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        appCoordinator.push(.settingsView)
                    }) {
                        Text("Settings")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showSearchSheet = true
                    } label: {
                        HStack {
                            Image(systemName: "magnifyingglass")
                            Text("Search")
                        }
                    }
                }
            }
            .alert("API Error",
                   isPresented: Bindable(mainViewModel).showErrorAlert) {
                Button("OK", role: .cancel) {
                    fatalError()
                }
            }
        }
    }
}


#Preview {
    MainView(locationSearchService: LocationSearchService())
}
