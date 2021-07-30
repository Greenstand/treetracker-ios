//
//  BaseNavigationViewController.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 23/05/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import UIKit

class BaseNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.tintColor = Asset.Colors.grayDark.color
        navigationBar.prefersLargeTitles = true
        navigationBar.titleTextAttributes = [
            .font: FontFamily.Montserrat.bold.font(size: 15),
            .foregroundColor: Asset.Colors.grayDark.color
        ]
        navigationBar.largeTitleTextAttributes = [
            .font: FontFamily.Montserrat.bold.font(size: 35),
            .foregroundColor: Asset.Colors.grayDark.color
        ]
    }
}
