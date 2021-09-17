//
//  CurrentPlanterService.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 31/01/2021.
//  Copyright © 2021 Greenstand. All rights reserved.
//

import Foundation
import CoreData

public protocol CurrentPlanterService {
    func currentPlanter() -> Planter?
    func updateCurrentPlanter(planter: Planter)
    func clearCurrentPlanter()
}

class LocalCurrentPlanterService: CurrentPlanterService {

    private let userDefaults: UserDefaults
    private let coreDataManager: CoreDataManaging

    init(coreDataManager: CoreDataManaging, userDefaults: UserDefaults = .standard) {
        self.coreDataManager = coreDataManager
        self.userDefaults = userDefaults
    }

    func currentPlanter() -> Planter? {
        guard let currentPlanterIdentifier = userDefaults.string(forKey: UserDefaultsKey.currentPlanterIdentity),
              let lastLoginTimestamp = userDefaults.value(forKey: UserDefaultsKey.currentPlanterLoginTime) as? Date,
              -lastLoginTimestamp.timeIntervalSinceNow < Constants.currentPlanterTimeout,
              let planter = planter(forUserIdentifier: currentPlanterIdentifier) else {
            clearCurrentPlanter()
            return nil
        }
        return planter
    }

    func updateCurrentPlanter(planter: Planter) {
        userDefaults.setValue(planter.identifier, forKey: UserDefaultsKey.currentPlanterIdentity)
        userDefaults.setValue(Date(), forKey: UserDefaultsKey.currentPlanterLoginTime)
    }

    func clearCurrentPlanter() {
        userDefaults.removeObject(forKey: UserDefaultsKey.currentPlanterIdentity)
        userDefaults.removeObject(forKey: UserDefaultsKey.currentPlanterLoginTime)
    }
}

// MARK: - Private
private extension LocalCurrentPlanterService {

    func planter(forUserIdentifier identifier: String) -> Planter? {

        let fetchRequest: NSFetchRequest<PlanterDetail> = PlanterDetail.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)

        guard let planters = coreDataManager.perform(fetchRequest: fetchRequest),
              let planter = planters.first else {
            return nil
        }
        return planter
    }
}

// MARK: - Constants
private extension LocalCurrentPlanterService {

    enum Constants {
        static let currentPlanterTimeout: TimeInterval = 7200.0 // 2 hours
    }
    enum UserDefaultsKey {
        static let currentPlanterIdentity: String = "currentPlanterIdentity"
        static let currentPlanterLoginTime: String = "currentPlanterLoginTime"
    }
}
