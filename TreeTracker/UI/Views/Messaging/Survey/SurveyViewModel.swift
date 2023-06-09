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
    func surveyViewModel(_ surveyViewModel: SurveyViewModel, updateViewWith survey: SurveyViewModel.Survey)
}

class SurveyViewModel {

    weak var coordinatorDelegate: SurveyViewModelCoordinatorDelegate?
    weak var viewDelegate: SurveyViewModelViewDelegate?

    private var survey: SurveyViewModel.Survey
    let questionNumber: Int

    init(survey: SurveyViewModel.Survey) {
        self.survey = survey
        self.questionNumber = survey.showQuestionNum
    }

    var title: String {
        return "Survey \(questionNumber + 1)/\(survey.questions.count)"
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
