//
//  RatesViewController.swift
//  ClickerClash
//
//  Created by Caleb Lee on 1/7/19.
//  Copyright © 2019 WithoutAnyLimits. All rights reserved.
//

import UIKit
import Firebase




class RatesViewController: UIViewController {
    var tabBarIndex: Int?
    
    @IBOutlet weak var st1r1: UILabel!
    @IBOutlet weak var st1r2: UILabel!
    @IBOutlet weak var st1r3: UILabel!
    @IBOutlet weak var st1r4: UILabel!
    @IBOutlet weak var st1r5: UILabel!
    
    @IBOutlet weak var st2r1: UILabel!
    @IBOutlet weak var st2r2: UILabel!
    @IBOutlet weak var st2r3: UILabel!
    @IBOutlet weak var st2r4: UILabel!
    @IBOutlet weak var st2r5: UILabel!
    
    @IBAction func backButton(_ sender: UIButton) {
        self.loadTabBarController(atIndex: 1)
    }
    private func loadTabBarController(atIndex: Int){
        self.tabBarIndex = 1
        self.performSegue(withIdentifier: "stRatesToMenu", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stRatesToMenu"{
            let tabBarVC = segue.destination as! UITabBarController
            tabBarVC.selectedIndex = self.tabBarIndex!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ref = Database.database().reference()
        ref.child("rates").child("st1").child("1st").observe(.value, with: {(snapshot) in
            let value = snapshot.value as! Int
            self.st1r1.text = String(value)
        })
        ref.child("rates").child("st1").child("2nd").observe(.value, with: {(snapshot) in
            let value = snapshot.value as! Int
            self.st1r2.text = String(value)
        })
        ref.child("rates").child("st1").child("3rd").observe(.value, with: {(snapshot) in
            let value = snapshot.value as! Int
            self.st1r3.text = String(value)
        })
        ref.child("rates").child("st1").child("4th").observe(.value, with: {(snapshot) in
            let value = snapshot.value as! Int
            self.st1r4.text = String(value)
        })
        ref.child("rates").child("st1").child("5th").observe(.value, with: {(snapshot) in
            let value = snapshot.value as! Int
            self.st1r5.text = String(value)
        })
        
        // second tourny
        ref.child("rates").child("st2").child("1st").observe(.value, with: {(snapshot) in
            let value = snapshot.value as! Int
            self.st2r1.text = String(value)
        })
        ref.child("rates").child("st2").child("2nd").observe(.value, with: {(snapshot) in
            let value = snapshot.value as! Int
            self.st2r2.text = String(value)
        })
        ref.child("rates").child("st2").child("3rd").observe(.value, with: {(snapshot) in
            let value = snapshot.value as! Int
            self.st2r3.text = String(value)
        })
        ref.child("rates").child("st2").child("4th").observe(.value, with: {(snapshot) in
            let value = snapshot.value as! Int
            self.st2r4.text = String(value)
        })
        ref.child("rates").child("st2").child("5th").observe(.value, with: {(snapshot) in
            let value = snapshot.value as! Int
            self.st2r5.text = String(value)
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
