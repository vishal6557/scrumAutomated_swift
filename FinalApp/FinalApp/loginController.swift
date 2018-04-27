//
//  loginController.swift
//  FinalApp
//
//  Created by vishal diyora on 4/26/18.
//  Copyright © 2018 vishal diyora. All rights reserved.
//

import UIKit

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
            let alert = UIAlertController(title: "Invalid Input", message: "Please enter the correct details", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel, handler: { (action) -> Void in })
            alert.addAction(ok)
            alert.show()
            
        }
        
    }
}
