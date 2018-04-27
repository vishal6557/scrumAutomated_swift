//
//  WelcomeViewController.swift
//  FinalApp
//
//  Created by vishal diyora on 4/27/18.
//  Copyright © 2018 vishal diyora. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {
    
    var handle: AuthStateDidChangeListenerHandle?
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        handle = Auth.auth().addStateDidChangeListener({(auth, user) in
            if user != nil {
                // Just logged in successfully
                print("In App WelcomeViewController")
                self.dismiss(animated: false, completion: nil)
                //self.performSegue(withIdentifier: "showMainScreen", sender: nil)
                
            } else {
                  print("In App Error WelcomeViewController")
            }
        })

        // Do any additional setup after loading the view.
    }

        override func viewWillDisappear(_ animated: Bool) {
            //super.viewWillAppear(animated)
    
            // Auth.auth().removeStateDidChangeListener(handle!)
        }
 
}
