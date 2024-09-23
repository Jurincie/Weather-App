//
//  CitySearchView.swift
//  Weather App
//
//  Created by Ron Jurincie on 9/23/24.
//

import MapKit
import SwiftUI

struct CitySearchView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var locationService: LocationService
    var viewModel: MainView.ViewModel
    
    private func getQueryString(completionResult: MKLocalSearchCompletion) -> String {
        var query = viewModel.locationManager.weatherQueryPrefix + completionResult.title.replacingOccurrences(of: " ", with: "")
        
        if completionResult.subtitle != "" {
            query += "," + completionResult.subtitle.replacingOccurrences(of: " ", with: "")
        }
        query += viewModel.locationManager.weatherQueryPiece + viewModel.locationManager.weatherApi_KEY
        
        return query
    }
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Location Search")) {
                    ZStack(alignment: .trailing) {
                        TextField("Search", text: $locationService.queryFragment)
                        // This is optional and simply displays an icon during an active search
                        if locationService.status == .isSearching {
                            Image(systemName: "clock")
                                .foregroundColor(Color.gray)
                        }
                    }
                }
                Section(header: Text("Results")) {
                    List {
                        Group { () -> AnyView in
                            switch locationService.status {
                            case .noResults: return AnyView(Text("No Results"))
                            case .error(let description): return AnyView(Text("Error: \(description)"))
                            default: return AnyView(EmptyView())
                            }
                        }.foregroundColor(Color.gray)
                        
                        ForEach(locationService.searchResults, id: \.self) { completionResult in
                            VStack {
                                Text(completionResult.title)
                                Text(completionResult.subtitle)
                            }
                            .onTapGesture {
                                defer {
                                    viewModel.locationManager.weatherQueryString = getQueryString(completionResult: completionResult)
                                }
                                dismiss()
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    CitySearchView(locationService: LocationService(),
                   viewModel: MainView.ViewModel())
}
