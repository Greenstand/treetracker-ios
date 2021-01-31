//
//  CurrentPlanterService.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 31/01/2021.
//  Copyright © 2021 Greenstand. All rights reserved.
//

import Foundation
import CoreData

protocol CurrentPlanterService {
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
        guard let currentUserIdentifier = userDefaults.string(forKey: UserDefaultsKey.currentUserIdentity),
              let lastLoginTimestamp = userDefaults.value(forKey: UserDefaultsKey.currentUserLoginTime) as? Date,
              -lastLoginTimestamp.timeIntervalSinceNow < Constants.currentuserTimeout,
              let planter = planter(forUserIdentifier: currentUserIdentifier) else {
            clearCurrentPlanter()
            return nil
        }
        return planter
    }

    func updateCurrentPlanter(planter: Planter) {
        userDefaults.setValue(planter.identifier, forKey: UserDefaultsKey.currentUserIdentity)
        userDefaults.setValue(Date(), forKey: UserDefaultsKey.currentUserLoginTime)
    }

    func clearCurrentPlanter() {
        userDefaults.removeObject(forKey: UserDefaultsKey.currentUserIdentity)
        userDefaults.removeObject(forKey: UserDefaultsKey.currentUserLoginTime)
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
        static let currentuserTimeout: TimeInterval = 7200.0 // 2 hours
    }
    enum UserDefaultsKey {
        static let currentUserIdentity: String = "currentUserIdentity"
        static let currentUserLoginTime: String = "currentUserLoginTime"
    }
}
