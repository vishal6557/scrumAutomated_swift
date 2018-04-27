//
//  createAccountTableView.swift
//  FinalApp
//
//  Created by vishal diyora on 4/26/18.
//  Copyright © 2018 vishal diyora. All rights reserved.
//

import UIKit
import Firebase

class createAccountTableView: UITableViewController,UIPickerViewDelegate,UIPickerViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        //pickerView
        pickerView.delegate = self
        pickerView.dataSource = self
        userType.inputView = pickerView
    }
    @IBOutlet weak var imageViewPic: UIImageView!
    @IBOutlet weak var userType: UITextField!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    var imagePicker = UIImagePickerController()
    
    var profilePic: UIImage!
    
    
    //Back
    
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion:nil)
    }
    
    //Picker for UserType
    
    let userTypes = ["Admin", "User"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
        
    }
    
    var pickerView = UIPickerView();
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return userTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return userTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        userType.text = userTypes[row]
        userType.resignFirstResponder()
    }
    
    @IBAction func selectImage(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
    
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
    
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
           /*If you want work actionsheet on ipad
         then you have to use popoverPresentationController to present the actionsheet,
         otherwise app will crash on iPad */
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
           alert.popoverPresentationController?.sourceView = sender
            alert.popoverPresentationController?.sourceRect = sender.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        alert.show()
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.modalPresentationStyle = .overCurrentContext
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.modalPresentationStyle = .overCurrentContext
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    //Create Account

    @IBAction func registerUser(_ sender: UIButton) {

        let userTypeData = userType.text ?? "" as! String
        let emailAddressData:String = emailAddress.text!
        let nameData:String = name.text ?? "nil"
        let passwordData:String =  password.text ?? "nil"
        let confirmPasswordData:String =  confirmPassword.text ?? "nil"
        let profilePicData = self.profilePic
        
        if(emailAddressData == nil || nameData == nil || (userTypeData ?? "").isEmpty || (passwordData ?? "").isEmpty || (confirmPasswordData ?? "").isEmpty || profilePicData == nil) {
   
            let alert = UIAlertController(title: "title", message: "message", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel, handler: { (action) -> Void in })
            alert.addAction(ok)
            alert.show()
        }
        else
        {
            Auth.auth().createUser(withEmail: emailAddressData, password: passwordData, completion: {(firUser, error) in
                if error != nil {
                    //Error
                    print(error)
                } else if let firUser = firUser {
                    let newUser = User(name: nameData, emailAddress: emailAddressData, userType: userTypeData, userID: firUser.uid, profileImage: profilePicData!)
                    newUser.save(completion: {(error) in
                        if error != nil {
                            print(error)
                        } else {
                            //Successfully Signed up new account
                            //Log into app
                            Auth.auth().signIn(withEmail: emailAddressData, password: passwordData, completion: {(firUser, error) in
                                if let error = error {
                                    print(error)
                                } else {
                                    self.dismiss(animated: false, completion: nil)
                                }
                            })
                            
                        }
                    })
                }
            })
            
        }
        
//        validationFunction(emailAddressData:String,nameData:String,userTypeData:String,passwordData:String,confirmPasswordData:String)
        
        
        
        print("Inside registerUser")
    }

}

func validationFunction(emailAddressData:String,nameData:String,userTypeData:String,passwordData:String,confirmPasswordData:String){
    
}

extension createAccountTableView:  UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        /*
         Get the image from the info dictionary.
         If no need to edit the photo, use `UIImagePickerControllerOriginalImage`
        instead of `UIImagePickerControllerEditedImage`
         */
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            self.imageViewPic.image = editedImage
            self.profilePic = editedImage
        }
        //Dismiss the UIImagePicker after selection
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Cancelled")
    }
    
}
