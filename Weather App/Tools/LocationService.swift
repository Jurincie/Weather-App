//
//  LocationService.swift
//  Weather App
//
//  Created by Ron Jurincie on 9/23/24.
//

import Foundation
import Combine
import MapKit

class LocationService: NSObject, ObservableObject {
    enum LocationStatus: Equatable {
        case idle
        case noResults
        case isSearching
        case error(String)
        case result
    }
    
    @Published var queryFragment: String = ""
    @Published private(set) var status: LocationStatus = .idle
    @Published private(set) var searchResults: [MKLocalSearchCompletion] = []
    private var queryCancellable: AnyCancellable?
    private let searchCompleter: MKLocalSearchCompleter!
    
    init(searchCompleter: MKLocalSearchCompleter = MKLocalSearchCompleter()) {
        self.searchCompleter = searchCompleter
        self.searchCompleter.region = MKCoordinateRegion(.world)
        self.searchCompleter.resultTypes = MKLocalSearchCompleter.ResultType([.address])
        super.init()
        self.searchCompleter.delegate = self
        
        queryCancellable = $queryFragment
            .receive(on: DispatchQueue.main)
            .debounce(for: .milliseconds(250), scheduler: RunLoop.main, options: nil)
            .sink(receiveValue: { fragment in
                self.status = .isSearching
                if !fragment.isEmpty {
                    self.searchCompleter.queryFragment = fragment
                } else {
                    self.status = .idle
                    self.searchResults = []
                }
        })
    }
}

extension LocationService: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.searchResults = completer.results.filter({ $0.title.contains(",") })
        self.status = completer.results.isEmpty ? .noResults : .result
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        self.status = .error(error.localizedDescription)
    }
}
