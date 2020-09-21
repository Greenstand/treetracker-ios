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
    var identification: NSSet? { get set }
    var acceptedTerms: Bool { get set }
}

extension PlanterDetail: Planter {
    var latestIdentification: PlanterIdentification? {
        let sortedPlanterIdentification = identification?.sorted(by: { (lhs, rhs) -> Bool in
            guard let lhs = lhs as? PlanterIdentification,
                let rhs = rhs as? PlanterIdentification,
                let lhsDate = lhs.createdAt,
                let rhsDate = rhs.createdAt else {
                    return false
            }
            return lhsDate > rhsDate
        })
        return sortedPlanterIdentification?.first as? PlanterIdentification
    }
}
