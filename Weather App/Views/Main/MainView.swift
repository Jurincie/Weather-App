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
                    ProgressView()
                } else {
                    NavigationStack {
                        WeatherView(mainViewModel: mainViewModel)
                        Spacer()
                        ViewThatFits() {
                            Text(Date.now, format: .dateTime.day().month().year().hour().minute())
                                .font(.caption)
                                .foregroundStyle(.white)
                                .padding(.bottom, 10)
                            
                            Text(Date.now.formatted(date: .abbreviated, time: .omitted))
                        }
                        
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
            .minimumScaleFactor(sizeCategory.customMinScaleFactor)
            .alert("API Error",
                   isPresented: Bindable(mainViewModel).showErrorAlert) {
                Button("OK", role: .cancel) {
                    fatalError()
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color.blue.opacity(0.9))
            // given time limit this is a viable solution
            .dynamicTypeSize(...DynamicTypeSize.accessibility1)
        }
    }
}


#Preview {
    MainView()
}
