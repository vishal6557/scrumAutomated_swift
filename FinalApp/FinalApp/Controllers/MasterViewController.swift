//
//  MasterViewController.swift
//  FinalApp
//
//  Created by vishal diyora on 4/25/18.
//  Copyright © 2018 vishal diyora. All rights reserved.
//

import UIKit
import Firebase

class MasterViewController: UITableViewController, UISearchBarDelegate {
    
    var detailViewController: DetailViewController? = nil
    var objects = [UserNotes]()
    var filteredObjects = [UserNotes]()
    var userRole: String? = nil
    
    @IBOutlet weak var searchBar: UISearchBar!
    var isSearching = false
    
    
    
    func configureView() {
        // Update the user interface for the detail item.
        self.objects = totalUserNotes
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("In App MasterViewController")
        // one time sign in if the user logs in already or not
        
        Auth.auth().addStateDidChangeListener({(auth,user) in
            if user != nil {
                // we do have the user. the user did log in
                //TODO: fetch
                // self.viewDidLoad()
                var ref: DatabaseReference!
                ref = Database.database().reference()
                let userID = Auth.auth().currentUser?.uid
                ref.child("users").child(userID!).observeSingleEvent(of: .value, with:  { (snapshot) in
                    if let user = snapshot.value as? NSDictionary {
                        let userType = user["userType"] as? String ?? ""
                        let userName = user["name"] as? String ?? ""
                        self.userRole = userType
                        self.navigationItem.title = userName
                        if( userType == "Admin") {
                            self.fetchDataForAdmin(ref: ref)
                        } else
                        {
                            self.fetchDataForUser(ref: ref, userID: userID!)
                        }
                        
                    }
                })
                
                
            } else {
                // the user hasnt logged in screen
                self.performSegue(withIdentifier: "ShowWelcome", sender: nil)
            }
        })
        
    }
    
    func fetchDataForAdmin(ref: DatabaseReference) {
        ref.child("users").observeSingleEvent(of: .value, with: {(snapshot) in
            let usersdict = snapshot.value as? NSDictionary
            totalUser = []
            if let usersdic = usersdict {
                for (key, value) in usersdic {
                    let user = value as? NSDictionary
                    let userID = user?["userID"] as? String ?? ""
                    let name = user?["name"] as? String ?? ""
                    let emailAddress = user?["emailAddress"] as? String ?? ""
                    let userType = user?["userType"] as? String ?? ""
                    let imageURL = user?["profileImageURL"] as? String ?? ""
                    let userData = Users(name: name, emailAddress: emailAddress, userType: userType, userID: userID, imageURL: imageURL)
                    totalUser.append(userData)
                }
            }
        })
        ref.child("notes").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let notesdict = snapshot.value as? NSDictionary
            totalUserNotes = []
            if let notesdic = notesdict {
                for (key, value) in notesdic{
                    let notes = value as? NSDictionary
                    let noteID = key as? String ?? ""
                    let userID = notes?["userID"] as? String ?? ""
                    let taskNo = notes?["taskNo"] as? Int64 ?? 0
                    let description = notes?["description"] as? String ?? ""
                    let emotion = notes?["emotion"] as? String ?? ""
                    let sentiment = notes?["sentiment"] as? String ?? ""
                    let date = notes?["date"] as? String ?? ""
                    let progress = notes?["progress"] as? Int64 ?? 0
                    let UserNote = UserNotes(userID: userID,noteID: noteID, taskNo: Int(taskNo), description: description, emotion: emotion, sentiment: sentiment, date: date, progress: Float(progress));
                    totalUserNotes.append(UserNote)
                }
            }
            self.loadList()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func fetchDataForUser(ref: DatabaseReference, userID: String) {
        ref.child("users").child(userID).child("user_notes").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let notesdict = snapshot.value as? NSDictionary
            totalUserNotes = []
            if let notesdic = notesdict {
                for (key, value) in notesdic {
                    let notes = value as? NSDictionary
                    let noteID = key as? String ?? ""
                    let userID = notes?["userID"] as? String ?? ""
                    let taskNo = notes?["taskNo"] as? Int64 ?? 0
                    let description = notes?["description"] as? String ?? ""
                    let emotion = notes?["emotion"] as? String ?? ""
                    let sentiment = notes?["sentiment"] as? String ?? ""
                    let date = notes?["date"] as? String ?? ""
                    let progress = notes?["progress"] as? Int64 ?? 0
                    let UserNote = UserNotes(userID: userID,noteID: noteID, taskNo: Int(taskNo), description: description, emotion: emotion, sentiment: sentiment, date: date, progress: Float(progress));
                    totalUserNotes.append(UserNote)
                }
            }
            self.loadList()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    @IBAction func logOutDidTap(_ sender: UIBarButtonItem) {
        
        try! Auth.auth().signOut()
        self.performSegue(withIdentifier: "ShowWelcome", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItems?.append(addButton)
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
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
                var object = objects[indexPath.row]
                if isSearching {
                    object = filteredObjects[indexPath.row]
                }
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
        if isSearching {
            return filteredObjects.count
        }
        
        return objects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if  isSearching {
            let object = filteredObjects[indexPath.row]
            if( userRole! == "Admin") {
                let index = totalUser.index(where: { (item) -> Bool in
                    item.userID == object.userID // test if this is the item you're looking for
                })
                let user = totalUser[index!]
                let storage = Storage.storage()
                if user.imageURL != "" {
                    print("user.imageURL \(user.imageURL)")
                    storage.reference(forURL: user.imageURL).getMetadata(completion: { (metadata, error) in
                        let userUrl = metadata?.downloadURL()
                        if userUrl != nil {
                            URLSession.shared.dataTask(with: userUrl!, completionHandler: {(data, response,error) in
                                if error != nil {
                                    print(error)
                                    return
                                }
                                DispatchQueue.main.async(execute: {
                                    cell.imageView?.image = UIImage(data: data!)
                                    self.loadList()
                                })
                            } ).resume()
                        }
                    })
                    
                    
                    //cell.imageView?.image = UIImage(named : "scrum")
                }
                cell.textLabel!.text = "Name - \(user.name)"
                cell.detailTextLabel!.text = object.date
            } else
            {
                cell.imageView?.image = nil
                cell.textLabel!.text = "Task No - \(object.taskNo)"
                cell.detailTextLabel!.text = object.date
            }
        }
        else {
            let object = objects[indexPath.row]
            if( userRole! == "Admin") {
                let index = totalUser.index(where: { (item) -> Bool in
                    item.userID == object.userID // test if this is the item you're looking for
                })
                let user = totalUser[index!]
                let storage = Storage.storage()
                if user.imageURL != "" {
                    storage.reference(forURL: user.imageURL).getMetadata(completion: { (metadata, error) in
                        let userUrl = metadata?.downloadURL()
                        if userUrl != nil {
                            URLSession.shared.dataTask(with: userUrl!, completionHandler: {(data, response,error) in
                                if error != nil {
                                    print(error)
                                    return
                                }
                                DispatchQueue.main.async(execute: {
                                    cell.imageView?.image = UIImage(data: data!)
                                    self.loadList()
                                })
                            } ).resume()
                        }
                    })
                    
                    
                    //cell.imageView?.image = UIImage(named : "scrum")
                }
                cell.textLabel!.text = "Name - \(user.name)"
                cell.detailTextLabel!.text = object.date
            } else
            {
                cell.imageView?.image = nil
                cell.textLabel!.text = "Task No - \(object.taskNo)"
                cell.detailTextLabel!.text = object.date
            }
        }
        
       
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if !isSearching {
                let noteID = objects[indexPath.row].noteID
                let userID = objects[indexPath.row].userID
                
                let ref = Database.database().reference()
                let noteRef = ref.child("notes").child(noteID)
                let userRef = ref.child("users").child(userID).child("user_notes").child(noteID)
                noteRef.removeValue { error, _ in
                    print(error)
                }
                userRef.removeValue { error, _ in
                    print(error)
                }
                objects.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else {
                let noteID = filteredObjects[indexPath.row].noteID
                let userID = filteredObjects[indexPath.row].userID
                
                let ref = Database.database().reference()
                let noteRef = ref.child("notes").child(noteID)
                let userRef = ref.child("users").child(userID).child("user_notes").child(noteID)
                noteRef.removeValue { error, _ in
                    print(error)
                }
                userRef.removeValue { error, _ in
                    print(error)
                }
                filteredObjects.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            view.endEditing(true)
            tableView.reloadData()
        } else {
            isSearching = true
            let selectedScope = searchBar.selectedScopeButtonIndex
            
            switch selectedScope {
            case 0:
                
                filteredObjects = objects.filter({userNotes -> Bool in
                    guard let text = searchBar.text else {return false}
                    let taskNoString = String(userNotes.taskNo)
                    return taskNoString.contains(text)
                })
                break
            case 1:
                
                filteredObjects = objects.filter({userNotes -> Bool in
                    guard let text = searchBar.text else {return false}
                    return userNotes.date.contains(text)
                })
                break
            default:
                break
            }
            
            
            tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch selectedScope {
        case 0: searchBar.placeholder = "Search using Task number..."
        case 1: searchBar.placeholder = "Search using Date..."
        default:
            break
        }
        tableView.reloadData()
    }
    
}
