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
    let viewModel = ViewModel()
    
    var body: some View {
        ZStack {
            Color.blue
            VStack(alignment: .leading) {
                if viewModel.loading {
                    ProgressView()
                } else {
                    NavigationStack {
                        VStack(alignment: .leading) {
                            Text(Date.now, format: .dateTime.day().month().year().hour().minute())
                                .font(.caption)
                            
                            HStack {
                                Text(String(viewModel.weatherInfo?.name ?? ""))
                                    .font(.largeTitle)
                                Spacer()
                                if viewModel.weatherInfo?.main?.temp != nil {
                                    let temperature = viewModel.settingsViewModel.isCelcius ? kelvinToCelcius((viewModel.weatherInfo?.main?.temp)!) : kelvinToFahrenheit(
                                        (viewModel.weatherInfo?.main?.temp)!
                                    )
                                    if let str = viewModel.formatter.string(
                                        for: temperature
                                    ) {
                                        Text(str)
                                            .font(.largeTitle)
                                        Text(
                                            viewModel.settingsViewModel.isCelcius ? "°C" : "°F"
                                        )
                                        .font(.largeTitle)
                                    }
                                }
                            }
                        }
                        Spacer()
                        WeatherView(viewModel: viewModel)
                        Spacer()
                    }
                    .navigationTitle("Weather")
                    .padding()
                }
            }
            .sheet(isPresented: $showSearchSheet) {
                CitySearchView(locationService: LocationService(),
                               viewModel: viewModel)
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
                   isPresented: Bindable(viewModel).showErrorAlert) {
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
