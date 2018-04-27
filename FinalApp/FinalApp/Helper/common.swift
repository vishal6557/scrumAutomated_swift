//
//  common.swift
//  FinalApp
//
//  Created by vishal diyora on 4/26/18.
//  Copyright © 2018 vishal diyora. All rights reserved.
//

import Foundation

///Validation

func validatePhone(value: String) -> Bool {
    let PHONE_REGEX = "^\\d{3}\\d{3}\\d{4}$"
    let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
    let result =  phoneTest.evaluate(with: value)
    return result
}


func validateName(value: String) -> Bool {
    let NAME_REGEX = "\\A\\w{7,18}\\z"
    let nameTest = NSPredicate(format: "SELF MATCHES %@", NAME_REGEX)
    let result =  nameTest.evaluate(with: value)
    return result
}

//func alertFunction(title:String, message:String){
//    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//    let ok = UIAlertAction(title: "OK", style: .cancel, handler: { (action) -> Void in })
//    alert.addAction(ok)
//    self.present(alert, animated: true)
//}

