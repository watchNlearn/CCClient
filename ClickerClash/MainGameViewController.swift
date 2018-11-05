//
//  MainGameViewController.swift
//  ClickerClash
//
//  Created by Caleb Lee on 8/26/18.
//  Copyright © 2018 WithoutAnyLimits. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase




class MainGameViewController: UITabBarController {
    var ref: DatabaseReference!
    @IBInspectable var defaultIndex: Int = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = defaultIndex
        // Do any additional setup after loading the view.
        // 
        
        
        
        
        //Color Buttons Setups//
        /*
        logoutButtonOutlet.setTitleColor(UIColor.cyan, for: .normal)
        logoutButtonOutlet.layer.shadowColor = UIColor.cyan.cgColor
        logoutButtonOutlet.clipsToBounds = true
        logoutButtonOutlet.layer.cornerRadius = 11
        self.logoutButtonOutlet.applyGradient(colors: [UIColor.darkGray.cgColor, UIColor.gray.cgColor])
        playButton.clipsToBounds = true
        playButton.layer.cornerRadius = 11
        
        tournamentsButton.setTitleColor(UIColor.cyan, for: .normal)
        tournamentsButton.layer.shadowColor = UIColor.cyan.cgColor
        tournamentsButton.clipsToBounds = true
        tournamentsButton.layer.cornerRadius = 11
        self.tournamentsButton.applyGradient(colors: [UIColor.red.cgColor, UIColor.orange.cgColor])
        leaderboardButton.clipsToBounds = true
        leaderboardButton.layer.cornerRadius = 11
        
        
        
        self.view.bringSubview(toFront: logoutButtonOutlet)
        self.view.bringSubview(toFront: playButton)
        self.view.bringSubview(toFront: tournamentsButton)
        self.view.bringSubview(toFront: leaderboardButton)
        //CHECK IF THIS WORKS LATER!!!!!!!!!
        let uid = Auth.auth().currentUser!.uid
        let ref = Database.database().reference()
        ref.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild("highScore"){
                self.tournamentsButton.isEnabled = true
            }
            else {
                self.tournamentsButton.isEnabled = false
                self.tournamentsButton.setTitleColor(UIColor .darkGray, for: .disabled)
                self.tournamentsButton.setTitle("Must Play Game First!", for: .disabled)
            }
        })
        
    }

    @IBAction func logoutButton(_ sender: UIButton) {
        try! Auth.auth().signOut()
        //self.dismiss(animated: false, completion: nil)
        self.performSegue(withIdentifier: "mainGameToMenuSegue", sender: self)
    }
    
    */
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
