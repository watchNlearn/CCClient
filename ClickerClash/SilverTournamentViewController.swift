//
//  SilverTournamentViewController.swift
//  ClickerClash
//
//  Created by Caleb Lee on 10/3/18.
//  Copyright © 2018 WithoutAnyLimits. All rights reserved.
//  Note SilverTournamentViewController is currently the main TournamentVC
//  Main Implement more Tournament Views in the future

import UIKit
import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD

class SilverTournamentViewController: UIViewController {
    var tabBarIndex: Int?
    var ref: DatabaseReference!
    var st1loadingDone = false
    var st2loadingDone = false
    //var username: String! = nil
    var finishedLoading = false {
        didSet {
            SVProgressHUD.dismiss()
        }
    }
    var hasConnection = false
    var username = Auth.auth().currentUser?.displayName
    var endDate: Int! = nil
    var endDate2: Int! = nil
    var timeCount2 = Timer()
    var timeCount = Timer()
    var currentDate = NSDate().timeIntervalSince1970
    var highScoresArray = [String]()
    var myString: String = ""
    var highScoresArray2 = [String]()
    var myString2: String = ""
    //var timerStarted = false
    //@IBAction func backButton(_ sender: UIButton) {
        //self.dismiss(animated: true, completion: nil)
        //self.performSegue(withIdentifier: "stToMenuSegue", sender: AnyObject.self)
       // self.loadTabBarController(atIndex: 1)
    //}
    
    //--- Silver Tournament 1 UI---//
    @IBOutlet weak var s1TimeLeft: UILabel!
    @IBOutlet weak var s1Status: UILabel!
    @IBOutlet weak var s1currentrankings: UILabel!
    @IBOutlet weak var s1JoinButton: UIButton!
    @IBOutlet weak var s1PlayButton: UIButton!
    //--- Silver Tournament 1 UI---//
    //--- Silver Tournament 2 UI---//
    @IBOutlet weak var s2TimeLeft: UILabel!
    @IBOutlet weak var s2Status: UILabel!
    @IBOutlet weak var s2currentrankings: UILabel!
    @IBOutlet weak var s2JoinButton: UIButton!
    @IBOutlet weak var s2PlayButton: UIButton!
    //--- Silver Tournament 2 UI---//
    /////////////////////////
    // USERNAME Labels ST1 //
    @IBOutlet weak var st1hs1: UILabel!
    @IBOutlet weak var st1hs2: UILabel!
    @IBOutlet weak var st1hs3: UILabel!
    @IBOutlet weak var st1hs4: UILabel!
    @IBOutlet weak var st1hs5: UILabel!
    /////////////////////////
    // USERNAME Score ST1 //
    @IBOutlet weak var st1hs1s: UILabel!
    @IBOutlet weak var st1hs2s: UILabel!
    @IBOutlet weak var st1hs3s: UILabel!
    @IBOutlet weak var st1hs4s: UILabel!
    @IBOutlet weak var st1hs5s: UILabel!
    /////////////////////////
    // USERNAME LABELS ST2 //
    @IBOutlet weak var st2hs1: UILabel!
    @IBOutlet weak var st2hs2: UILabel!
    @IBOutlet weak var st2hs3: UILabel!
    @IBOutlet weak var st2hs4: UILabel!
    @IBOutlet weak var st2hs5: UILabel!
    /////////////////////////
    // USERNAME Scores ST2 //
    @IBOutlet weak var st2hs1s: UILabel!
    @IBOutlet weak var st2hs2s: UILabel!
    @IBOutlet weak var st2hs3s: UILabel!
    @IBOutlet weak var st2hs4s: UILabel!
    @IBOutlet weak var st2hs5s: UILabel!
    /////////////////////////
    
    //
    @IBAction func s1PlayButtonAction(_ sender: UIButton) {
        if finishedLoading == true {
            print("finished loading")
        }
        else{
            print("not finished loading")
        }
    }
    @IBAction func s1JoinButtonAction(_ sender: UIButton) {
        let ref = Database.database().reference()
        ref.child("tournaments").child("standard").child("st1").child("users").child(username!).setValue(true)
    }
    
    
    @IBAction func s2JoinButtonAction(_ sender: UIButton) {
        let ref = Database.database().reference()
        ref.child("tournaments").child("standard").child("st2").child("users").child(username!).setValue(true)

    }
  
    private func loadTabBarController(atIndex: Int){
        self.tabBarIndex = 1
        self.performSegue(withIdentifier: "stToMenuSegue", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stToMenuSegue"{
            let tabBarVC = segue.destination as! UITabBarController
            tabBarVC.selectedIndex = self.tabBarIndex!
        }
    }
    func st1EndDate(){
        let currentDate = Int(NSDate().timeIntervalSince1970)
        let ref = Database.database().reference()
        ref.child("tournaments").child("standard").child("st1").child("endDate").observe(.value, with: {(snapshot) in
            self.endDate = snapshot.value as? Int
            //})
            if currentDate < self.endDate {
                self.timeCount = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.counter) , userInfo: nil, repeats: true)
                //timerStarted = true
                // self.s1Status.text = "Active"
            }
            else {
                print("hello there")
                self.s1TimeLeft.text = "Closed"
                self.s1JoinButton.isEnabled = false
                self.s1JoinButton.isUserInteractionEnabled = false
                self.s1JoinButton.isHidden = false
                self.s1JoinButton.setTitleColor(UIColor.darkGray, for: .disabled)
                self.s1PlayButton.isEnabled = false
                self.s1PlayButton.isUserInteractionEnabled = false
                self.s1PlayButton.isHidden = false
                self.s1PlayButton.setTitleColor(UIColor.darkGray, for: .disabled)
                //SVProgressHUD.dismiss()
                //self.s1Status.text = "Offline"
            }
        })
        print("st1EndDate Done")
    }
    func st2EndDate(){
        let currentDate = Int(NSDate().timeIntervalSince1970)
        let ref = Database.database().reference()
        ref.child("tournaments").child("standard").child("st2").child("endDate").observe(.value, with: {(snapshot) in
            self.endDate2 = snapshot.value as? Int
            //})
            if currentDate < self.endDate2 {
                self.timeCount2 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.counter2) , userInfo: nil, repeats: true)
                //timerStarted = true
                // self.s1Status.text = "Active"
                //self.s2JoinButton.isHidden = false
                //self.s2PlayButton.isHidden = false
                //SVProgressHUD.dismiss()
            }
            else {
                self.s2TimeLeft.text = "Closed"
                self.s2JoinButton.isEnabled = false
                self.s2JoinButton.isUserInteractionEnabled = false
                self.s2JoinButton.isHidden = false
                self.s2JoinButton.setTitleColor(UIColor.darkGray, for: .disabled)
                self.s2PlayButton.isEnabled = false
                self.s2PlayButton.isHidden = false
                self.s2PlayButton.isUserInteractionEnabled = false
                self.s2PlayButton.setTitleColor(UIColor.darkGray, for: .disabled)
                //self.s1Status.text = "Offline"
                //SVProgressHUD.dismiss()
                //comment out for now if change doesnt work comment in!!
            }
        })
        print("st2EndDate Done")
    }
    func st1CurrentRankings(){
        let ref = Database.database().reference()
        ref.child("tournaments").child("standard").child("st1").child("usersPlaying").queryOrderedByValue().queryLimited(toLast: 5).observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            
            for child in snapshot.children {
                //print(snapshot)
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
                    self.st1hs1.text = highScoreOne
                    break
                case 1:
                    let highScoreTwo = self.highScoresArray[1]
                    self.st1hs2.text = highScoreTwo
                    break
                case 2:
                    let highScoreThree = self.highScoresArray[2]
                    self.st1hs3.text = highScoreThree
                    break
                case 3:
                    let highScoreFour = self.highScoresArray[3]
                    self.st1hs4.text = highScoreFour
                    break
                case 4:
                    let highScoreFive = self.highScoresArray[4]
                    self.st1hs5.text = highScoreFive
                    break
                    
                    
                default:
                    break
                }
                
            }
            //print("is it breaking here?")
            //this is outside the for loop
            if self.st1hs1.text != "" {
                let hs1Username = self.st1hs1.text
                ref.child("tournaments").child("standard").child("st1").child("usersPlaying").child(hs1Username!).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as! Int
                    let hs1Value = String(value)
                    self.st1hs1s.text = hs1Value
                    
                })
            }
            if self.st1hs2.text != "" {
                let hs2Username = self.st1hs2.text
                ref.child("tournaments").child("standard").child("st1").child("usersPlaying").child(hs2Username!).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as! Int
                    let hs2Value = String(value)
                    self.st1hs2s.text = hs2Value
                    
                })
            }
            if self.st1hs3.text != "" {
                let hs3Username = self.st1hs3.text
                ref.child("tournaments").child("standard").child("st1").child("usersPlaying").child(hs3Username!).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as! Int
                    let hs3Value = String(value)
                    self.st1hs3s.text = hs3Value
                    
                })
            }
            if self.st1hs4.text != "" {
                let hs4Username = self.st1hs4.text
                ref.child("tournaments").child("standard").child("st1").child("usersPlaying").child(hs4Username!).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as! Int
                    let hs4Value = String(value)
                    self.st1hs4s.text = hs4Value
                    
                })
            }
            if self.st1hs5.text != "" {
                let hs5Username = self.st1hs5.text
                ref.child("tournaments").child("standard").child("st1").child("usersPlaying").child(hs5Username!).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as! Int
                    let hs5Value = String(value)
                    self.st1hs5s.text = hs5Value
                    
                    
                })
            }
            
            
            
            //print("no way it breaks here")
            
            
            
        })
        print("st1CurrentRankings Done")
    }
    func st2CurrentRankings(){
       let ref = Database.database().reference()
    ref.child("tournaments").child("standard").child("st2").child("usersPlaying").queryOrderedByValue().queryLimited(toLast: 5).observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            
            for child in snapshot.children {
                
                if snapshot.value != nil {
                    let key = (child as AnyObject).key as String
                    self.highScoresArray2.append(key)
                    
                }
            }
            self.highScoresArray2 = self.highScoresArray2.reversed()
            // Uncomment below to check if array is working properly
            //print(self.highScoresArray)
            // messing up because expects 10 values but only has 9... so it thinks it has child of empty string
            // for loop to check array count and break out if value DNE
            for i in 0..<10 {
                if i >= self.highScoresArray2.count {
                    break
                }
                
                _ = self.highScoresArray2[i];
                switch i {
                case 0:
                    let highScoreOne = self.highScoresArray2[0]
                    self.st2hs1.text = highScoreOne
                    break
                case 1:
                    let highScoreTwo = self.highScoresArray2[1]
                    self.st2hs2.text = highScoreTwo
                    break
                case 2:
                    let highScoreThree = self.highScoresArray2[2]
                    self.st2hs3.text = highScoreThree
                    break
                case 3:
                    let highScoreFour = self.highScoresArray2[3]
                    self.st2hs4.text = highScoreFour
                    break
                case 4:
                    let highScoreFive = self.highScoresArray2[4]
                    self.st2hs5.text = highScoreFive
                    break
                    
                    
                default:
                    break
                }
                
            }
            //print("is it breaking here?")
            //this is outside the for loop
            if self.st2hs1.text != "" {
                let hs1Username = self.st2hs1.text
                ref.child("tournaments").child("standard").child("st2").child("usersPlaying").child(hs1Username!).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as! Int
                    let hs1Value = String(value)
                    self.st2hs1s.text = hs1Value
                    
                })
            }
            if self.st2hs2.text != "" {
                let hs2Username = self.st2hs2.text
                ref.child("tournaments").child("standard").child("st2").child("usersPlaying").child(hs2Username!).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as! Int
                    let hs2Value = String(value)
                    self.st2hs2s.text = hs2Value
                    
                })
            }
            if self.st2hs3.text != "" {
                let hs3Username = self.st2hs3.text
                ref.child("tournaments").child("standard").child("st2").child("usersPlaying").child(hs3Username!).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as! Int
                    let hs3Value = String(value)
                    self.st2hs3s.text = hs3Value
                    
                })
            }
            if self.st2hs4.text != "" {
                let hs4Username = self.st2hs4.text
                ref.child("tournaments").child("standard").child("st2").child("usersPlaying").child(hs4Username!).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as! Int
                    let hs4Value = String(value)
                    self.st2hs4s.text = hs4Value
                    
                })
            }
            if self.st2hs5.text != "" {
                let hs5Username = self.st2hs5.text
                ref.child("tournaments").child("standard").child("st2").child("usersPlaying").child(hs5Username!).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as! Int
                    let hs5Value = String(value)
                    self.st2hs5s.text = hs5Value
                    
                    
                })
            }
            
            //print("no way it breaks here")
            
            
            
        })
        print("st2CurrentRankings Done")
    }
    func st1JoinPlay(){
        let ref = Database.database().reference()
        ref.child("tournaments").child("standard").child("st1").child("users").observeSingleEvent(of: .value, with: {(snapshot) in
            print(snapshot)
            //print(self.s1TimeLeft.text)
            print(self.username!)
            if snapshot.hasChild(self.username!) && self.s1TimeLeft.text != "Closed" {
                self.s1JoinButton.isEnabled = false
                self.s1JoinButton.setTitleColor(UIColor.darkGray, for: .disabled)
                self.s1PlayButton.isEnabled = true
                self.s1PlayButton.isUserInteractionEnabled = true
                //unhide
                self.s1JoinButton.isHidden = false
                self.s1PlayButton.isHidden = false
                print("yes??")
            }
            else if self.s1TimeLeft.text != "Closed" {
                self.s1JoinButton.isEnabled = true
                self.s1JoinButton.isUserInteractionEnabled = true
                self.s1PlayButton.isEnabled = false
                self.s1PlayButton.setTitleColor(UIColor.darkGray, for: .disabled)
                //unhide
                self.s1JoinButton.isHidden = false
                self.s1PlayButton.isHidden = false
                
                
            }
            
            if snapshot.hasChild(self.username!) && self.s1TimeLeft.text == "Closed"{
                self.s1JoinButton.isEnabled = false
                self.s1JoinButton.setTitleColor(UIColor.darkGray, for: .disabled)
                
                self.s1PlayButton.isEnabled = false
                //self.s1PlayButton.isHidden = false
                self.s1PlayButton.setTitleColor(UIColor.darkGray, for: .disabled)
                print("or here")
                //unhide
                self.s1JoinButton.isHidden = false
                self.s1PlayButton.isHidden = false
                print("yes????")
            }
            
            
            
            
        })
        print("st1JoinPlay Done")
        st1loadingDone = true
    }
    func st2JoinPlay(){
        let ref = Database.database().reference()
        ref.child("tournaments").child("standard").child("st2").child("users").observeSingleEvent(of: .value, with: {(snapshot) in
            
            if snapshot.hasChild(self.username!) && self.s2TimeLeft.text != "Closed" {
                self.s2JoinButton.isEnabled = false
                self.s2JoinButton.setTitleColor(UIColor.darkGray, for: .disabled)
                self.s2PlayButton.isEnabled = true
                self.s2PlayButton.isUserInteractionEnabled = true
                //unhide
                self.s2JoinButton.isHidden = false
                self.s2PlayButton.isHidden = false
                print("here??.")
            }
            else if self.s2TimeLeft.text != "Closed" {
                self.s2JoinButton.isEnabled = true
                self.s2JoinButton.isUserInteractionEnabled = true
                self.s2PlayButton.isEnabled = false
                self.s2PlayButton.setTitleColor(UIColor.darkGray, for: .disabled)
                //unhide
                self.s2JoinButton.isHidden = false
                self.s2PlayButton.isHidden = false
                
            }
            
            if snapshot.hasChild(self.username!) && self.s2TimeLeft.text == "Closed"{
                self.s2JoinButton.isEnabled = false
                self.s2JoinButton.setTitleColor(UIColor.darkGray, for: .disabled)
                
                self.s2PlayButton.isEnabled = false
                self.s2PlayButton.setTitleColor(UIColor.darkGray, for: .disabled)
                print("or here")
                //unhide
                self.s2JoinButton.isHidden = false
                self.s2PlayButton.isHidden = false
            }
            
            
        })
        print("st2JoinPlay Done")
        st2loadingDone = true
        //SVProgressHUD.dismiss()
    }
    func st1and2Status(){
        let ref = Database.database().reference()
        ref.child("tournaments").child("standard").child("st1").child("status").observe(.value, with: {(snapshot) in
            let status = snapshot.value as! String
            if status == "online" {
                self.s1Status.text = "Online"
            }
            if status == "restarting"{
                self.s1Status.text = "Restarting"
            }
            if status == "offline" {
                self.s1Status.text = "Offline"
            }
        })
        //Status//s2
        //added s2status restarting
        ref.child("tournaments").child("standard").child("st2").child("status").observe(.value, with: {(snapshot) in
            let status = snapshot.value as! String
            if status == "online" {
                self.s2Status.text = "Online"
            }
            if status == "restarting"{
                self.s2Status.text = "Restarting"
            }
            if status == "offline" {
                self.s2Status.text = "Offline"
            }
        })
        print("st1 and st2 status Done")
    }
    
    func disableButtons(){
        self.s1PlayButton.isUserInteractionEnabled = false
        self.s1JoinButton.isUserInteractionEnabled = false
        self.s2PlayButton.isUserInteractionEnabled = false
        self.s2JoinButton.isUserInteractionEnabled = false
        self.s1JoinButton.isEnabled = false
        self.s1PlayButton.isEnabled = false
        self.s2JoinButton.isEnabled = false
        self.s2PlayButton.isEnabled = false
    }
    func unhideButtons(){
        self.s1PlayButton.isHidden = false
    }
    
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        s1currentrankings.adjustsFontSizeToFitWidth = true
        s2currentrankings.adjustsFontSizeToFitWidth = true
        self.username = Auth.auth().currentUser?.displayName
        SVProgressHUD.setDefaultMaskType(.custom)
        
        //SVProgressHUD.setForegroundColor(UIColor.green)
        //SVProgressHUD.setBackgroundColor(UIColor.yellow)
        //SVProgressHUD.setBackgroundLayerColor(UIColor.orange)
        //SVProgressHUD.show(withStatus: "Loading...")
        SVProgressHUD.show()
        disableButtons()
        //Set buttons to disabled and then make active
        let currentDate = Int(NSDate().timeIntervalSince1970)
        print(currentDate)
        st1EndDate()
        st2EndDate()
        st1and2Status()
        st1CurrentRankings()
        st2CurrentRankings()
        st1JoinPlay()
        st2JoinPlay()
        print("bool done")
        //finishedLoading = true
        //SVProgressHUD.dismiss()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
  

        
      
        
        // Do any additional setup after loading the view.
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //disableButtons()
       
        if self.st1hs1.text == self.username {
            st1hs1.layer.borderColor = UIColor.orange.cgColor
            st1hs1.layer.borderWidth = 1.0
        }
        if self.st1hs2.text == self.username {
            st1hs2.layer.borderColor = UIColor.orange.cgColor
            st1hs2.layer.borderWidth = 1.0
        }
        if self.st1hs3.text == self.username {
            st1hs3.layer.borderColor = UIColor.orange.cgColor
            st1hs3.layer.borderWidth = 1.0
        }
        if self.st1hs4.text == self.username {
            st1hs4.layer.borderColor = UIColor.orange.cgColor
            st1hs4.layer.borderWidth = 1.0
        }
        if self.st1hs5.text == self.username {
            st1hs5.layer.borderColor = UIColor.orange.cgColor
            st1hs5.layer.borderWidth = 1.0
        }
        if self.st2hs1.text == self.username {
            st2hs1.layer.borderColor = UIColor.orange.cgColor
            st2hs1.layer.borderWidth = 1.0
        }
        if self.st2hs2.text == self.username {
            st2hs2.layer.borderColor = UIColor.orange.cgColor
            st2hs2.layer.borderWidth = 1.0
        }
        if self.st2hs3.text == self.username {
            st2hs3.layer.borderColor = UIColor.orange.cgColor
            st2hs3.layer.borderWidth = 1.0
        }
        if self.st2hs4.text == self.username {
            st2hs4.layer.borderColor = UIColor.orange.cgColor
            st2hs4.layer.borderWidth = 1.0
        }
        if self.st2hs5.text == self.username {
            st2hs5.layer.borderColor = UIColor.orange.cgColor
            st2hs5.layer.borderWidth = 1.0
        }
        
        
        
        
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func counter() {
        let currentDate = Int(NSDate().timeIntervalSince1970)
            let timeLeft = self.endDate - currentDate
        var timeCount:TimeInterval = TimeInterval(timeLeft)
        if timeLeft >= 0 {
        func timeString(time:TimeInterval) -> String {
            let hours = Int(time) / 3600
            let minutes = Int(time) / 60 % 60
            let seconds = Int(time) % 60
            return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
            }
            
        self.s1TimeLeft.text = timeString(time: timeCount)
            //SVProgressHUD.dismiss()
        }
        else {
            print("hello?")
            self.timeCount.invalidate()
            self.s1TimeLeft.text = "Closed"
            print("counter closed")
            self.s1PlayButton.isEnabled = false
            self.s1JoinButton.isEnabled = false
            self.s1PlayButton.setTitleColor(UIColor .darkGray, for: .disabled)
            self.s1JoinButton.setTitleColor(UIColor .darkGray, for: .disabled)
            //SVProgressHUD.dismiss()
        }
    }
    @objc func counter2() {
        let currentDate = Int(NSDate().timeIntervalSince1970)
        let timeLeft = self.endDate2 - currentDate
        var timeCount2:TimeInterval = TimeInterval(timeLeft)
        if timeLeft >= 0 {
            func timeString(time:TimeInterval) -> String {
                let hours = Int(time) / 3600
                let minutes = Int(time) / 60 % 60
                let seconds = Int(time) % 60
                return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
            }
           
                self.s2TimeLeft.text = timeString(time: timeCount2)
            
            if CheckInternet.Connection(){
                //SVProgressHUD.dismiss()
                //comment out for now if doesnt work comment in!!
                self.hasConnection = true
                print("connected")
            }
            else{
                //because it is on timer constantly checking for internet connection
                self.hasConnection = false
                SVProgressHUD.setDefaultMaskType(.custom)
                SVProgressHUD.show(withStatus: "Attempting To Reconnect")
                print("No connection")
            }
                //SVProgressHUD.dismiss()
            
        }
        else {
            self.timeCount2.invalidate()
            self.s2TimeLeft.text = "Closed"
            print("counter 2 closed")
            self.s2PlayButton.isEnabled = false
            self.s2JoinButton.isEnabled = false
            self.s2PlayButton.setTitleColor(UIColor .darkGray, for: .disabled)
            self.s2JoinButton.setTitleColor(UIColor .darkGray, for: .disabled)
           // SVProgressHUD.dismiss()
        }
        if self.st1hs1.text != "" && self.st2hs1.text != "" && self.hasConnection == true {
            print("this is finishedLoading Check")
            finishedLoading = true
        }
    }

    
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600,(seconds % 3600) / 60,(seconds % 3600) % 60)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("leaving the tourny view")
        //timeCount.invalidate()
        //timeCount2.invalidate()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("did leave the tourny view")
        //timeCount.invalidate()
        //timeCount2.invalidate()
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
