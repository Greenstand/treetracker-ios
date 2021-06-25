//
//  Planter.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 01/07/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

protocol Planter: class {
    var createdAt: Date? { get set }
    var email: String? { get set }
    var firstName: String? { get set }
    var identifier: String? { get set }
    var lastName: String? { get set }
    var organization: String? { get set }
    var phoneNumber: String? { get set }
    var uploaded: Bool { get set }
    var checkIns: [PlanterCheckIn]? { get }
    var acceptedTerms: Bool { get set }
    var uuid: String? { get }
}

extension PlanterDetail: Planter {

    var checkIns: [PlanterCheckIn]? {
        return identification?.allObjects as? [PlanterIdentification]
    }

    private var sortedCheckIns: [PlanterCheckIn]? {
        return checkIns?
            .sorted(by: { (lhs, rhs) -> Bool in
                guard let lhsDate = lhs.createdAt,
                      let rhsDate = rhs.createdAt else {
                    return false
                }
                //Most Recent First
                return lhsDate > rhsDate
            })
    }

    var latestIdentification: PlanterCheckIn? {
        return sortedCheckIns?.first
    }

    var firstIdentificationURL: String? {
        return sortedCheckIns?.last?.photoURL
    }
}
