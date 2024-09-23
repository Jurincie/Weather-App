//
//  PracticeView.swift
//  Weather App
//
//  Created by Ron Jurincie on 9/21/24.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.dismiss) var dismiss
    var viewmodel: MainView.ViewModel
    @ObservedObject var locationSearchService: LocationSearchService

    var body: some View {
        NavigationStack {
            VStack {
                Text("SEARCH")
                SearchBar(text: $locationSearchService.searchQuery)
                List(locationSearchService.completions) { completion in
                    if completion.title.contains(",") {
                        VStack(alignment: .leading) {
                            VStack {
                                Text(completion.title)
                            }
                            .onTapGesture {
                                if let index = completion.title.firstIndex(where: { char in
                                    char == ","
                                }) {
                                    let city = completion.title.prefix(upTo: index)
                                    let query = viewmodel.locationManager.weatherQueryPrefix + city + "&appid=" + viewmodel.locationManager.weatherApi_KEY
                                    
                                    viewmodel.locationManager.weatherQueryString = query
                                    dismiss()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
