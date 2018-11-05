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

class ProfileViewController: UIViewController {
    
    
    @IBAction func logoutButton(_ sender: UIButton) {
        try! Auth.auth().signOut()
        //self.dismiss(animated: false, completion: nil)
        self.performSegue(withIdentifier: "profileToMenuSegue", sender: self)
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
