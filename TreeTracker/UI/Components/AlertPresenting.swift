//
//  AlertPresenting.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 24/06/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import UIKit

enum Alert {

    case error(Error)
    case information(title: String, message: String)

    var title: String {
        switch self {
        case .error:
            return L10n.Alert.Title.error
        case .information(let title, _):
            return title
        }
    }

    var message: String {
        switch self {
        case .error(let erorr):
            return erorr.localizedDescription
        case .information(_, let message):
            return message
        }
    }
}

protocol AlertPresenting {
    func present(alert: Alert)
}

extension AlertPresenting where Self: UIViewController {

    func present(alert: Alert) {

        let alertController = UIAlertController(
            title: alert.title,
            message: alert.message,
            preferredStyle: .alert
        )

        alertController.addAction(
            UIAlertAction(
                title: L10n.Alert.Button.ok,
                style: .cancel
            )
        )

        present(alertController, animated: true)
    }
}
