//
//  LoginViewController.swift
//  Recipes-App
//
//  Created by Omar Muniz on 11/15/22.
//

import UIKit
import Parse
class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        testParseConnection()
        self.usernameField.delegate = self
        self.passwordField.delegate = self
        // Do any additional setup after loading the view.
    }
    func testParseConnection(){
        let myObj = PFObject(className:"FirstClass")
        myObj["message"] = "Hey ! First message from Swift. Parse is now connected"
        myObj.saveInBackground { (success, error) in
            if(success){
                print("You are connected!")
            }else{
                print("An error has occurred!")
            }
        }
    }
    //Dismiss keyboard function
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    //Dismiss keyboard when pressing Return key
    //make sure to also have self.textField1.delegate in viewDidLoad()
    //got this from https://www.youtube.com/watch?v=YCxeWL9q18o
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        return true
    }
    
    @IBAction func onSignIn(_ sender: Any) {
        let username = self.usernameField.text!
        let password = self.passwordField.text!
        
        PFUser.logInWithUsername(inBackground: username,password: password) {
          (user: PFUser?, error: Error?) -> Void in
          if user != nil {
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
            print("signed in")
          } else {
              print("Error: \(String(describing: error?.localizedDescription))")
          }
        }
        
    }
    
    @IBAction func onSignup(_ sender: Any) {
        let user = PFUser()
        user.username = self.usernameField.text
        user.password = self.passwordField.text
        
        
        user.signUpInBackground {(success,error) in
            
            if success {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                print("Error: \(String(describing: error?.localizedDescription))")
            }
//            if let error = error {
//                self.displayAlert(withTitle: "Error", message: error.localizedDescription)
//            } else {
//                self.displayAlert(withTitle: "Success", message: "Account has been successfully created")
//            }
        }
    }

}
