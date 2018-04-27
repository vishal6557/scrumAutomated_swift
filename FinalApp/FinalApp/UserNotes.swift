//
//  Users.swift
//  FinalApp
//
//  Created by vishal diyora on 4/26/18.
//  Copyright © 2018 vishal diyora. All rights reserved.
//
import Foundation


class UserNotes {
    var userID: Int
    var noteID: Int
    var taskNo: Int
    var description: String
    var emotion: String
    var sentiment: String
    var date: String
    var progress: Float
    init(userID: Int,noteID: Int, taskNo: Int, description: String, emotion: String, sentiment: String, date: String, progress: Float) {
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
var noteIDCount:Int = 0

func addUserNotes(userID: Int, taskNo: Int, description: String, emotion: String, sentiment: String, progress: Float) {
    let todaysDate = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.timeStyle = DateFormatter.Style.none
    dateFormatter.dateStyle = DateFormatter.Style.medium
    
    let count = noteIDCount + 1
    let UserNote = UserNotes(userID: userID,noteID: count, taskNo: taskNo, description: description, emotion: emotion, sentiment: sentiment, date: dateFormatter.string(from: todaysDate), progress: progress);
    totalUserNotes.append(UserNote)
}

