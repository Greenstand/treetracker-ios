//
//  SurveyViewModel.swift
//  TreeTracker
//
//  Created by Frédéric Helfer on 01/06/23.
//  Copyright © 2023 Greenstand. All rights reserved.
//

import Foundation

protocol SurveyViewModelCoordinatorDelegate: AnyObject {

}

protocol SurveyViewModelViewDelegate: AnyObject {

}

class SurveyViewModel {

    weak var coordinatorDelegate: SurveyViewModelCoordinatorDelegate?
    weak var viewDelegate: SurveyViewModelViewDelegate?

    private let chat: ChatListViewModel.Chat

    init(chat: ChatListViewModel.Chat) {
        self.chat = chat
    }

}

