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

struct Сoordinate : CustomStringConvertible
{
    // Neither rounding nor cutting off, just as is from core location
    let _latitude  : Double
    let _longitude : Double
    
    // Cutting off to hundredths (2 decimal places)
    var latitude   : Double { (_latitude * 100.0).rounded(_latitude > 0 ? .down : .up) / 100.0 }
    var longitude  : Double { (_longitude * 100.0).rounded(_longitude > 0 ? .down : .up) / 100.0 }
    
    init(latitude: Double, longitude: Double)
    {
        _latitude = latitude
        _longitude = longitude
    }
    
    var description : String
    {
        let latitude = (_latitude * 10000.0).rounded(_latitude > 0 ? .down : .up) / 10000.0
        let longitude = (_longitude * 10000.0).rounded(_longitude > 0 ? .down : .up) / 10000.0
        
        return "[\(latitude), \(longitude)]: latitude = \(latitude), longitude = \(longitude)"
    }
}

extension Сoordinate: Equatable {}

func == (lhs: Сoordinate, rhs: Сoordinate) -> Bool
{
    lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
}

// MARK: - Details about why Location service isn't allowed

enum LocationServiceNotAllowed : CustomStringConvertible
{
    /// Location service is neither restricted nor the app denided
    case notDetermined
    
    /// provide instructions for changing restrictions options in Settings > General > Restrictions
    case deniedForAllAndRestricted /// in case if location services turned off
    case restricted  /// in case if location services turned on
    
    /// provide instructions for enabling the Location Services switch in Settings > Privacy
    case deniedForAll /// in case if location services turned off but not restricted
    
    /// provide instructions for enabling services for the app in Settings > The App
    case deniedForTheApp /// in case if location services turned on but not restricted
    
    var description : String
    {
        switch self
        {
        case .notDetermined:
            return "notDetermined"
        case .deniedForAllAndRestricted:
            return "deniedForAllAndRestricted"
        case .restricted:
            return "restricted"
        case .deniedForAll:
            return "deniedForAll"
        case .deniedForTheApp:
            return "deniedForTheApp"
        }
    }
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
    static func locationServicesEnabled() -> Bool
}

extension CLLocationManager : LocationManagerProtocol { }

// MARK: - GeoLocationReceiver used via Singletone

class GeoLocationReceiver : NSObject
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
    
    func requestLocationUpdateOnce(_ actionIfNotAllowed:
                                    ((_ case: LocationServiceNotAllowed) -> Void)? = nil)
    {
        #if DEBUG
        print(">> [\(type(of: self))]." + #function)
        #endif
        
        let status = type(of: locationManager).authorizationStatus()
        let isLocationServiceEnabled = type(of: locationManager).locationServicesEnabled()
        
        var locationServiceNotAllowed : LocationServiceNotAllowed?
        
        if status == .notDetermined
        {
            locationServiceNotAllowed = .notDetermined
        }
        
        if status == .denied
        {
            locationServiceNotAllowed = isLocationServiceEnabled ?
                .deniedForTheApp : .deniedForAll
        }
        
        if status == .restricted
        {
            locationServiceNotAllowed = isLocationServiceEnabled ?
                .restricted : .deniedForAllAndRestricted
        }
        
        guard let caseNotAllowed = locationServiceNotAllowed, let takeAction = actionIfNotAllowed
        else { locationManager.requestLocation(); return }
        
        takeAction(caseNotAllowed)
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
            let result: Result<Сoordinate, LocationReceivedError> =
                .failure(.receivedEmptyLocationData)
            
            Settings.notificationCenter.post(name: .locationReceivedNotification, object: result)
            return
        }
        
        let result: Result<Сoordinate, LocationReceivedError> =
            .success(Сoordinate(latitude: value.latitude, longitude: value.longitude))
        
        #if DEBUG
        print("RECEIVER     : [\(value.latitude), \(value.longitude)]")
        #endif
        
        Settings.notificationCenter.post(name: .locationReceivedNotification, object: result)
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        let result: Result<Сoordinate, LocationReceivedError> =
            .failure(.failedRequest(error.localizedDescription))
        
        Settings.notificationCenter.post(name: .locationReceivedNotification, object: result)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization
                            status: CLAuthorizationStatus)
    {
        if status == .authorizedWhenInUse
        {
            locationManager.requestLocation()
        }
    }
}
