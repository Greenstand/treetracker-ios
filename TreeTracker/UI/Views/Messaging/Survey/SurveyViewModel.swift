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
    func surveyViewModel(_ surveyViewModel: SurveyViewModel, showNextQuestion survey: SurveyViewModel.Survey, planter: Planter, questionIndex: Int)
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

    init(planter: Planter, survey: SurveyViewModel.Survey, messagingService: MessagingService, questionIndex: Int) {
        self.planter = planter
        self.survey = survey
        self.messagingService = messagingService
        self.questionIndex = questionIndex
    }

    var questionIndex: Int

    var title: String {
        let title = survey.response ? L10n.Survey.Title.response : L10n.Survey.Title.question
        return "\(title) \(questionIndex + 1)/\(survey.questions.count)"
    }

    var numberOfRowsInSection: Int {
        return survey.questions[questionIndex].choices.count
    }

    func getChoiceForRowAt(indexPath: IndexPath) -> Choice {
        let choiceText = survey.questions[questionIndex].choices[indexPath.row]

        if survey.surveyResponse.indices.contains(questionIndex) {
            if survey.surveyResponse[questionIndex] == choiceText {
                return Choice(text: choiceText, isSelected: true)
            }
        }

        return Choice(text: choiceText, isSelected: false)
    }

    func didSelectRowAt(indexPath: IndexPath) {
        guard survey.response == false else { return }

        let selectedChoice = survey.questions[questionIndex].choices[indexPath.row]
        if survey.surveyResponse.indices.contains(questionIndex) {
            survey.surveyResponse[questionIndex] = selectedChoice
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
        if questionIndex < survey.questions.count - 1 {
            coordinatorDelegate?.surveyViewModel(self, showNextQuestion: survey, planter: planter, questionIndex: questionIndex + 1)
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
