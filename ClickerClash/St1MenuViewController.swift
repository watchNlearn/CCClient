//
//  St1MenuViewController.swift
//  ClickerClash
//
//  Created by Caleb Lee on 10/5/18.
//  Copyright © 2018 WithoutAnyLimits. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase

class St1MenuViewController: UIViewController {
    var tabBarIndex: Int?
    var ref: DatabaseReference!
    var username: String! = nil
    var endDate: Int! = nil
    var timeCount = Timer()
    var currentDate = NSDate().timeIntervalSince1970
    var highScoresArray = [String]()
    var myString: String = ""
    
    @IBOutlet weak var usersScore: UILabel!
    @IBOutlet weak var st1TimeLeft: UILabel!
    @IBOutlet weak var clashButton: UIButton!
    //ST1 USERNAME LABELS//
    @IBOutlet weak var hs1: UILabel!
    @IBOutlet weak var hs2: UILabel!
    @IBOutlet weak var hs3: UILabel!
    @IBOutlet weak var hs4: UILabel!
    @IBOutlet weak var hs5: UILabel!
    @IBOutlet weak var hs6: UILabel!
    @IBOutlet weak var hs7: UILabel!
    @IBOutlet weak var hs8: UILabel!
    @IBOutlet weak var hs9: UILabel!
    @IBOutlet weak var hs10: UILabel!
    //ST1 USERNAME SCORE LABELS//
    @IBOutlet weak var hs1s: UILabel!
    @IBOutlet weak var hs2s: UILabel!
    @IBOutlet weak var hs3s: UILabel!
    @IBOutlet weak var hs4s: UILabel!
    @IBOutlet weak var hs5s: UILabel!
    @IBOutlet weak var hs6s: UILabel!
    @IBOutlet weak var hs7s: UILabel!
    @IBOutlet weak var hs8s: UILabel!
    @IBOutlet weak var hs9s: UILabel!
    @IBOutlet weak var hs10s: UILabel!
    /////////////////////////////
    
    @IBAction func backButton(_ sender: UIButton) {
        self.loadTabBarController(atIndex: 1)
    }
    
    private func loadTabBarController(atIndex: Int){
        self.tabBarIndex = 1
        self.performSegue(withIdentifier: "st1ToMenuSegue", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "st1ToMenuSegue"{
            let tabBarVC = segue.destination as! UITabBarController
            tabBarVC.selectedIndex = self.tabBarIndex!
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //11/10/18
        self.clashButton.isEnabled = false
        print("hic")
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        let currentDate = Int(NSDate().timeIntervalSince1970)
        //get username function
        ref.child("users").child(uid!).child("username").observe(.value, with: {(snapshot)
            in
            self.username = snapshot.value as? String
        })
        ref.child("tournaments").child("standard").child("st1").child("endDate").observe(.value, with: {(snapshot) in
            self.endDate = snapshot.value as? Int
            //})
            if currentDate < self.endDate {
                self.timeCount = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.counter) , userInfo: nil, repeats: true)
                //timerStarted = true
            }
            else {
                self.st1TimeLeft.text = "Closed"
                self.clashButton.isEnabled = false
                self.clashButton.setTitleColor(UIColor.darkGray, for: .disabled)
            }
        })
        ref.child("tournaments").child("standard").child("st1").child("usersPlaying").observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.hasChild(self.username!) {
                ref.child("tournaments").child("standard").child("st1").child("usersPlaying").child(self.username).observeSingleEvent(of: .value, with: {(snapshot) in
                    let usersScoreInt = snapshot.value as! Int
                    let usersScoreString = String(usersScoreInt)
                    self.usersScore.text = usersScoreString
                })
                
            }
            else {
                self.usersScore.text = "0"
            }
        })
        // SILVER TOURNAMENT ONE CURRENT RANKINGS
        ref.child("tournaments").child("standard").child("st1").child("usersPlaying").queryOrderedByValue().queryLimited(toLast: 10).observeSingleEvent(of: .value, with: { (snapshot) in
            
            for child in snapshot.children {
               
                if snapshot.value != nil {
                    let key = (child as AnyObject).key as String
                    
                    self.highScoresArray.append(key)
                    
                }
            }
            self.highScoresArray = self.highScoresArray.reversed()
            // Uncomment below to check if array is working properly
            //print(self.highScoresArray)
            // messing up because expects 10 values but only has 9... so it thinks it has child of empty string
            // for loop to check array count and break out if value DNE
            for i in 0..<10 {
                if i >= self.highScoresArray.count {
                    break
                }
                
                _ = self.highScoresArray[i];
                switch i {
                case 0:
                    let highScoreOne = self.highScoresArray[0]
                    self.hs1.text = highScoreOne
                    break
                case 1:
                    let highScoreTwo = self.highScoresArray[1]
                    self.hs2.text = highScoreTwo
                    break
                case 2:
                    let highScoreThree = self.highScoresArray[2]
                    self.hs3.text = highScoreThree
                    break
                case 3:
                    let highScoreFour = self.highScoresArray[3]
                    self.hs4.text = highScoreFour
                    break
                case 4:
                    let highScoreFive = self.highScoresArray[4]
                    self.hs5.text = highScoreFive
                    break
                case 5:
                    let highScoreSix = self.highScoresArray[5]
                    self.hs6.text = highScoreSix
                    break
                case 6:
                    let highScoreSeven = self.highScoresArray[6]
                    self.hs7.text = highScoreSeven
                    break
                case 7:
                    let highScoreEight = self.highScoresArray[7]
                    self.hs8.text = highScoreEight
                    break
                case 8:
                    let highScoreNine = self.highScoresArray[8]
                    self.hs9.text = highScoreNine
                    break
                case 9:
                    let highScoreTen = self.highScoresArray[9]
                    self.hs10.text = highScoreTen
                    break
                    
                default:
                    break
                }
                
            }
            //print("is it breaking here?")
            //this is outside the for loop
            if self.hs1.text != "" {
                let hs1Username = self.hs1.text
                ref.child("tournaments").child("standard").child("st1").child("usersPlaying").child(hs1Username!).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as! Int
                    let hs1Value = String(value)
                    self.hs1s.text = hs1Value
                    
                })
            }
            if self.hs2.text != "" {
                let hs2Username = self.hs2.text
                ref.child("tournaments").child("standard").child("st1").child("usersPlaying").child(hs2Username!).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as! Int
                    let hs2Value = String(value)
                    self.hs2s.text = hs2Value
                    
                })
            }
            if self.hs3.text != "" {
                let hs3Username = self.hs3.text
                ref.child("tournaments").child("standard").child("st1").child("usersPlaying").child(hs3Username!).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as! Int
                    let hs3Value = String(value)
                    self.hs3s.text = hs3Value
                    
                })
            }
            if self.hs4.text != "" {
                let hs4Username = self.hs4.text
                ref.child("tournaments").child("standard").child("st1").child("usersPlaying").child(hs4Username!).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as! Int
                    let hs4Value = String(value)
                    self.hs4s.text = hs4Value
                    
                })
            }
            if self.hs5.text != "" {
                let hs5Username = self.hs5.text
                ref.child("tournaments").child("standard").child("st1").child("usersPlaying").child(hs5Username!).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as! Int
                    let hs5Value = String(value)
                    self.hs5s.text = hs5Value
                    
                    
                })
            }
            if self.hs6.text != "" {
                let hs6Username = self.hs6.text
                ref.child("tournaments").child("standard").child("st1").child("usersPlaying").child(hs6Username!).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as! Int
                    let hs6Value = String(value)
                    self.hs6s.text = hs6Value
                    
                })
            }
            if self.hs7.text != "" {
                let hs7Username = self.hs7.text
                ref.child("tournaments").child("standard").child("st1").child("usersPlaying").child(hs7Username!).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as! Int
                    let hs7Value = String(value)
                    self.hs7s.text = hs7Value
                    
                })
            }
            if self.hs8.text != "" {
                let hs8Username = self.hs8.text
                ref.child("tournaments").child("standard").child("st1").child("usersPlaying").child(hs8Username!).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as! Int
                    let hs8Value = String(value)
                    self.hs8s.text = hs8Value
                    
                })
            }
            if self.hs9.text != "" {
                let hs9Username = self.hs9.text
                ref.child("tournaments").child("standard").child("st1").child("usersPlaying").child(hs9Username!).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as! Int
                    let hs9Value = String(value)
                    self.hs9s.text = hs9Value
                    
                })
            }
            //print("is it breaking right here?")
            if self.hs10.text != "" {
                //print("no way it breaks here")
                let hs10Username = self.hs10.text
                ref.child("tournaments").child("standard").child("st1").child("usersPlaying").child(hs10Username!).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as! Int
                    let hs10Value = String(value)
                    self.hs10s.text = hs10Value
                    
                })
            }
            //print("no way it breaks here")
            
            
            
        })
        ref.child("tournaments").child("standard").child("st1").child("users").observe(.value, with: {(snapshot) in
            
            if snapshot.hasChild(self.username!) {
                self.clashButton.isEnabled = true
                //self.clashButton.setTitleColor(UIColor.darkGray, for: .disabled)
               
            }
            else{
                self.clashButton.isEnabled = false
                self.clashButton.setTitleColor(UIColor.darkGray, for: .disabled)
            }
            
            
            
        })
        
        
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.hs1.text == self.username {
            hs1.layer.borderColor = UIColor.orange.cgColor
            hs1.layer.borderWidth = 1.0
        }
        if self.hs2.text == self.username {
            hs2.layer.borderColor = UIColor.orange.cgColor
            hs2.layer.borderWidth = 1.0
        }
        if self.hs3.text == self.username {
            hs3.layer.borderColor = UIColor.orange.cgColor
            hs3.layer.borderWidth = 1.0
        }
        if self.hs4.text == self.username {
            hs4.layer.borderColor = UIColor.orange.cgColor
            hs4.layer.borderWidth = 1.0
        }
        if self.hs5.text == self.username {
            hs5.layer.borderColor = UIColor.orange.cgColor
            hs5.layer.borderWidth = 1.0
        }
        if self.hs6.text == self.username {
            hs6.layer.borderColor = UIColor.orange.cgColor
            hs6.layer.borderWidth = 1.0
        }
        if self.hs7.text == self.username {
            hs7.layer.borderColor = UIColor.orange.cgColor
            hs7.layer.borderWidth = 1.0
        }
        if self.hs8.text == self.username {
            hs8.layer.borderColor = UIColor.orange.cgColor
            hs8.layer.borderWidth = 1.0
        }
        if self.hs9.text == self.username {
            hs9.layer.borderColor = UIColor.orange.cgColor
            hs9.layer.borderWidth = 1.0
        }
        if self.hs10.text == self.username {
            hs10.layer.borderColor = UIColor.orange.cgColor
            hs10.layer.borderWidth = 1.0
        }
    }
    
    
    @objc func counter() {
        let currentDate = Int(NSDate().timeIntervalSince1970)
        let timeLeft = endDate - currentDate
        var timeCount:TimeInterval = TimeInterval(timeLeft)
        if timeLeft >= 0 {

        func timeString(time:TimeInterval) -> String {
            let hours = Int(time) / 3600
            let minutes = Int(time) / 60 % 60
            let seconds = Int(time) % 60
            return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
        }
        self.st1TimeLeft.text = timeString(time: timeCount)
        }
        else{
            self.timeCount.invalidate()
            self.st1TimeLeft.text = "Closed"
            self.clashButton.isEnabled = false
            self.clashButton.setTitleColor(UIColor.darkGray, for: .disabled)
        
        }
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
