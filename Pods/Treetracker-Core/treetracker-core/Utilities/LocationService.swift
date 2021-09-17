//
//  LocationService.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 13/07/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import CoreLocation

public protocol LocationProviderDelegate: AnyObject {
    func locationProvider(_ locationProvider: LocationProvider, didUpdateLocation location: Location?)
}

public protocol LocationProvider: AnyObject {
    var delegate: LocationProviderDelegate? { get set }
    func startMonitoringLocation()
    func stopMonitoringLocation()
    var location: Location? { get }
}

class LocationService: NSObject, LocationProvider {

    weak var delegate: LocationProviderDelegate?

    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.activityType = .other
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        return locationManager
    }()

    func startMonitoringLocation() {
        locationManager.startUpdatingLocation()
    }

    func stopMonitoringLocation() {
        locationManager.stopUpdatingLocation()
    }

    var location: Location? {
        return locationManager.location
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationService: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        delegate?.locationProvider(self, didUpdateLocation: locations.last)
    }
}

// MARK: - CLLocation + Location
extension CLLocation: Location {

    public var latitude: Double {
        return coordinate.latitude
    }

    public var longitude: Double {
        return coordinate.longitude
    }
}
