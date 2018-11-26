//
//  SignUpViewController.swift
//  ClickerClash
//
//  Created by Caleb Lee on 8/26/18.
//  Copyright © 2018 WithoutAnyLimits. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD

class SignUpViewController: UIViewController {
    
    var ref: DatabaseReference!
    // Textbox Labels
   
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var passwordLabel: UILabel!
    
    
    // Textbox Labels
    @IBOutlet weak var signupUsername: UITextField!
    
    @IBOutlet weak var signupEmail: UITextField!
    
    @IBOutlet weak var signupPassword: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBAction func signupButtonIsPressed(_ sender: UIButton) {
        
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.show(withStatus: "Creating Account...")
        
        ref = Database.database().reference()
        let username = signupUsername.text?.trimmingCharacters(in: .whitespaces)
        let email = signupEmail.text?.trimmingCharacters(in: .whitespaces)
        let password = signupPassword.text?.trimmingCharacters(in: .whitespaces)
        //let userID = Auth.auth().
        //if username != exisrting username {
        //ref.child("usernames").observe(.value, with: {(snapshot) in
        ref.child("usernames").observeSingleEvent(of: .value, with: { (snapshot) in
        
            //let value = snapshot.value as? String
            //print(value)
            if snapshot.hasChild(username!) {
                SVProgressHUD.dismiss()
                let alertController = UIAlertController(title: "Error Creating User", message: "Username Already Exists", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                //print("existing username?")
                //print("new username?")
                //print("is it checking un?")
                
            }
            else {
                
                print("new user name")
                Auth.auth().createUser(withEmail: email!, password: password!) {
                    user, error in
                    
                    
                    if error == nil && user != nil{
                        
                        print("User Created")
                        
                        let uid = Auth.auth().currentUser!.uid
                        let ref = Database.database().reference()
                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        //let userID = Auth.auth().currentUser!.uid
                        
                        
                        
                        changeRequest?.displayName = username
                        changeRequest?.commitChanges {
                            error in
                            if error == nil {
                                //ref.child("usernames").setValue(["username": username, "uid": uid])
                                
                                print("User's display name changed")
                                //self.dismiss(animated: false, completion: nil)
                            }
                            
                            
                        }
                        //i can do this
                        ref.child("usernames").child(username!).setValue(uid)
                        // to set cc coin upon creating account
                        //ref.child("clashCoins").child(username!).child(uid).child("cc").setValue(0)
                        ref.child("users").child(uid).setValue(["email": email, "username": username])
                        ref.child("users").child(uid).child("package").setValue("standard")
                        ref.child("users").child(uid).child("highScore").setValue(0)
                        ref.child("users").child(uid).child("tWins").setValue(0)
                        print("here?")
                        SVProgressHUD.dismiss()
                        self.performSegue(withIdentifier: "SignUpToMainMenuSegue", sender: sender)
                        
                        
                    }
                    else {
                        SVProgressHUD.dismiss()
                        let alertController = UIAlertController(title: "Error Creating User", message: "\(error!.localizedDescription)", preferredStyle: UIAlertControllerStyle.alert)
                        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alertController, animated: true, completion: nil)
                        print("Error creating user: \(error!.localizedDescription)")
                    }
                    
                    
                    
                }
            }
            
        })
        
    }

   
        override func viewDidLoad() {
        super.viewDidLoad()
        signupButton.isEnabled = false
        signupButton.setTitleColor(UIColor.gray, for: .disabled)
        signupUsername.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        signupEmail.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        signupPassword.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        
        // Do any additional setup after loading the view.
            //signupButton.setTitleColor(UIColor.cyan, for: .normal)
            //signupButton.layer.shadowColor = UIColor.cyan.cgColor
            signupButton.clipsToBounds = true
            signupButton.layer.cornerRadius = 11
            //self.signupButton.applyGradient(colors: [UIColor.darkGray.cgColor, UIColor.gray.cgColor])
            //cancelButton.setTitleColor(UIColor.cyan, for: .normal)
            //cancelButton.layer.shadowColor = UIColor.cyan.cgColor
            cancelButton.clipsToBounds = true
            cancelButton.layer.cornerRadius = 11
            //self.cancelButton.applyGradient(colors: [UIColor.darkGray.cgColor, UIColor.gray.cgColor])
            
            self.view.bringSubview(toFront: usernameLabel)
            self.view.bringSubview(toFront: emailLabel)
            self.view.bringSubview(toFront: passwordLabel)
            self.view.bringSubview(toFront: signupUsername)
            self.view.bringSubview(toFront: signupEmail)
            self.view.bringSubview(toFront: signupPassword)
            self.view.bringSubview(toFront: signupButton)
            self.view.bringSubview(toFront: cancelButton)
            self.view.sendSubview(toBack: view)
            
       
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func editingChanged(_ textField: UITextField){
        
        if textField.text?.characters.count == 1 {
            if textField.text?.characters.first == " "{
                textField.text = ""
                return
            }
        }
        guard
            let login = signupUsername.text, !login.isEmpty,
            let email = signupEmail.text, !email.isEmpty,
            let password = signupPassword.text, !password.isEmpty
            
            else {
                signupButton.isEnabled = false
                return
                
        }
    
        signupButton.isEnabled = true
       
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

