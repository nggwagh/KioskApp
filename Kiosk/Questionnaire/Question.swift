//
//  Question.swift
//  QuestionAnswer
//
//  Created by Nikhil Wagh on 3/16/19.
//  Copyright © 2019 Nikhil Wagh. All rights reserved.
//

import UIKit


struct Question{
    
    var questionTitle: String?
    var questionType: String?
    var questionAnswers: Array<Any>?
    var answerSelection: [String]?
    var correctAnswer: String?
    var isVisible: Bool?
    var isCompleted: Bool?
    var currentAnswerIsCorrect: String?
}

/*
class Question: NSObject {

     var questionTitle: String? = ""
     var questionType: String? = ""
     var questionAnswers: Array<Any>? = []
     var answerSelection: Array<Any>? = []
     var correctAnswer: String? = ""
     var isVisible: Bool? = false
     var isCompleted: Bool? = false
     var currentAnswerIsCorrect: String? = ""

    init(questionTitle: String, questionType: String, questionAnswers: Array<Any>, answerSelection: Array<Any>, correctAnswer: String, isVisible: Bool, isCompleted: Bool, currentAnswerIsCorrect: String) {
        
        self.questionTitle = questionTitle
        self.questionType = questionType
        self.questionAnswers = questionAnswers
        self.answerSelection = answerSelection
        self.correctAnswer = correctAnswer
        self.isVisible = isVisible
        self.isCompleted = isCompleted
        self.currentAnswerIsCorrect = currentAnswerIsCorrect
    }
    
}
*/
