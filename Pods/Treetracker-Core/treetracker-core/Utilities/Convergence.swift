//
//  Convergence.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 30/07/2021.
//  Copyright © 2021 Greenstand. All rights reserved.
//

import Foundation

class Convergence {

    let locations: [Location]

    private var longitudeConvergence: ConvergenceStats
    private var latitudeConvergence: ConvergenceStats

    init(locations: [Location]) {
        self.locations = locations
        self.longitudeConvergence = locations.map { $0.longitude }.convergenceStats
        self.latitudeConvergence = locations.map { $0.latitude }.convergenceStats
    }

    func computeConvergence() {
        self.longitudeConvergence = locations.map { $0.longitude }.convergenceStats
        self.latitudeConvergence = locations.map { $0.latitude }.convergenceStats
    }

    func computeSlidingWindowConvergence(replaceLocation: Location, newLocation: Location) {

        self.longitudeConvergence = computeSlidingWindowStats(
            currentStats: longitudeConvergence,
            replacingValue: replaceLocation.longitude,
            newValue: newLocation.longitude
        )
        self.latitudeConvergence = computeSlidingWindowStats(
            currentStats: latitudeConvergence,
            replacingValue: replaceLocation.latitude,
            newValue: newLocation.latitude
        )
    }

    func longitudinalStandardDeviation() -> Double? {
         return longitudeConvergence.standardDeviation
     }

    func latitudinalStandardDeviation() -> Double? {
         return latitudeConvergence.standardDeviation
     }
}

// MARK: - Private
private extension Convergence {
    /*
     * Implementation based on the following answer found in stackexchange since it seems to be a good
     * approximation to the running window standard deviation calculation. Considered Welford's
     * method of computing variance but it calculates running cumulative variance but we need
     * sliding window computation here.
     *
     * https://math.stackexchange.com/questions/2815732/calculating-standard-deviation-of-a-moving-window
     *
     * Assuming you are using SD with Bessel's correction, call μn and SDn the mean and
     * standard deviation from n to n+99. Then, calculate μ1 and SD1 afterwards, you can use the
     * recursive relation
     *  μn+1=μn−(1/99*X(n))+(1/99*X(n+100)) and
     *  variance(n+1)= variance(n) −1/99(Xn−μn)^2 + 1/99(X(n+100)−μ(n+1))^2
     */
    func computeSlidingWindowStats(currentStats: ConvergenceStats, replacingValue: Double, newValue: Double) -> ConvergenceStats {

        let newMean: Double = currentStats.mean -
            (replacingValue / Double(locations.count)) +
            (newValue / Double(locations.count))

        let newVariance = currentStats.variance -
            (pow((replacingValue - currentStats.mean), 2.0) / Double(locations.count)) +
            (pow((newValue - newMean), 2.0) / Double(locations.count))

        let newStandarddDeviation = sqrt(newVariance)

        return ConvergenceStats(
            mean: newMean,
            variance: newVariance,
            standardDeviation: newStandarddDeviation
        )
    }
}

// MARK: - Nested Types
private extension Convergence {

    struct ConvergenceStats {
        let mean: Double
        let variance: Double
        let standardDeviation: Double
    }
}

struct ConvergenceConfiguration {
    let convergenceDataSize: Int = 5
    let longitudeStandardDeviationThreshold: Float = 0.0001
    let latitudeStandardDeviationThreshold: Float = 0.0001
    let convergenceTimeout: TimeInterval = 60000
    let minimumTimeBetweenUpdates: TimeInterval = 1000
    let minimumDistanceBetweenUpdates: Float = 0
}

// MARK: - Array Extension
private extension Array where Element == Double {

    var convergenceStats: Convergence.ConvergenceStats {
        return Convergence.ConvergenceStats(
            mean: mean,
            variance: variance,
            standardDeviation: standardDeviation
        )
    }

    var mean: Double {
        return self.reduce(0.0, +) / Double(self.count)
    }

    var variance: Double {
        return self.reduce(0.0) { variance, value in
            return variance + pow((value - mean), 2.0)
        } / Double(self.count)
    }

    var altVariance: Double {
        var variance = 0.0
        for value in self {
            variance += pow((value - mean), 2.0)
        }
        variance /= Double(self.count)
        return variance
    }

    var standardDeviation: Double {
        return sqrt(variance)
    }
}
