//
//  HelpScreenViewController.swift
//  TreeTracker
//
//  Created by Musoni nshuti Nicolas on 07/11/2024.
//  Copyright © 2024 Greenstand. All rights reserved.
//

import Foundation
import UIKit

class HelpScreenViewController: UIViewController {
	private let viewModel = HelpScreenViewModel()

	private lazy var helpTextMessage: UILabel = {
		let label = UILabel()
		label.text = "Placeholder content"
		label.textColor = .black
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = .systemFont(ofSize: 15)
		return label
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		title = viewModel.pageTitle

		view.addSubview(helpTextMessage)

		// Configure subviews
		configureSubviews()
	}

	private func configureSubviews() {
		NSLayoutConstraint.activate([
			helpTextMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			helpTextMessage.centerYAnchor.constraint(equalTo: view.centerYAnchor)
		])
	}
}
