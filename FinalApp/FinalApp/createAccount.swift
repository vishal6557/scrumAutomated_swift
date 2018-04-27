////
////  createAccount.swift
////  FinalApp
////
////  Created by vishal diyora on 4/26/18.
////  Copyright © 2018 vishal diyora. All rights reserved.
////
//
//import UIKit
//
//class createAccount: UITableViewController,UIPickerViewDelegate,UIPickerViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return 0
//    }
//    
//    @IBOutlet weak var confirmPassword: UITextField!
//    
//    @IBOutlet weak var imageView: UIImageView!
//    
//    @IBOutlet weak var createAccountButton: UIButton!
//    @IBOutlet weak var password: UITextField!
//    @IBOutlet weak var userName: UITableViewCell!
//    @IBOutlet weak var fullName: UITextField!
//    @IBOutlet weak var email: UIView!
//    
//    
//    @IBAction func createAccountAction(_ sender: UIButton) {
//        
//    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        imagePicker.delegate = self
//        
//    }
//    
//    //ImagePicker
//    
//    var imagePicker = UIImagePickerController()
//    
//    @IBAction func profilePicture(_ sender: Any) {
//        
//        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
//            print("Button capture")
//            
//            imagePicker.delegate = self
//            imagePicker.modalPresentationStyle = .overCurrentContext
//            imagePicker.sourceType = .photoLibrary;
//            imagePicker.allowsEditing = false
//            
//            
//            self.present(imagePicker, animated: true, completion: nil)
//        }
//    }
//    func imagePickerController(picker: UIImagePickerController!, didFinish image: UIImage!, editingInfo: NSDictionary!){
//        
//    }
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        
//        
//        if let pickedImage = info[UIImagePickerControllerOriginalImage] as?
//            
//            UIImage{
//            imageView.contentMode = .scaleAspectFit
//            imageView.image = pickedImage
//            
//        }
//        dismiss(animated: true, completion: nil)
//    }
//    /*
//    // Only override draw() if you perform custom drawing.
//    // An empty implementation adversely affects performance during animation.
//    override func draw(_ rect: CGRect) {
//        // Drawing code
//    }
//    */
//
//}

