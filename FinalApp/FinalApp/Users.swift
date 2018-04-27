//
//  Users.swift
//  FinalApp
//
//  Created by vishal diyora on 4/26/18.
//  Copyright © 2018 vishal diyora. All rights reserved.
//
import Foundation


class Users {
    var userID: String
    var emailAddress: String
    var name: String
    var userType: String
    init(name: String,emailAddress: String, userType: String, userID: String) {
        self.name = name
        self.emailAddress = emailAddress
        self.userType = userType
        self.userID = userID
    }
}

var totalUser = [Users]()
func addUsers(userID: String,name: String,emailAddress: String, userType: String, password: String ) {
    let User = Users(name: name, emailAddress: emailAddress, userType: userType, userID: userID);
    totalUser.append(User)
}
