//
//  GeoLocationReceiver.swift
//  Weather
//
//  Created by Mikhail Zhigulin on 13.12.2021.
//

import CoreLocation

// MARK: - Subscribe to be notified as location data received

extension Notification.Name
{
    static let locationReceivedNotification = Notification.Name("locationReceivedNotification")
}

// MARK: - Failure scenario details

enum LocationReceivedError : Error
{
    case receivedEmptyLocationData
    case failedRequest(String)
}

// MARK: - Success scenario details

struct LocationReceived
{
    let latitude : Double
    let longitude: Double
}

// MARK: - GeoLocationReceiver used via Singletone

class GeoLocationReceiver: NSObject
{
    private let APPROPRIATE_ACCURACY = kCLLocationAccuracyThreeKilometers
    private let locationManager = CLLocationManager()
    
    // MARK: - Singletone access and constructor
    
    static var shared: GeoLocationReceiver =
    {
        let instance = GeoLocationReceiver()
        
        // Do any additional setup if needed.
        
        return instance
    }()
    
    private override init()
    {
        super.init()
        
        // Do setup.
        
        locationManager.desiredAccuracy = APPROPRIATE_ACCURACY
        locationManager.delegate = self
    }
    
    // MARK: - Public communication interface
    
    func requestLocationDataAccess()
    {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func requestLocationUpdateOnce(_ actionIfDenied: (()-> Void)? = nil)
    {
        let status = CLLocationManager.authorizationStatus()
        
        if status == .denied, let takeActionIfDenied = actionIfDenied
        {
            takeActionIfDenied()
            return
        }
        
        locationManager.requestLocation()
    }
}

// MARK: - CLLocationManagerDelegate methods implementation

extension GeoLocationReceiver : CLLocationManagerDelegate
{
    /// Notify received location data
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        guard let value: CLLocationCoordinate2D = manager.location?.coordinate
        else
        {
            let result: Result<LocationReceived, LocationReceivedError> =
                .failure(.receivedEmptyLocationData)
            
            NotificationCenter.default.post(name: .locationReceivedNotification, object: result)
            return
        }
        
        let result: Result<LocationReceived, LocationReceivedError> =
            .success(LocationReceived(latitude: value.latitude, longitude: value.longitude))
        
        NotificationCenter.default.post(name: .locationReceivedNotification, object: result)
        
        locationManager.stopUpdatingLocation()
    }
    
    /// Notify reported receiving location data error
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        let result: Result<LocationReceived, LocationReceivedError> =
            .failure(.failedRequest(error.localizedDescription))
        
        NotificationCenter.default.post(name: .locationReceivedNotification, object: result)
    }
    
    /// Request location update if status either changed to authorizedWhenInUse or authorizedAlways
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization
                            status: CLAuthorizationStatus)
    {
        if(status == .authorizedWhenInUse || status == .authorizedAlways)
        {
            manager.requestLocation()
        }
    }
}
