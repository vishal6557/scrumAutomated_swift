//
//  UsersNotes.swift
//  FinalApp
//
//  Created by vishal diyora on 4/27/18.
//  Copyright © 2018 vishal diyora. All rights reserved.
//

import UIKit


class UsersNotes {
    var userID: String
    var taskNo: Int
    var description: String
    var emotion: String
    var sentiment: String
    var date: String
    var progress: Float
    init(userID: String, taskNo: Int, description: String, emotion: String, sentiment: String, date: String, progress: Float) {
        self.userID = userID
        self.taskNo = taskNo
        self.description = description
        self.emotion = emotion
        self.sentiment = sentiment
        self.date = date
        self.progress = progress
    }
    
    func save(completion: @escaping (Error?) -> Void) {
        // 1. reference to database
        let ref = DatabaseReferenceEnum.notes().reference().childByAutoId()
        let key = ref.key
        let ref2 = DatabaseReferenceEnum.usernotes(userID: userID, noteID: key).reference()
        // 2. setValue of the reference
        ref.updateChildValues(toDictionary())
        ref2.updateChildValues(toDictionary())
        
        let UserNote = UserNotes(userID: userID,noteID: key, taskNo: taskNo, description: description, emotion: emotion, sentiment: sentiment, date: date, progress: progress);
        totalUserNotes.append(UserNote)
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "userID" : userID,
            "taskNo" : taskNo,
            "description" : description,
            "emotion" : emotion,
            "sentiment" : sentiment,
            "date" : date,
            "progress" : progress,
        ]
    }
}
