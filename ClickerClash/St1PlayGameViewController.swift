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
import GoogleMobileAds
import SVProgressHUD


class St1PlayGameViewController: UIViewController, GADInterstitialDelegate {
    
    var username = Auth.auth().currentUser?.displayName
    var ref:DatabaseReference?
    var interstitial: GADInterstitial!
    //var uid = Auth.auth().currentUser?.uid
    //let pHighScore:Int? = Int(myString)
    var finishedLoading = false {
        didSet {
            print("UI is updated")
            SVProgressHUD.dismiss()
        }
    }
    var eventDidHappen = false
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
    
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    
    @IBOutlet weak var currentScore: UILabel!
    
    
    
    @IBOutlet weak var timer: UILabel!
    
    
    
    
    
    @IBOutlet weak var playerHighScoreC: UILabel!
    
    
    @IBOutlet weak var s1TimeLeft: UILabel!
    
    @IBOutlet weak var buttonOutlet: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    
    
    
    @IBAction func button(_ sender: UIButton)
    {
        self.backButton.isEnabled = false
        self.backButton.setTitleColor(UIColor .gray, for: .disabled)
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
            ref.child("tournaments").child("standard").child("st1").child("usersPlaying").observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.hasChild(self.username!){//updating the users score
                    print(currentCountHere)
                    if currentCountHere >= clashHighScoreStart {
                        self.clashHighScore = currentCountHere
                        self.playerHighScoreC.text = String(clashHighScoreStart)//clashHighScore
                        self.currentScore.text = String(currentCountHere)
                        //let uid = Auth.auth().currentUser!.uid
                        let ref = Database.database().reference()
                        let uid = Auth.auth().currentUser!.uid
                        ref.child("tournaments").child("standard").child("st1").child("usersPlaying").child(self.username!).setValue(currentCountHere)
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
                    ref.child("tournaments").child("standard").child("st1").child("usersPlaying").child(self.username!).setValue(currentCountHere)
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
            presentAd()
            //ref.child("tournaments").child("silver").child("st1").child("usersPlaying").child(username!).observeSingleEvent(of: .value, with: { (snapshot) in
            //let value = snapshot.value as! Int
            //let StringValue = String(value)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                let alertController = UIAlertController(title: "Game Over", message: "Your Tournament High Score is " + String(self.clashHighScore), preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            self.backButton.isEnabled = true

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
    @objc func resetTimer(){
        currentCount = 0
        currentScore.text = String(currentCount)
        seconds = 0
        timer.text = String(seconds)
        timecount.invalidate()
        newGame = true
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        
    }
    //So far changes -> reference db of UsersPlaying and check if user has played if yes pull his value.. ELSE no value
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.show()
        
        if CheckInternet.Connection(){
            //SVProgressHUD.dismiss()
            print("connected")
            if Auth.auth().currentUser != nil {
                //let uid = Auth.auth().currentUser!.uid
                let ref = Database.database().reference()
                ref.child("tournaments").child("standard").child("st1").child("usersPlaying").observeSingleEvent(of: .value, with: { (snapshot) in
                    if snapshot.hasChild(self.username!){
                        ref.child("tournaments").child("standard").child("st1").child("usersPlaying").child(self.username!).observe(.value, with: {(snapshot) in
                            let value = snapshot.value as? Int
                            if value != nil {
                                let highscore = String(value!)
                                
                                self.playerHighScoreC.text = highscore
                                print("reading st1 score data")
                                //comment out for now
                                //SVProgressHUD.dismiss()
                            }
                                //dont think it will ever reach here...
                            /*
                            else {
                                print("No st1 highscore found")
                                SVProgressHUD.dismiss()
                            }
                            */
                            
                            
                        })
                    }
                    else {
                        self.playerHighScoreC.text = "0"
                        print("User has no recorded score in st1")
                        //comment out for now
                        //SVProgressHUD.dismiss()
                    }
                })
            }
        }
        else{
            print("No connection")
        }
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //Testing
        //bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        //Live
        bannerView.adUnitID = "ca-app-pub-5347695699689963/7391857366"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        //Testing
        //interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        //Live
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-5347695699689963/2833003200")
        let request = GADRequest()
        interstitial.load(request)
        interstitial.delegate = self
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(St1PlayGameViewController.resetTimer), name: NSNotification.Name(rawValue: "ResetTimer"), object: nil)
        if Auth.auth().currentUser != nil{
            usernameLabel.text = Auth.auth().currentUser?.displayName
        }
        let currentDate = Int(NSDate().timeIntervalSince1970)
        print(currentDate)
        let ref = Database.database().reference()
        ref.child("tournaments").child("standard").child("st1").child("endDate").observe(.value, with: {(snapshot) in
            self.endDate = snapshot.value as? Int
            //})
            if currentDate < self.endDate {
                self.timeCount = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.counter2) , userInfo: nil, repeats: true)
                //comment out for now
                //SVProgressHUD.dismiss()
            }
            else {
                self.s1TimeLeft.text = "Closed"
                self.endGameNow = true
                //comment out for now
                //SVProgressHUD.dismiss()
            }
        })
        //Sets String of textbox to Int pHighScore
        
        
    }
    func createAndLoadInterstitial() -> GADInterstitial {
        //Testing
        //let interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        //Live
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-5347695699689963/2833003200")
        //interstitial.delegate = self as? GADInterstitialDelegate
        interstitial.load(GADRequest())
        interstitial.delegate = self
        return interstitial
    }
    
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        print("Ad presented")
    }
    func presentAd() {
        if self.interstitial.isReady {
            self.interstitial.present(fromRootViewController: self)
            interstitial = createAndLoadInterstitial()
            
        } else {
            print("Ad wasn't ready")
        }
    }
    

    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        print("Ad dismissed")
        SVProgressHUD.dismiss()
        //DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
        let alertController = UIAlertController(title: "Game Over", message: "Your Tournament High Score is " + (self.playerHighScoreC.text!), preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
        
        //}
        //interstitial = createAndLoadInterstitial()
        interstitial.load(GADRequest())
        print("heyy")
        
        
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
        if self.playerHighScoreC.text != nil && self.eventDidHappen == false {
            finishedLoading = true
            eventDidHappen = true
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("leaving st1 view")
        //self.timeCount.invalidate()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
