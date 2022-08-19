//
//  SignUpService.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 20/06/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

public struct SignUpDetails {

    let username: Username
    let name: Name
    let organization: Organization
    let latitude: Double
    let longitude: Double

    public init(
        username: Username,
        name: Name,
        organization: Organization,
        latitude: Double,
        longitude: Double
    ) {
        self.username = username
        self.name = name
        self.organization = organization
        self.latitude = latitude
        self.longitude = longitude
    }
}

public protocol SignUpService {
    func signUp(withDetails signUpDetails: SignUpDetails, completion: (Result<Planter, Error>) -> Void)
}

class LocalSignUpService: SignUpService {

    private let coreDataManager: CoreDataManaging

    init(coreDataManager: CoreDataManaging) {
        self.coreDataManager = coreDataManager
    }

    func signUp(withDetails signUpDetails: SignUpDetails, completion: (Result<Planter, Error>) -> Void) {

        let planterDetail = PlanterDetail(context: coreDataManager.viewContext)

        switch signUpDetails.username {
        case .email(let email):
            planterDetail.email = email
        case .phoneNumber(let phoneNumber):
            planterDetail.phoneNumber = phoneNumber
        }

        planterDetail.firstName = signUpDetails.name.firstName
        planterDetail.lastName = signUpDetails.name.lastName
        planterDetail.organization = signUpDetails.organization.name
        planterDetail.createdAt = Date()
        planterDetail.uploaded = false
        planterDetail.identifier = signUpDetails.username.value
        planterDetail.uuid = UUID().uuidString
        planterDetail.latitude = signUpDetails.latitude
        planterDetail.longitude = signUpDetails.longitude

        do {
            try coreDataManager.viewContext.save()
            completion(.success(planterDetail))
        } catch {
            completion(.failure(error))
        }
    }
}
