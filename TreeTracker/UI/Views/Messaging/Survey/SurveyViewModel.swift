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
    func surveyViewModel(_ surveyViewModel: SurveyViewModel, showNextQuestion survey: SurveyViewModel.Survey, planter: Planter)
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

    init(planter: Planter, survey: SurveyViewModel.Survey, messagingService: MessagingService) {
        self.planter = planter
        self.survey = survey
        self.messagingService = messagingService
        updateQuestion()
    }

    var questionNumber: Int = 0

    private func updateQuestion() {
        survey.showQuestionNum += 1
        self.questionNumber = survey.showQuestionNum
    }

    var title: String {
        let title = survey.response ? L10n.Survey.Title.response : L10n.Survey.Title.question
        return "\(title) \(questionNumber + 1)/\(survey.questions.count)"
    }

    var numberOfRowsInSection: Int {
        return survey.questions[questionNumber].choices.count
    }

    func getChoiceForRowAt(indexPath: IndexPath) -> Choice {
        let choiceText = survey.questions[questionNumber].choices[indexPath.row]

        if survey.surveyResponse.indices.contains(questionNumber) {
            if survey.surveyResponse[questionNumber] == choiceText {
                return Choice(text: choiceText, isSelected: true)
            }
        }

        return Choice(text: choiceText, isSelected: false)
    }

    func didSelectRowAt(indexPath: IndexPath) {
        guard survey.response == false else { return }

        let selectedChoice = survey.questions[questionNumber].choices[indexPath.row]
        if survey.surveyResponse.indices.contains(questionNumber) {
            survey.surveyResponse[questionNumber] = selectedChoice
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
        if survey.questions.indices.contains(survey.showQuestionNum + 1) {
            coordinatorDelegate?.surveyViewModel(self, showNextQuestion: survey, planter: planter)
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
        var showQuestionNum: Int
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
