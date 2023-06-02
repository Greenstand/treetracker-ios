//
//  SurveyViewController.swift
//  TreeTracker
//
//  Created by Frédéric Helfer on 01/06/23.
//  Copyright © 2023 Greenstand. All rights reserved.
//

import UIKit

class SurveyViewController: UIViewController {

    @IBOutlet private var questionLabel: UILabel! {
        didSet {
            questionLabel.font = FontFamily.Montserrat.bold.font(size: 28)
            questionLabel.textColor = Asset.Colors.grayDark.color
            questionLabel.numberOfLines = 0
            questionLabel.textAlignment = .center
            questionLabel.text = "Do you want more questions?" // remove
        }
    }

    @IBOutlet private var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.separatorStyle = .none
            tableView.register(SurveyTableViewCell.nib(), forCellReuseIdentifier: SurveyTableViewCell.identifier)
        }
    }

    @IBOutlet private var actionButton: UIButton! {
        didSet {
            actionButton.backgroundColor = Asset.Colors.primaryGreen.color
            actionButton.layer.cornerRadius = 15
            actionButton.tintColor = Asset.Colors.grayDark.color
        }
    }

    var viewModel: SurveyViewModel? {
        didSet {
            viewModel?.viewDelegate = self
        }
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

// MARK: - UITableViewDataSource
extension SurveyViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SurveyTableViewCell.identifier, for: indexPath) as? SurveyTableViewCell
        cell?.setupCell()
        return cell ?? UITableViewCell()
    }

}

// MARK: - UITableViewDelegate
extension SurveyViewController: UITableViewDelegate {

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
}

// MARK: - SurveyViewModelViewDelegate
extension SurveyViewController: SurveyViewModelViewDelegate {

}
