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


func validateEmail(emailAddressString: String) -> Bool {
    let NAME_REGEX = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
    let nameTest = NSPredicate(format: "SELF MATCHES %@", NAME_REGEX)
    let result =  nameTest.evaluate(with: emailAddressString)
    return result
}

