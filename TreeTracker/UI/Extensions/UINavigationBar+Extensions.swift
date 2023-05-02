//
//  UINavigationBar+Extensions.swift
//  TreeTracker
//
//  Created by Frédéric Helfer on 02/05/23.
//  Copyright © 2023 Greenstand. All rights reserved.
//

import UIKit

extension UINavigationBar {

    func setupNavigationAppearance(
        prefersLargeTitles: Bool = true,
        backgroundColor: UIColor = .white
    ) {

        self.prefersLargeTitles = prefersLargeTitles
        self.tintColor = Asset.Colors.grayDark.color
        self.isTranslucent = false

        if #available(iOS 13.0, *) {

            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithDefaultBackground()
            navBarAppearance.shadowColor = .clear
            navBarAppearance.shadowImage = .init()
            navBarAppearance.backgroundColor = backgroundColor
            navBarAppearance.titleTextAttributes = [
                .font: FontFamily.Montserrat.bold.font(size: 15),
                .foregroundColor: Asset.Colors.grayDark.color
            ]
            navBarAppearance.largeTitleTextAttributes = [
                .font: FontFamily.Montserrat.bold.font(size: 35),
                .foregroundColor: Asset.Colors.grayDark.color
            ]
            self.standardAppearance = navBarAppearance
            self.scrollEdgeAppearance = navBarAppearance

        } else {

            self.backgroundColor = backgroundColor
            self.barTintColor = backgroundColor
            self.titleTextAttributes = [
                .font: FontFamily.Montserrat.bold.font(size: 15),
                .foregroundColor: Asset.Colors.grayDark.color
            ]
            self.largeTitleTextAttributes = [
                .font: FontFamily.Montserrat.bold.font(size: 35),
                .foregroundColor: Asset.Colors.grayDark.color
            ]

        }
    }
}
