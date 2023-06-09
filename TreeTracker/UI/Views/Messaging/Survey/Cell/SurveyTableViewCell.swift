//
//  SurveyTableViewCell.swift
//  TreeTracker
//
//  Created by Frédéric Helfer on 02/06/23.
//  Copyright © 2023 Greenstand. All rights reserved.
//

import UIKit

class SurveyTableViewCell: UITableViewCell {

    @IBOutlet private var buttonView: UIView! {
        didSet {
            buttonView.backgroundColor = Asset.Colors.backgroundGreen.color
            buttonView.layer.cornerRadius = 5.0
            buttonView.clipsToBounds = true
        }
    }

    @IBOutlet private var buttonTitle: UILabel! {
        didSet {
            buttonTitle.font = FontFamily.Montserrat.semiBold.font(size: 18)
            buttonTitle.textColor = Asset.Colors.grayDark.color
        }
    }

    static let identifier: String = "SurveyTableViewCell"
    static func nib() -> UINib {
        UINib(nibName: identifier, bundle: nil)
    }

}

// MARK: - Public Action
extension SurveyTableViewCell {

    func setupCell(choice: SurveyViewModel.Choice?) {
        buttonTitle.text = choice?.text

        if let choice, choice.isSelected {
            buttonView.backgroundColor = Asset.Colors.primaryGreen.color
        } else {
            buttonView.backgroundColor = Asset.Colors.backgroundGreen.color
        }
    }

}
