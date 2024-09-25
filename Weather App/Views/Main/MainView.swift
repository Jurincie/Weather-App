//
//  ContentView.swift
//  Weather App
//
//  Created by Ron Jurincie on 9/19/24.
//

import SwiftUI

struct MainView: View {
    @State var showSearchSheet = false
    let mainViewModel = ViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                if mainViewModel.isLoading {
                    ProgressView()
                } else {
                    NavigationStack {
                        WeatherView(mainViewModel: mainViewModel)
                        Spacer()
                        Text(Date.now, format: .dateTime.day().month().year().hour().minute())
                            .font(.caption)
                            .foregroundStyle(.white)
                            .padding(.bottom, 10)
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
            .presentationDetents([.medium])
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink{
                        NavigationCoordinator.shared.getSettingsView()
                    } label: {
                        Text("Settings")
                            .foregroundStyle(.white)
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
                        .foregroundStyle(.white)
                    }
                }
            }
            .alert("API Error",
                   isPresented: Bindable(mainViewModel).showErrorAlert) {
                Button("OK", role: .cancel) {
                    fatalError()
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color.blue.opacity(0.9))
        }
    }
}


#Preview {
    MainView()
}
