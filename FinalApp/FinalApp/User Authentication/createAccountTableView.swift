//
//  createAccountTableView.swift
//  FinalApp
//
//  Created by vishal diyora on 4/26/18.
//  Copyright © 2018 vishal diyora. All rights reserved.
//

import UIKit
import Firebase

class createAccountTableView: UITableViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate {

    
    @IBOutlet weak var imageViewPic: UIImageView!
    @IBOutlet weak var userType: UITextField!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    var imagePicker = UIImagePickerController()
    
    var profilePic: UIImage!
      let pickerView = UIPickerView();
    let userTypes = [ "Admin", "User" ]
  
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        //pickerView
      
        pickerView.delegate = self
        pickerView.dataSource = self
        userType.inputView = pickerView
        
    }
   
    
    
    //Back
    
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion:nil)
    }
    
    
    //Picker for UserType
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
     func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return userTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return userTypes[row]
    }
    var datas:String?
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
    
    //Checking Validation
    func checkValidation() ->Bool{
        
        let userTypeData = userType.text!
        let emailAddressData:String = emailAddress.text!
        let nameData:String = name.text ?? "nil"
        let passwordData:String =  password.text ?? "nil"
        let confirmPasswordData:String =  confirmPassword.text ?? "nil"
        let profilePicData = self.profilePic
        //empty validation
        if(emailAddressData.isEmpty || nameData.isEmpty || userTypeData.isEmpty || passwordData.isEmpty || confirmPasswordData.isEmpty ) {
            displayAlert(title: "Field Empty", message: "All field must be filled for Create User")
            return true
        }
        else if (profilePicData == nil){
            
            displayAlert(title: "Profile Picture", message: "Please add profile picture to continue")
            return true
        }
            //email validation
        else if(!validateEmail(emailAddressString: emailAddressData)){
            displayAlert(title: "Email Incorrect", message: "Email is invalid")
            return true
        }
            //password should be more than 6 characters
        else if (passwordData.count < 6)
        {
            displayAlert(title: "Password", message: "Password cannot be less than 6 characters")
            return true
        }
            //password match validation
        else if (passwordData != confirmPasswordData){
            displayAlert(title: "Password not match", message: "Password and Confirm Password should be same")
            return true
        }
        return false;
    }
    
    //Create Account

    @IBAction func registerUser(_ sender: UIButton) {

        let userTypeData = userType.text!
        let emailAddressData:String = emailAddress.text!
        let nameData:String = name.text ?? "nil"
        let passwordData:String =  password.text ?? "nil"
        let confirmPasswordData:String =  confirmPassword.text ?? "nil"
        let profilePicData = self.profilePic
        
        if(checkValidation()){
            print("Validation done")
        }
        
        
            
            //sigin starts from here
        else{
            Auth.auth().createUser(withEmail: emailAddressData, password: passwordData, completion: {(firUser, error) in
                if error != nil {
                    //Error
                    let newerror = error! as NSError
                    
                    displayAlert(title:newerror.userInfo["error_name"] as! String , message: (error?.localizedDescription)!)
                    
                } else if let firUser = firUser {
                    let newUser = User(name: nameData, emailAddress: emailAddressData, userType: userTypeData, userID: firUser.uid, profileImage: profilePicData!)
                    newUser.save(completion: {(error) in
                        if error != nil {
                            print("No its here",error)
                        } else {
                            displayAlert(title: "Successfull", message: "You have successfully signed in  Press + button to start adding notes")
                            //Successfully Signed up new account
                            self.dismiss(animated: false, completion: nil)
                        }
                    })
                }
            })
            
        }
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
        dismiss(animated: true, completion: nil)
    }
    
}

//check validation

//Common Validation
func displayAlert(title:String, message:String){
    
    
    let attributedString = NSAttributedString(string: title, attributes: [
        NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15), //your font here
        NSAttributedStringKey.foregroundColor : UIColor(red: 46/255, green: 96/255, blue: 255/255, alpha: 1)
        ])
    let attributedStringMess = NSAttributedString(string: message, attributes: [
        NSAttributedStringKey.font : UIFont.systemFont(ofSize: 13), //your font here
        NSAttributedStringKey.foregroundColor : UIColor.red
        ])
    let alert = UIAlertController(title: title, message: message,  preferredStyle: .alert)
    alert.setValue(attributedString, forKey: "attributedTitle")
    alert.setValue(attributedStringMess, forKey: "attributedMessage")
    let ok = UIAlertAction(title: "OK", style: .cancel, handler: { (action) -> Void in })
    alert.addAction(ok)
    alert.show()
}

