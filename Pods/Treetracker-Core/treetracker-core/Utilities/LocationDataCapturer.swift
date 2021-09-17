//
//  LocationDataCapturer.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 03/08/2021.
//  Copyright © 2021 Greenstand. All rights reserved.
//

import Foundation

public protocol LocationDataCapturerDelegate: AnyObject {
    func locationDataCapturer(
        _ locationDataCapturer: LocationDataCapturing,
        didUpdateConvergenceStatus convergenceStatus: ConvergenceStatus
    )
}

public protocol LocationDataCapturing: AnyObject {
    var delegate: LocationDataCapturerDelegate? { get set }
    func addLocation(location: Location, forTree treeUUID: String, planter: Planter)
}

class LocationDataCapturer: LocationDataCapturing {

    public weak var delegate: LocationDataCapturerDelegate?

    private var lastConvergenceWithinRange: Convergence?
    private var currentConvergence: Convergence?
    private var convergenceStatus: ConvergenceStatus? {
        didSet {
            if let convergenceStatus = convergenceStatus {
                delegate?.locationDataCapturer(self, didUpdateConvergenceStatus: convergenceStatus)
            }
        }
    }
    private var locations: [Location] = []
    private let configuration: ConvergenceConfiguration = ConvergenceConfiguration()
    private let locationDataService: LocationDataService

    init(locationDataService: LocationDataService) {
        self.locationDataService = locationDataService
    }

    func addLocation(location: Location, forTree treeUUID: String, planter: Planter) {

        let evictedLocation: Location? = {
            if locations.count >= configuration.convergenceDataSize {
                return locations.removeFirst()
            }
            return nil
        }()

        locations.append(location)

        if locations.count >= configuration.convergenceDataSize {
            if currentConvergence == nil || (currentConvergence?.locations.count ?? 0) < configuration.convergenceDataSize {
                currentConvergence = Convergence(locations: locations)
                currentConvergence?.computeConvergence()
            } else {
                if let evictedLocation = evictedLocation {
                    currentConvergence?.computeSlidingWindowConvergence(replaceLocation: evictedLocation, newLocation: location)
                }
            }

            if let longStdDev = currentConvergence?.longitudinalStandardDeviation(),
                  let latStdDev = currentConvergence?.latitudinalStandardDeviation() {

                if (Float(longStdDev) < configuration.longitudeStandardDeviationThreshold &&
                        Float(latStdDev) < configuration.latitudeStandardDeviationThreshold
                ) {
                    convergenceStatus = ConvergenceStatus.converged
                    lastConvergenceWithinRange = currentConvergence
                } else {
                    convergenceStatus = ConvergenceStatus.notConverged
                }
            }
        }

        locationDataService.addLocation(
            location: location,
            withConvergenceStatus: convergenceStatus?.rawValue ?? "NONE",
            forTree: treeUUID,
            planter: planter, completion: nil
        )
    }
}
