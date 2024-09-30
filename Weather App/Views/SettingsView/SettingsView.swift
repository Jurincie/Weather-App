//
//  SettingsView.swift
//  Weather App
//
//  Created by Ron Jurincie on 9/19/24.
//

import SwiftUI


struct SettingsView: View {
    @Environment(\.sizeCategory) var sizeCategory
    var viewModel = ViewModel.shared
    
    var body: some View {
        ZStack {
            // background
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 10) {
                    Image(systemName: "thermometer")
                    Toggle("(°C/°F)" , isOn: Bindable(viewModel).isCelsius)
                        .onChange(of: viewModel.isCelsius) { oldValue, newValue in
                        UserDefaults.standard.setValue(viewModel.isCelsius, forKey: "IsCelsius")
                    }
                    Text(viewModel.isCelsius ? "°C" : "°F")
                }
                .padding()
                
                HStack(spacing: 10) {
                    Image(systemName: "wind")
                    Toggle("(KPH/MPH)", isOn: Bindable(viewModel).isMetric)
                        .onChange(of: viewModel.isMetric) { oldValue, newValue in
                        UserDefaults.standard.setValue(viewModel.isMetric, forKey: "IsMetric")
                    }
                    Text(viewModel.isMetric ? "KPH" : "MPH")
                }
                .padding()
                .navigationTitle("Settings")
            }
            .font(.headline)
            .minimumScaleFactor(sizeCategory.customMinScaleFactor)
            .background(.blue)
            .foregroundStyle(.white)
            .padding()
            .border(.secondary, width: 2)
            .navigationBarTitleDisplayMode(.inline)
        }
        .background(Color.primary)
        // given time limit this is a viable solution
        .dynamicTypeSize(...DynamicTypeSize.accessibility1)
    }
}

#Preview {
    SettingsView()
}
