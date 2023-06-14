//
//  SurveyViewModel.swift
//  TreeTracker
//
//  Created by Frédéric Helfer on 01/06/23.
//  Copyright © 2023 Greenstand. All rights reserved.
//

import Foundation
import Treetracker_Core

protocol SurveyViewModelCoordinatorDelegate: AnyObject {
    func surveyViewModel(_ surveyViewModel: SurveyViewModel, showNextQuestion survey: SurveyViewModel.Survey, planter: Planter, index: Int)
    func surveyViewModel(_ surveyViewModel: SurveyViewModel, didFinishSurvey survey: SurveyViewModel.Survey)
}

protocol SurveyViewModelViewDelegate: AnyObject {
    func surveyViewModel(_ surveyViewModel: SurveyViewModel, updateViewWith survey: SurveyViewModel.Survey)
}

class SurveyViewModel {

    weak var coordinatorDelegate: SurveyViewModelCoordinatorDelegate?
    weak var viewDelegate: SurveyViewModelViewDelegate?

    private let planter: Planter
    private var survey: SurveyViewModel.Survey
    private let messagingService: MessagingService

    init(planter: Planter, survey: SurveyViewModel.Survey, messagingService: MessagingService, index: Int) {
        self.planter = planter
        self.survey = survey
        self.messagingService = messagingService
        self.index = index
    }

    var index: Int

    var title: String {
        let title = survey.response ? L10n.Survey.Title.response : L10n.Survey.Title.question
        return "\(title) \(index + 1)/\(survey.questions.count)"
    }

    var numberOfRowsInSection: Int {
        return survey.questions[index].choices.count
    }

    func getChoiceForRowAt(indexPath: IndexPath) -> Choice {
        let choiceText = survey.questions[index].choices[indexPath.row]

        if survey.surveyResponse.indices.contains(index) {
            if survey.surveyResponse[index] == choiceText {
                return Choice(text: choiceText, isSelected: true)
            }
        }

        return Choice(text: choiceText, isSelected: false)
    }

    func didSelectRowAt(indexPath: IndexPath) {
        guard survey.response == false else { return }

        let selectedChoice = survey.questions[index].choices[indexPath.row]
        if survey.surveyResponse.indices.contains(index) {
            survey.surveyResponse[index] = selectedChoice
        } else {
            survey.surveyResponse.append(selectedChoice)
        }

        viewDelegate?.surveyViewModel(self, updateViewWith: survey)
    }

    func updateView() {
        viewDelegate?.surveyViewModel(self, updateViewWith: survey)
    }

}

// MARK: - Navigation
extension SurveyViewModel {

    func actionButtonPressed() {
        if index < survey.questions.count - 1 {
            coordinatorDelegate?.surveyViewModel(self, showNextQuestion: survey, planter: planter, index: index + 1)
        } else {

            if survey.response == false {
                messagingService.createSurveyResponse(planter: planter, surveyId: survey.surveyId, surveyResponse: survey.surveyResponse)
            }
            coordinatorDelegate?.surveyViewModel(self, didFinishSurvey: survey)
        }
    }

}

// MARK: - Nested Types
extension SurveyViewModel {

    struct Survey {
        let surveyId: String
        let title: String
        let questions: [Question]
        var surveyResponse: [String]
        var response: Bool
    }

    struct Question {
        let prompt: String
        let choices: [String]
    }

    struct Choice {
        let text: String
        var isSelected: Bool
    }

}
