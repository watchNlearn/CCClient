//
//  TournamentViewController.swift
//  ClickerClash
//
//  Created by Caleb Lee on 10/2/18.
//  Copyright © 2018 WithoutAnyLimits. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class TournamentViewController: UIViewController {
    var ref: DatabaseReference!
    var legendary = "legendary"
    var challenger = "challenger"
    var diamond = "diamond"
    var gold = "gold"
    var silver = "silver"
    
    
    @IBOutlet weak var legendaryButton: UIButton!
    @IBOutlet weak var challengerButton: UIButton!
    @IBOutlet weak var diamondButton: UIButton!
    @IBOutlet weak var goldButton: UIButton!
    @IBOutlet weak var silverButton: UIButton!
           
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser!.uid
        
        ref.child("users").child(uid).child("rank").observe(.value, with: {(snapshot)in
            let value = snapshot.value as! String
            if value == self.silver {
                self.silverButton.isEnabled = true
                self.goldButton.isEnabled = false
                self.goldButton.setTitleColor(UIColor .darkGray, for: .disabled)
                self.diamondButton.isEnabled = false
                self.diamondButton.setTitleColor(UIColor .darkGray, for: .disabled)
                self.challengerButton.isEnabled = false
                self.challengerButton.setTitleColor(UIColor .darkGray, for: .disabled)
                self.legendaryButton.isEnabled = false
                self.legendaryButton.setTitleColor(UIColor .darkGray, for: .disabled)

            }
            
            if value == self.gold {
                self.silverButton.isEnabled = true
                self.goldButton.isEnabled = true
                self.goldButton.setTitleColor(UIColor .darkGray, for: .disabled)
                self.diamondButton.isEnabled = false
                self.diamondButton.setTitleColor(UIColor .darkGray, for: .disabled)
                self.challengerButton.isEnabled = false
                self.challengerButton.setTitleColor(UIColor .darkGray, for: .disabled)
                self.legendaryButton.isEnabled = false
                self.legendaryButton.setTitleColor(UIColor .darkGray, for: .disabled)
            }
        
            if value == self.diamond {
                self.silverButton.isEnabled = true
                self.goldButton.isEnabled = true
                self.goldButton.setTitleColor(UIColor .darkGray, for: .disabled)
                self.diamondButton.isEnabled = true
                self.diamondButton.setTitleColor(UIColor .darkGray, for: .disabled)
                self.challengerButton.isEnabled = false
                self.challengerButton.setTitleColor(UIColor .darkGray, for: .disabled)
                self.legendaryButton.isEnabled = false
                self.legendaryButton.setTitleColor(UIColor .darkGray, for: .disabled)
            }
            if value == self.challenger {
                self.silverButton.isEnabled = true
                self.goldButton.isEnabled = true
                self.goldButton.setTitleColor(UIColor .darkGray, for: .disabled)
                self.diamondButton.isEnabled = true
                self.diamondButton.setTitleColor(UIColor .darkGray, for: .disabled)
                self.challengerButton.isEnabled = true
                self.challengerButton.setTitleColor(UIColor .darkGray, for: .disabled)
                self.legendaryButton.isEnabled = false
                self.legendaryButton.setTitleColor(UIColor .darkGray, for: .disabled)
                
            }
            if value == self.legendary {
                self.silverButton.isEnabled = true
                self.goldButton.isEnabled = true
                self.goldButton.setTitleColor(UIColor .darkGray, for: .disabled)
                self.diamondButton.isEnabled = true
                self.diamondButton.setTitleColor(UIColor .darkGray, for: .disabled)
                self.challengerButton.isEnabled = true
                self.challengerButton.setTitleColor(UIColor .darkGray, for: .disabled)
                self.legendaryButton.isEnabled = true
                self.legendaryButton.setTitleColor(UIColor .darkGray, for: .disabled)
            }
            
            
        })
        
        //goldButton.isEnabled = false
        
        
        //Colors
        legendaryButton.setTitleColor(UIColor .orange, for: .normal)
        self.legendaryButton.applyGradient(colors: [UIColor.orange.cgColor, UIColor.clear.cgColor, UIColor.orange.cgColor])
        //challengerButton.setTitleColor(UIColor .purple, for: .normal)
        self.challengerButton.applyGradient(colors: [UIColor.clear.cgColor, UIColor.blue.cgColor])
        //diamondButton.setTitleColor(UIColor .blue, for: .normal)
        self.diamondButton.applyGradient(colors: [UIColor.cyan.cgColor, UIColor.clear.cgColor])
        //goldButton.setTitleColor(UIColor .red, for: .normal)
        self.goldButton.applyGradient(colors: [UIColor.clear.cgColor, UIColor.yellow.cgColor])
        //silverButton.setTitleColor(UIColor .lightGray, for: .normal)
        self.silverButton.applyGradient(colors: [UIColor.gray.cgColor, UIColor.clear.cgColor])
        self.view.bringSubview(toFront: legendaryButton)
        self.view.bringSubview(toFront: challengerButton)
        self.view.bringSubview(toFront: diamondButton)
        self.view.bringSubview(toFront: goldButton)
        self.view.bringSubview(toFront: silverButton)
        
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
