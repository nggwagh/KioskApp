//
//  Question.swift
//  QuestionAnswer
//
//  Created by Nikhil Wagh on 3/16/19.
//  Copyright © 2019 Nikhil Wagh. All rights reserved.
//

import UIKit


//struct Question{
//
//    var questionTitle: String?
//    var questionType: String?
//    var questionAnswers: Array<Any>?
//    var answerSelection: [String]?
//    var correctAnswer: String?
//    var isVisible: Bool?
//    var isCompleted: Bool?
//    var currentAnswerIsCorrect: String?
//}


struct Question{
    
    let questionId: Int?
    let surveyId: Int?
    let surveyCategoryID: Int?
    var questionTitle: String?
    var questionType: String?
    var questionAnswers: [Answer]?
    var answerSelection: [String]?
    var correctAnswer: String?
    var isCompleted: Bool?
    var currentAnswerIsCorrect: String?
}

extension Question {
    
    static func build(from questionJsonObjects: [[String:Any]]) -> [Question] {
        
        return questionJsonObjects.compactMap({ questionJsonObject in
            
            let languagePreference = UserDefaults.standard.value(forKey: Constant.UserDefaultKey.languagePreference) as! String
            
            let answerArray = Answer.build(from: (questionJsonObject["answers"] as! [[String:Any]]))
            
            let correctAnswer = answerArray.filter({$0.isCorrectAnswer == 1})
            
            return Question(questionId: questionJsonObject["id"] as? Int,
                            surveyId: questionJsonObject["surveyID"] as? Int,
                            surveyCategoryID: questionJsonObject["surveyCategoryID"] as? Int,
                            questionTitle: (languagePreference == "EN") ? questionJsonObject["question"] as? String : questionJsonObject["question_fr"] as? String,
                            questionType: (answerArray.count == 2) ? "Radio" : "Single",
                            questionAnswers: answerArray,
                            answerSelection: [],
                            correctAnswer: (correctAnswer.count > 0) ?  correctAnswer[0].answer : answerArray[0].answer,
                            isCompleted: false,
                            currentAnswerIsCorrect: "")
        })
    }
}




/*
{
    "id": 1,
    "name": "Sample Survey",
    "created_at": null,
    "updated_at": null,
    "screensaverID": null,
    "questions": [
    {
    "id": 1,
    "question": "What is 2+2?",
    "surveyID": 1,
    "surveyCategoryID": 2,
    "answers": [
    {
    "id": 1,
    "answer": "Three",
    "surveyQuestionID": 1,
    "order": 0,
    "isCorrectAnswer": 0
    },
    {
    "id": 2,
    "answer": "Five",
    "surveyQuestionID": 1,
    "order": 1,
    "isCorrectAnswer": 1
    },
    {
    "id": 3,
    "answer": "Four",
    "surveyQuestionID": 1,
    "order": 2,
    "isCorrectAnswer": 0
    }
    ],
    "category": {
    "id": 2,
    "name": "Math"
    }
    },
    {
    "id": 2,
    "question": "Capital of Canada?",
    "surveyID": 1,
    "surveyCategoryID": 1,
    "answers": [
    {
    "id": 5,
    "answer": "Montreal",
    "surveyQuestionID": 2,
    "order": 0,
    "isCorrectAnswer": 0
    },
    {
    "id": 6,
    "answer": "Ottawa",
    "surveyQuestionID": 2,
    "order": 1,
    "isCorrectAnswer": 1
    },
    {
    "id": 4,
    "answer": "Toronto",
    "surveyQuestionID": 2,
    "order": 2,
    "isCorrectAnswer": 0
    }
    ],
    "category": {
    "id": 1,
    "name": "General"
    }
    }
    ],
    "screensaver": {
        "id": 0,
        "url": "https://www.hdccontacts.com/default.mp4",
        "isContest": 0,
        "contestRulesURL": ""
    }
}
*/
