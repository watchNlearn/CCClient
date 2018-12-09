//
//  ProfileViewController.swift
//  ClickerClash
//
//  Created by Caleb Lee on 11/4/18.
//  Copyright © 2018 WithoutAnyLimits. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD

class ProfileViewController: UIViewController {
    var username = Auth.auth().currentUser?.displayName
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var highScore: UILabel!
    @IBOutlet weak var tournamentWins: UILabel!
    @IBOutlet weak var clashCoins: UILabel!
    @IBOutlet weak var package: UILabel!
    @IBOutlet weak var winMultiplier: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBAction func logoutButton(_ sender: UIButton) {
        try! Auth.auth().signOut()
        //self.dismiss(animated: false, completion: nil)
        self.performSegue(withIdentifier: "profileToMenuSegue", sender: self)
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.show()
        self.username = Auth.auth().currentUser?.displayName
        let uid = Auth.auth().currentUser!.uid
        let ref = Database.database().reference()
        if Auth.auth().currentUser != nil {
            usernameLabel.text = Auth.auth().currentUser?.displayName
        }
        
        ref.child("users").child(uid).child("tWins").observe(.value, with: {(snapshot) in
            let tWins = snapshot.value as? Int
            let tWinsString = String(tWins!)
                self.tournamentWins.text = tWinsString
            
        })
    
        ref.child("clashCoins").observe(.value, with: {(snapshot) in
            if snapshot.hasChild(self.username!) {
                //print("hereee")
                ref.child("clashCoins").child(self.username!).child(uid).child("cc").observe(.value, with: {(snapshot) in
                    let value = snapshot.value as? Int
                    let valueString = String(value!)
                    self.clashCoins.text = valueString
                    
                })
            }
            else{
                self.clashCoins.text = "0"
            }
            
        })
        
        
        ref.child("users").child(uid).child("package").observe(.value, with: {(snapshot) in
            let value = snapshot.value as? String
            if value == "standard" {
                self.package.text = "Standard"
                self.winMultiplier.text = "1x"
                SVProgressHUD.dismiss()
            }
            else {
                self.package.text = "Premium"
                self.winMultiplier.text = "1.15x"
                SVProgressHUD.dismiss()
            }
            
        })
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Auth.auth().currentUser != nil {
            let uid = Auth.auth().currentUser!.uid
            let ref = Database.database().reference()
            ref.child("users").child(uid).child("highScore").observe(.value, with: {(snapshot) in
                let value = snapshot.value as? Int
                if value != nil {
                    let highscore = String(value!)
                    
                    self.highScore.text = highscore
                    
                    print("reading profile score data")
                }
            })
            ref.child("users").child(uid).child("email").observe(.value, with: {(snapshot)
                in
                let emailValue = snapshot.value as? String
                self.emailLabel.text = emailValue
            })
        }
        //SVProgressHUD.dismiss()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
