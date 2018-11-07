//
//  LoginViewController.swift
//  ClickerClash
//
//  Created by Caleb Lee on 8/26/18.
//  Copyright © 2018 WithoutAnyLimits. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var loginEmail: UITextField!
    
    @IBOutlet weak var loginPassword: UITextField!
    
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func loginButtonIsPressed(_ sender: UIButton) {
        let email = loginEmail.text
        let password = loginPassword.text
        
        Auth.auth().signIn(withEmail: email!, password: password!) {
            user, error in
            if error == nil && user != nil {
                
                self.performSegue(withIdentifier: "LoginToMainMenuSegue", sender: sender)
                //self.dismiss(animated: false, completion: nil)
            }
            else {
                let alertController = UIAlertController(title: "Error Logging In", message: "Account Doesn't Exist Or Password Is Incorrect", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                print("Error logging in! \(error!.localizedDescription)")
            }
        }
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.isEnabled = false
        loginButton.setTitleColor(UIColor.gray, for: .disabled)

        // Do any additional setup after loading the view.
        loginEmail.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        loginPassword.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        
        loginButton.setTitleColor(UIColor.cyan, for: .normal)
        loginButton.layer.shadowColor = UIColor.cyan.cgColor
        loginButton.clipsToBounds = true
        loginButton.layer.cornerRadius = 11
        self.loginButton.applyGradient(colors: [UIColor.darkGray.cgColor, UIColor.gray.cgColor])
        cancelButton.setTitleColor(UIColor.cyan, for: .normal)
        cancelButton.layer.shadowColor = UIColor.cyan.cgColor
        cancelButton.clipsToBounds = true
        cancelButton.layer.cornerRadius = 11
        self.cancelButton.applyGradient(colors: [UIColor.darkGray.cgColor, UIColor.gray.cgColor])
        
        self.view.bringSubview(toFront: loginEmail)
        self.view.bringSubview(toFront: loginPassword)
        self.view.bringSubview(toFront: loginButton)
        self.view.bringSubview(toFront: cancelButton)
        
       
        
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
            let login = loginEmail.text, !login.isEmpty,
            let password = loginPassword.text, !password.isEmpty
            else {
                loginButton.isEnabled = false
                return
        }
        loginButton.isEnabled = true
        
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
