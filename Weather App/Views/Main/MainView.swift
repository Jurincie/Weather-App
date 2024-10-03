//
//  ContentView.swift
//  Weather App
//
//  Created by Ron Jurincie on 9/19/24.
//

import SwiftUI

struct MainView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.sizeCategory) var sizeCategory
    @State private var showSearchSheet = false
    @State private var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                if viewModel.isLoading {
                    ActivityIndicator()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    NavigationStack {
                        WeatherView(viewModel: $viewModel)
                    }
                    .navigationTitle("Weather")
                    .padding()
                }
            }
            // update weatherInfo for current location when returning to foreground
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                viewModel.locationManager.weatherQueryString = viewModel.locationManager.weatherQueryString
            }
            .sheet(isPresented: $showSearchSheet) {
                CitySearchView(locationService: LocationService(),
                               viewModel: viewModel)
                .presentationBackground(.thinMaterial)
            }
            .presentationDetents([.medium])
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showSearchSheet = true
                    } label: {
                        HStack {
                            Image(systemName: "magnifyingglass")
                            Text("Search")
                        }
                        .foregroundStyle(.white)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                     Button {
                         Task {
                             viewModel.locationManager.weatherQueryString = viewModel.locationManager.weatherQueryString
                         }
                    } label: {
                        Image(systemName: "arrow.clockwise.square")
                            .foregroundStyle(.white)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink{
                        NavigationCoordinator.shared.getSettingsView()
                    } label: {
                        Image(systemName: "gear.circle")
                            .foregroundStyle(.white)
                    }
                }
            }
            .minimumScaleFactor(sizeCategory.customMinScaleFactor)
            .alert("Could not fetch weather for chosen location.",
                   isPresented: $viewModel.showErrorAlert) {
                Button("OK", role: .cancel) {
                    dismiss()
                }
            }
            // given time limit line below is a viable solution
            .dynamicTypeSize(...DynamicTypeSize.accessibility1)
            .frame(maxWidth: .infinity)
            .background(Color.blue.opacity(0.9))
        }
    }
}


#Preview {
    MainView()
}
