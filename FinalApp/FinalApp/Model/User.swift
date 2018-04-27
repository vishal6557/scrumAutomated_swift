//
//  Users.swift
//  FinalApp
//
//  Created by vishal diyora on 4/26/18.
//  Copyright © 2018 vishal diyora. All rights reserved.
//
import UIKit


class User {
    var userID: String
    var emailAddress: String
    var name: String
    var userType: String
    //var password: String
    var profileImage: UIImage?
    init(name: String,emailAddress: String, userType: String, userID: String, profileImage: UIImage) {
        self.name = name
        self.emailAddress = emailAddress
        self.userType = userType
        self.userID = userID
        //self.password = password
        self.profileImage = profileImage
    }
    
    func save(completion: @escaping (Error?) -> Void) {
        // 1. reference to database
        let ref = DatabaseReferenceEnum.users(userID: userID).reference()
        // 2. setValue of the reference
        ref.setValue(toDictionary())
        // 3 . Save the users profile image
        if let profileImage = self.profileImage {
            let firImage = FIRImage(image: profileImage)
            firImage.saveProfileImage(userID, {(error) in
                // Called whenever the profile image is successfully uploaded - takes time !!
                completion(error)
            })
        }
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "userID" : userID,
            "name" : name,
            "emailAddress" : emailAddress,
            "userType" : userType,
        ]
    }
}

