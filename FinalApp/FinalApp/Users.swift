//
//  Users.swift
//  FinalApp
//
//  Created by vishal diyora on 4/26/18.
//  Copyright © 2018 vishal diyora. All rights reserved.
//
import Foundation


class Users {
    var userID: Int
    var emailAddress: String
    var name: String
    var userType: Int
    var password: String
    init(name: String,emailAddress: String, userType: Int, userID: Int, password: String) {
        self.name = name
        self.emailAddress = emailAddress
        self.userType = userType
        self.userID = userID
        self.password = password
    }
}

var totalUser = [Users]()
var userIDCount:Int = 0

func addUsers(name: String,emailAddress: String, userType: Int, password: String ) {
    let count = userIDCount + 1
    let User = Users(name: name,emailAddress: emailAddress, userType: userType, userID: count, password: password);
    totalUser.append(User)
}
