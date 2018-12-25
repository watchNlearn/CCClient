//
//  PlayGameMenuViewController.swift
//  ClickerClash
//
//  Created by Caleb Lee on 11/11/18.
//  Copyright © 2018 WithoutAnyLimits. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase


class PlayGameMenuViewController: UIViewController {
    @IBOutlet weak var alertBannerMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ref = Database.database().reference()
        
        ref.child("notify").child("alertMessage").observe(.value, with: {(snapshot) in
            let AlertMessage = snapshot.value as! String
            if AlertMessage == "" {
                self.alertBannerMessage.text = nil
            }
            else {
                self.alertBannerMessage.text = AlertMessage
            }
            
        })
        // Do any additional setup after loading the view.
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
