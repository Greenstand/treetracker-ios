//
//  Coordinator.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 02/05/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import UIKit

protocol CoordinatorConfigurable {
    var navigationController: UINavigationController { get }
}

struct CoordinatorConfiguration: CoordinatorConfigurable {
    let navigationController: UINavigationController
}

protocol Coordinator: class {
    var childCoordinators: [Coordinator] { get set }
    var configuration: CoordinatorConfigurable { get }
    func start()
}

extension Coordinator {

    func startCoordinator(coordinator: Coordinator) {
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
