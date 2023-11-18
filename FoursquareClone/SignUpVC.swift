//
//  ViewController.swift
//  FoursquareClone
//
//  Created by Александр Федоткин on 16.11.2023.
//

import UIKit
import Parse

class SignUpVC: UIViewController {
    
    @IBOutlet private weak var userNameText: UITextField!
    @IBOutlet private weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getData()
        
    }
    
    @IBAction func signInClicked(_ sender: Any) {
        
        if userNameText.text != "" && passwordText.text != ""{
            PFUser.logInWithUsername(inBackground: userNameText.text!, password: passwordText.text!) { success, error in
                if error != nil{
                    self.makeAlert(title: "Error", message: error?.localizedDescription as? String ?? "Error")
                } else{
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
        } else{
            makeAlert(title: "Error", message: "Incorrect username/password")
        }
    }
    @IBAction func signUpClicked(_ sender: Any) {
        
        if userNameText.text != "" && passwordText.text != ""{
            let user = PFUser()
            user.username = userNameText.text
            user.password = passwordText.text
            
            user.signUpInBackground { success, error in
                if error != nil{
                    self.makeAlert(title: "Error", message: error?.localizedDescription as? String ?? "Error")
                } else{
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
        } else{
            self.makeAlert(title: "Error!", message: "Incorrect username/password")
        }
    }
    

}

//MARK: - make Alert function
private extension SignUpVC{

    func makeAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.actionSheet)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
}

//MARK: - Test uploading data
private extension SignUpVC{
    
    func uploadData(){
        let parseObject = PFObject(className: "Fruits")
        parseObject["name"] = "Banana"
        parseObject["calories"] = 150
        parseObject.saveInBackground { success, error in
            if error != nil{
                self.makeAlert(title: "Error", message: error?.localizedDescription as? String ?? "Error")
            } else{
                print("Success")
            }
        }
    }
}

//MARK: - Test get Data

private extension SignUpVC{
    
    func getData(){
        let query = PFQuery(className: "Fruits")
        query.whereKey("calories", lessThan: 120)
        query.findObjectsInBackground { objects, error in
            if error != nil{
                self.makeAlert(title: "Error!", message: error?.localizedDescription as? String ?? "Error")
            } else{
                print(objects)
            }
        }
    }
}

