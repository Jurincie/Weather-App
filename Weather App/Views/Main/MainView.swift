//
//  ContentView.swift
//  Weather App
//
//  Created by Ron Jurincie on 9/19/24.
//

import SwiftUI

struct MainView: View {
    @Environment(\.sizeCategory) var sizeCategory
    @State var showSearchSheet = false
    let mainViewModel = ViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                if mainViewModel.isLoading {
                    ActivityIndicator()
                } else {
                    NavigationStack {
                        WeatherView(ViewModel: mainViewModel)
                        Spacer()
                        ViewThatFits() {
                            Text(Date.now, format: .dateTime.day().month().year().hour().minute())
                                .font(.caption)
                                .font(.largeTitle)
                            
                            Text(Date.now.formatted(date: .abbreviated, time: .omitted))
                                .font(.title)
                        }
                        .foregroundStyle(.white)
                    }
                    .navigationTitle("Weather")
                    .padding()
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                mainViewModel.locationManager.weatherQueryString = mainViewModel.locationManager.weatherQueryString
            }
            .sheet(isPresented: $showSearchSheet) {
                CitySearchView(locationService: LocationService(),
                               viewModel: mainViewModel)
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
                             mainViewModel.locationManager.weatherQueryString = mainViewModel.locationManager.weatherQueryString
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
            .alert("API Error",
                   isPresented: Bindable(mainViewModel).showErrorAlert) {
                Button("OK", role: .cancel) {
                    fatalError()
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
