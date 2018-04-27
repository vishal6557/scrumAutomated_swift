//
//  loginController.swift
//  FinalApp
//
//  Created by vishal diyora on 4/26/18.
//  Copyright © 2018 vishal diyora. All rights reserved.
//

import UIKit
import Firebase

class loginController: UITableViewController {

    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var emailaddress: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func back(_ sender: UIBarButtonItem) {
          dismiss(animated: true, completion:nil)
    }
    @IBAction func validateLogin(_ sender: UIButton) {
        
        let emailAddressData:String = emailaddress.text!
        let passwordData:String =  password.text ?? "nil"
        
        if(emailAddressData == nil  || (passwordData ?? "").isEmpty) {
//            let alert = UIAlertController(title: "Invalid Input", message: "Please enter the correct details", preferredStyle: .alert)
//            let ok = UIAlertAction(title: "OK", style: .cancel, handler: { (action) -> Void in })
//            alert.addAction(ok)
//            alert.show()
            displayAlert(title: "Field Empty", message: "Field should not be empty to login")
        }
        else {
            //Log into app
            Auth.auth().signIn(withEmail: emailAddressData, password: passwordData, completion: {(firUser, error) in
                if let error = error {
                    let newerror = error as! NSError
                    print("Navi error",newerror.userInfo["error_name"])
                    print(error)
                    displayAlert(title: newerror.userInfo["error_name"] as! String, message: error.localizedDescription)
                } else {
                    self.dismiss(animated: false, completion: nil)
                }
            })
        }
        
    }
}
