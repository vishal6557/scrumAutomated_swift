//
//  MasterViewController.swift
//  FinalApp
//
//  Created by vishal diyora on 4/25/18.
//  Copyright © 2018 vishal diyora. All rights reserved.
//

import UIKit
import Firebase

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [UserNotes]()
    
    func configureView() {
        // Update the user interface for the detail item.
        self.objects = totalUserNotes
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // one time sign in if the user logs in already or not
        Auth.auth().addStateDidChangeListener({(auth,user) in
            if user != nil {
                // we do have the user. the user did log in
                //TODO: fetch
               // self.viewDidLoad()
                print("In App MasterViewController")
            } else {
                // the user hasnt logged in screen
                self.performSegue(withIdentifier: "ShowWelcome", sender: nil)
            }
        })
        
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        
//    }
    
    @IBAction func logOutDidTap(_ sender: UIBarButtonItem) {
        
        try! Auth.auth().signOut()
        self.performSegue(withIdentifier: "ShowWelcome", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addUsers(name: "Rakshit Shah",emailAddress: "rakshitshah7@gmail.com", userType: 0, password: "password")
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItems?.append(addButton)
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
         configureView()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc
    func insertNewObject(_ sender: Any) {
        let acvc = MicrophoneBasicViewController(nibName: "MicrophoneBasicViewController", bundle:nil)
        self.present(acvc, animated: true, completion: nil)
    }
    
    @objc func loadList(){
        //load data here
        configureView()
        self.tableView.reloadData()
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let object = objects[indexPath.row]
        cell.textLabel!.text = "Task No - \(object.taskNo)"
        cell.detailTextLabel!.text = object.date
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

