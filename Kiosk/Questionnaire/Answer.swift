//
//  Answer.swift
//  Kiosk
//
//  Created by Nikhil Wagh on 3/29/19.
//  Copyright © 2019 Mayur Deshmukh. All rights reserved.
//

import Foundation


struct Answer {
    
    let id: Int?
    let answer: String?
    let surveyQuestionID: Int?
    let order: Int?
    let isCorrectAnswer: Int?

}

extension Answer {
    
    static func build(from answerJsonObjects: [[String:Any]]) -> [Answer] {
    
        return answerJsonObjects.compactMap({ answerJsonObject in
            
            return Answer(id: answerJsonObject["id"] as? Int,
                          answer: answerJsonObject["answer"] as? String,
                          surveyQuestionID: answerJsonObject["surveyQuestionID"] as? Int,
                          order: answerJsonObject["order"] as? Int,
                          isCorrectAnswer: answerJsonObject["isCorrectAnswer"] as? Int)
    
        })
    }
}


/*
{
    "id": 1,
    "answer": "Three",
    "surveyQuestionID": 1,
    "order": 0,
    "isCorrectAnswer": 0
}
*/
