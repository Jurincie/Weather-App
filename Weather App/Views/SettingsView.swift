//
//  SettingsView.swift
//  Weather App
//
//  Created by Ron Jurincie on 9/19/24.
//

import SwiftUI


struct SettingsView: View {
    @Environment(\.sizeCategory) var sizeCategory
    @Environment(AppCoordinator.self) var appCoordinator
    var viewModel = ViewModel.shared
    
    var body: some View {
        ZStack {
            Color.gray.edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 10) {
                    Image(systemName: "thermometer")
                    Toggle("(°C/°F)" , isOn: Bindable(viewModel).isCelcius)
                    Text(viewModel.isCelcius ? "°C" : "°F")
                }
                .padding()
                
                HStack(spacing: 10) {
                    Image(systemName: "wind")
                    Toggle("(KPH/MPH)", isOn: Bindable(viewModel).isMetric)
                    Text(viewModel.isMetric ? "KPH" : "MPH")
                }
                .padding()
                .navigationTitle("Settings")
            }
            .font(.headline)
            .minimumScaleFactor(sizeCategory.customMinScaleFactor)
            .background(.blue)
            .foregroundStyle(.white)
            
            // This two lines of code allows the navigation BACK to work wih MVVM-C
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action : {
                appCoordinator.pop()
            }){
                Image(systemName: "arrow.left")
                    .foregroundColor(Color.white)
            })
            .font(.headline)
            .padding()
            .border(.primary, width: 2)
            .padding()
        }
        .dynamicTypeSize(...DynamicTypeSize.accessibility2)
    }
}

#Preview {
    SettingsView()
}
