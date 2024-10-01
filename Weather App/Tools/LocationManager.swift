//
//  LocationManager 2.swift
//  Weather App
//
//  Created by Ron Jurincie on 9/19/24.
//

import CoreLocation

class LocationManager {
    let weatherIconQueryPrefix = "https://openweathermap.org/img/wn/"
    let weatherIconQuerySuffix = "@2x.png"
    let weatherApi_KEY = "b3660824db9ee07a39128f01914989bc"
    let weatherQueryPrefix = "https://api.openweathermap.org/data/2.5/weather?q="
    var weatherQueryPiece = "&appid="
    private let geocoder = CLGeocoder()
    let manager = CLLocationManager()
    var location: CLLocation?
    var weatherQueryString = "" {
        didSet {
            UserDefaults.standard.setValue(weatherQueryString, forKey: "LastQueryString")
            let center = NotificationCenter.default
            center.post(name: Notification.Name("Fetch WeatherInfo"),
                        object: weatherQueryString)
        }
    }
    static var shared = LocationManager() // Singleton
    
    init() {
        requestLocationPermission()
        self.manager.startUpdatingLocation()
        getCurrentLocation()
    }
    
    func requestLocationPermission() {
        manager.requestWhenInUseAuthorization()
    }
    
    func getCurrentLocation() {
        location = manager.location
        print(location.debugDescription)
    }

    func setWeatherQueryFromReverseGeoLocation(location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location,
                                        completionHandler: { [weak self] (placemarks, error) -> Void in
            guard let self = self else { return }
            guard let placemark = placemarks?.first,
                  placemark.locality != nil else { return }
            weatherQueryString = weatherQueryPrefix  + placemark.locality! + weatherQueryPiece + weatherApi_KEY
        })
    }
}
