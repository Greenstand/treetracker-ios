//
//  LocationManager.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 13/07/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import CoreLocation

protocol LocationServiceDelegate: AnyObject {
    func locationService(_ locationService: LocationService, didUpdateLocation: Location?)
}

class LocationService: NSObject {

    weak var delegate: LocationServiceDelegate?

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
        delegate?.locationService(self, didUpdateLocation: locations.last)
    }
}

// MARK: - CLLocation + Location
extension CLLocation: Location {

    var latitude: Double {
        return coordinate.latitude
    }

    var longitude: Double {
        return coordinate.longitude
    }
}
