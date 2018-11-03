//
//  St1PlayGameViewController.swift
//  ClickerClash
//
//  Created by Caleb Lee on 10/7/18.
//  Copyright © 2018 WithoutAnyLimits. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase



class St1PlayGameViewController: UIViewController {
    
    var username = Auth.auth().currentUser?.displayName
    var ref:DatabaseReference?
    //var uid = Auth.auth().currentUser?.uid
    //let pHighScore:Int? = Int(myString)
    var clashHighScore = Int()
    var seconds = 5
    var timecount = Timer()
    var currentCount = -1
    var timeStarted = false
    var newGame = false
    var endDate: Int! = nil
    var timeCount = Timer()
    var currentDate = NSDate().timeIntervalSince1970
    var endGameNow = false
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    
    
    @IBOutlet weak var currentScore: UILabel!
    
    
    
    @IBOutlet weak var timer: UILabel!
    
    
    
    
    
    @IBOutlet weak var playerHighScoreC: UILabel!
    
    
    @IBOutlet weak var s1TimeLeft: UILabel!
    
    @IBOutlet weak var buttonOutlet: UIButton!
    
    
    
    
    @IBAction func button(_ sender: UIButton)
    {
        // Very first click
        if sender.tag == 0 && timeStarted == false{
            currentCount += 1
            currentScore.text = String(currentCount)
            
            timecount = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(counter) , userInfo: nil, repeats: true)
            timeStarted = true
            
        }
        // All other clicks
        if sender.tag == 0 && timeStarted == true {
            currentCount += 1
            currentScore.text = String(currentCount)
            seconds = 5
            timer.text = String(seconds)
            
            
        }
        // First click after Game Over
        if sender.tag == 0 && newGame == true {
            currentCount = 0
            currentCount += 1
            currentScore.text = String(currentCount)
            
            timecount = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(counter) , userInfo: nil, repeats: true)
            
            
            timeStarted = true
            newGame = false
        }
    }
    
    @objc func counter () {
        //STORES WHAT clashhs ACTUALLY IS
        let myString = playerHighScoreC.text
        let myNum:Int? = Int(myString!)
        clashHighScore = myNum!
        seconds -= 1
        timer.text = String(seconds)
        //          GAME OVER               //
        
        if seconds == 0 || endGameNow == true{
            // game over
            let clashHighScoreStart = clashHighScore
            let ref = Database.database().reference()
            timecount.invalidate()
            currentScore.text = String(currentCount)
            print(currentCount)
            let currentCountHere = currentCount
            //newGame = true
            ref.child("tournaments").child("silver").child("st1").child("usersPlaying").observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.hasChild(self.username!){//updating the users score
                    print(currentCountHere)
                    if currentCountHere >= clashHighScoreStart {
                        self.clashHighScore = currentCountHere
                        self.playerHighScoreC.text = String(clashHighScoreStart)//clashHighScore
                        self.currentScore.text = String(currentCountHere)
                        //let uid = Auth.auth().currentUser!.uid
                        let ref = Database.database().reference()
                        let uid = Auth.auth().currentUser!.uid
                        ref.child("tournaments").child("silver").child("st1").child("usersPlaying").child(self.username!).setValue(currentCountHere)
                        print(currentCountHere)
                        print("saving users high score data to st1 tournament users")
                        //CHECK IF USER HASN'T PLAYED BEFORE EVER FOR PERSONAL STAT
                        
                        ref.child("users").child(uid).child("highScore").observeSingleEvent(of: .value, with: {
                            (snapshot) in
                            print(snapshot)
                            let personalValue = snapshot.value as! Int
                            print(personalValue)
                            if currentCountHere >= personalValue {
                                ref.child("users").child(uid).child("highScore").setValue(currentCountHere)
                                print(currentCountHere)
                                print("Updating users personal hs stat")
                                //SAVING TO HIGHSCORE GLOBAL LB
                                ref.child("highScores").child(self.username!).setValue(currentCountHere)
                                print("Saving Users Score to Global LB")

                                
                            }
                            
                        })
                        self.playerHighScoreC.text = String(currentCountHere)

                        self.currentCount = 0
                        //elf.newGame = true
                        //*****
                        
                    }
                }
                else { //FIRST TIME RECORDING SCORE IN USERS PLAYING
                    if currentCountHere >= clashHighScoreStart {
                        self.clashHighScore = currentCountHere
                        self.playerHighScoreC.text = String(clashHighScoreStart)
                        
                        self.currentScore.text = String(currentCountHere)
                        let uid = Auth.auth().currentUser!.uid
                        let ref = Database.database().reference()
                    ref.child("tournaments").child("silver").child("st1").child("usersPlaying").child(self.username!).setValue(currentCountHere)
                        print("saving users high score data to st1 users for first time")
                        //CHECK IF USER HASN'T PLAYED BEFORE EVER FOR PERSONAL STAT
                        ref.child("users").child(uid).child("highScore").observeSingleEvent(of: .value, with: {
                            (snapshot) in
                            //print(snapshot)
                            let personalValue = snapshot.value as! Int
                            if currentCountHere >= personalValue {
                                ref.child("users").child(uid).child("highScore").setValue(currentCountHere)
                                print("Updating users personal hs stat")
                                //SAVING TO HIGHSCORE GLOBAL LB
                                ref.child("highScores").child(self.username!).setValue(currentCountHere)
                                print("Saving Users Score to Global LB")
                            }
                            
                        })
                        self.playerHighScoreC.text = String(currentCountHere)

                       self.currentCount = 0
                        //self.newGame = true
                        //****
                    }
                    
                }
            })
            //ref.child("tournaments").child("silver").child("st1").child("usersPlaying").child(username!).observeSingleEvent(of: .value, with: { (snapshot) in
            //let value = snapshot.value as! Int
            //let StringValue = String(value)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                let alertController = UIAlertController(title: "Game Over", message: "Your Tournament High Score is " + String(self.clashHighScore), preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            }
            currentCount = 0
            currentScore.text = String(currentCount)
            self.newGame = true
            if self.endGameNow == true {
            self.buttonOutlet.isEnabled = false
            self.buttonOutlet.setTitleColor(UIColor.darkGray, for: .disabled)
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    //So far changes -> reference db of UsersPlaying and check if user has played if yes pull his value.. ELSE no value
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Auth.auth().currentUser != nil {
            //let uid = Auth.auth().currentUser!.uid
            let ref = Database.database().reference()
            ref.child("tournaments").child("silver").child("st1").child("usersPlaying").observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.hasChild(self.username!){
                    ref.child("tournaments").child("silver").child("st1").child("usersPlaying").child(self.username!).observe(.value, with: {(snapshot) in
                        let value = snapshot.value as? Int
                        if value != nil {
                            let highscore = String(value!)
                            
                            self.playerHighScoreC.text = highscore
                            
                            print("reading st1 score data")
                        }
                            //dont think it will ever reach here...
                        else {
                            print("No st1 highscore found")
                        }
                        
                        
                        
                    })
                }
                else {
                    print("User has no recorded score in st1")
                }
            })
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser != nil{
            usernameLabel.text = Auth.auth().currentUser?.displayName
        }
        let currentDate = Int(NSDate().timeIntervalSince1970)
        print(currentDate)
        let ref = Database.database().reference()
        ref.child("tournaments").child("silver").child("st1").child("endDate").observe(.value, with: {(snapshot) in
            self.endDate = snapshot.value as? Int
            //})
            if currentDate < self.endDate {
                self.timeCount = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.counter2) , userInfo: nil, repeats: true)
                
            }
            else {
                self.s1TimeLeft.text = "Closed"
                self.endGameNow = true
            }
        })
        //Sets String of textbox to Int pHighScore
        
        
    }
    @objc func counter2() {
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
        self.s1TimeLeft.text = timeString(time: timeCount)
        }
        else {
            self.buttonOutlet.isEnabled = false
            self.buttonOutlet.setTitleColor(UIColor .darkGray, for: .disabled)
            print("cant play game end date reached")
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
