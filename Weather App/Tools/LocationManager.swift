//
//  LocationManager 2.swift
//  Weather App
//
//  Created by Ron Jurincie on 9/19/24.
//

import CoreLocation

class LocationManager: NSObject {
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
    
    override init() {
        super.init()
        self.manager.delegate = self
        self.manager.requestWhenInUseAuthorization()
    }

    func getCurrentLocation() {
        location = manager.location
        print(location.debugDescription)
    }
    
    /// This method should only be called on initial launch
    /// This method calls setWeatherQueryFromReverseGeoLocation
    /// Since the location might not be available it waits via repeat loop with sleep(1)
    ///
    func loadWeather() async throws {
        if (UserDefaults.standard.string(forKey: "LastQueryString") != nil) {
            weatherQueryString = UserDefaults.standard.string(forKey: "LastQueryString")!
        } else {
            getCurrentLocation()
            if let location = manager.location {
                setWeatherQueryFromReverseGeoLocation(location: location)
            }
        }
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

extension LocationManager: CLLocationManagerDelegate  {
    @objc(locationManager:didChangeAuthorizationStatus:) func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
           fallthrough
        case .authorizedAlways:
            manager.startUpdatingLocation()
            Task {
                try? await loadWeather()
            }
        case .denied:
            print("Location access denied")
        default:
            break
        }
    }
}
