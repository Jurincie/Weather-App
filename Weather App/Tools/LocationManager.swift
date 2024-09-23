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
    let geocoder = CLGeocoder()
    let manager = CLLocationManager()
    var location: CLLocation?
    var weatherQueryString = "" {
        didSet {
                let center = NotificationCenter.default
                center.post(name: Notification.Name("Fetch WeatherInfo"),
                            object: weatherQueryString)
            }
        }
    
    // Singleton
    static var shared = LocationManager()
    
    init() {
        requestLocationPermission()
        getCurrentLocation()
    }
    
    func requestLocationPermission() {
        manager.requestWhenInUseAuthorization()
    }
    
    func getCurrentLocation() {
        manager.startUpdatingLocation()
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
            weatherQueryString = weatherQueryPrefix  + placemark.locality! + "&appid=" + weatherApi_KEY
        })
    }
}
