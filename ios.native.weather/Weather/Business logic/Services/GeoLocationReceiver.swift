//
//  GeoLocationReceiver.swift
//  Weather
//
//  Created by Mikhail Zhigulin on 13.12.2021.
//

import CoreLocation

// MARK: - Subscribe to be notified about location data as soon as received

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

extension LocationReceivedError: Equatable {}

func ==(lhs: LocationReceivedError, rhs: LocationReceivedError) -> Bool
{
    switch (lhs, rhs)
    {
    case (.receivedEmptyLocationData, .receivedEmptyLocationData):
        return true
        
    case (let .failedRequest(str1), let .failedRequest(str2)):
        return str1 == str2
        
    default:
        return false
    }
}

// MARK: - Success scenario details

struct LocationReceived
{
    let latitude : Double
    let longitude: Double
}

extension LocationReceived: Equatable {}

func == (lhs: LocationReceived, rhs: LocationReceived) -> Bool
{
    lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
}

// MARK: - Helper abstracts used to make code testable

protocol LocationManagerProtocol
{
    var delegate       : CLLocationManagerDelegate? { get set }
    var desiredAccuracy: CLLocationAccuracy { get set }
    
    func requestWhenInUseAuthorization()
    func requestLocation()
    func stopUpdatingLocation()
    
    static func authorizationStatus() -> CLAuthorizationStatus
}

extension CLLocationManager : LocationManagerProtocol { }

// MARK: - GeoLocationReceiver used via Singletone

class GeoLocationReceiver: NSObject
{
    private let APPROPRIATE_ACCURACY = kCLLocationAccuracyThreeKilometers
    
    #if DEBUG // locationManager is a difficutlt dependency so that it should be isolated
    var locationManager        : LocationManagerProtocol // Isolated for unit testing
    #else
    private var locationManager: CLLocationManager
    #endif
    
    // MARK: - Singletone access and constructor
    
    static let shared: GeoLocationReceiver =
    {
        let instance = GeoLocationReceiver()
        
        // Do any additional setup if needed.
        
        return instance
    }()
    
    private override init()
    {
        self.locationManager = CLLocationManager()
        
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
        let status = type(of: locationManager).authorizationStatus()
        
        if status == .denied, let takeActionIfDenied = actionIfDenied
        {
            takeActionIfDenied()
            return
        }
        
        locationManager.requestLocation()
    }
}

// MARK: - CLLocationManagerDelegate methods

extension GeoLocationReceiver : CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        guard let value = locations.first?.coordinate
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
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        let result: Result<LocationReceived, LocationReceivedError> =
            .failure(.failedRequest(error.localizedDescription))
        
        NotificationCenter.default.post(name: .locationReceivedNotification, object: result)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization
                            status: CLAuthorizationStatus)
    {
        if(status == .authorizedWhenInUse || status == .authorizedAlways)
        {
            locationManager.requestLocation()
        }
    }
}
