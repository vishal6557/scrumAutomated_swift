//
//  Users.swift
//  FinalApp
//
//  Created by vishal diyora on 4/26/18.
//  Copyright © 2018 vishal diyora. All rights reserved.
//
import Foundation
import Firebase

class UserNotes {
    var userID: String
    var noteID: String
    var taskNo: Int
    var description: String
    var emotion: String
    var sentiment: String
    var date: String
    var progress: Float
    init(userID: String,noteID: String, taskNo: Int, description: String, emotion: String, sentiment: String, date: String, progress: Float) {
        self.userID = userID
        self.noteID = noteID
        self.taskNo = taskNo
        self.description = description
        self.emotion = emotion
        self.sentiment = sentiment
        self.date = date
        self.progress = progress
    }
}

var totalUserNotes = [UserNotes]()

func addUserNotes(taskNo: Int, description: String, emotion: String, sentiment: String, progress: Float) {
    let todaysDate = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.timeStyle = DateFormatter.Style.none
    dateFormatter.dateStyle = DateFormatter.Style.medium
    
    let userID = Auth.auth().currentUser?.uid
    if let uid = userID {
        let userNotes = UsersNotes(userID: uid, taskNo: taskNo, description: description, emotion: emotion, sentiment: sentiment, date: dateFormatter.string(from: todaysDate), progress: progress)
        userNotes.save(completion: {(error) in
            if error != nil {
                print(error)
            } else {
              print("Data Saved")
            }
        })
    }
}

