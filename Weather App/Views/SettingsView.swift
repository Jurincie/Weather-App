//
//  SettingsView.swift
//  Weather App
//
//  Created by Ron Jurincie on 9/19/24.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.horizontalSizeClass) var horizontal
    @Environment(AppCoordinator.self) var appCoordinator
    var viewModel = SettingsViewModel.shared
    
    var body: some View {
        ZStack {
            Color.secondary
            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 4) {
                    Toggle("Temperature (°C/°F)" , isOn: Bindable(viewModel).isCelcius)
                    Text(viewModel.isCelcius ? "°C" : "°F")
                }
                HStack(spacing: 4) {
                    Toggle("Wind Speed (KPH/MPH)", isOn: Bindable(viewModel).isMetric)
                    Text(viewModel.isMetric ? "KPH" : "MPH")
                }
                .navigationTitle("Settings")
            }
            .background(.yellow)
            // HACK: To get the navigation to work wih MVVM-C
            // using the navigationBarBackButton prevented popping this View
            // causing multiple SettingsViews to accumulate in Coordinator Path
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action : {
                appCoordinator.pop()
            }){
                Image(systemName: "arrow.left")
                    .foregroundColor(Color.primary)
            })
            .frame(maxWidth: horizontal == .compact ? 350 : 450)
            .font(.headline)
            .bold()
            .padding()
            .border(.primary, width: 2)
            .padding()
        }
    }
}

#Preview {
    SettingsView()
}
