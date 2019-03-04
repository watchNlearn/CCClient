//
//  PlayGameViewController.swift
//  ClickerClash
//
//  Created by Caleb Lee on 8/29/18.
//  Copyright © 2018 WithoutAnyLimits. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD


class PlayGameViewController: UIViewController {
    
    var username = Auth.auth().currentUser?.displayName
    var ref:DatabaseReference?
    //var uid = Auth.auth().currentUser?.uid
    //let pHighScore:Int? = Int(myString)
    var pHighScore = Int()
    var seconds = 5
    var timecount = Timer()
    var currentCount = -1
    var timeStarted = false
    var newGame = false
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    
  
    
    @IBOutlet weak var currentScore: UILabel!
    
    
    
    @IBOutlet weak var timer: UILabel!
    
    
    
    
    
    @IBOutlet weak var playerHighScore: UILabel!
    
    
    
    
    
    
    
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
        //var pHighScore = playerHighScore.text
        //STORES WHAT PHIGHSCORE ACTUALLY IS
        //Old way of getting pHighScore
        //let myString = playerHighScore.text
        //let myNum:Int? = Int(myString!)
        let uid = Auth.auth().currentUser!.uid
        let ref = Database.database().reference()
        ref.child("users").child(uid).child("highScore").observe(.value, with: {(snapshot) in
            self.pHighScore = (snapshot.value as? Int)!
            
        })
        //pHighScore = myNum!
        //print(pHighScore)
        seconds -= 1
        timer.text = String(seconds)
        //          GAME OVER               //
        
        if seconds == 0 {                       // game over
            timecount.invalidate()
            currentScore.text = String(currentCount)   //make screen appear game over
            newGame = true
            
            if currentCount >= pHighScore {
                pHighScore = currentCount
                playerHighScore.text = String(pHighScore)
                currentCount = 0
                currentScore.text = String(currentCount)
                //
                
                //let pHighScoreString = String(pHighScore)
                //UserDefaults.standard.setValue(playerHighScore.text, forKey: "highScore")
                let uid = Auth.auth().currentUser!.uid
                let ref = Database.database().reference()
                
                ref.child("users").child(uid).updateChildValues(["highScore": pHighScore])
                print("saving users high score data")
               //more security in writes to leaderboard highScores for now
                ref.child("users").child(uid).child("username").observeSingleEvent(of: .value, with: {
                    (snapshot) in
                    //print(snapshot)
                    let value = snapshot.value as! String
                    if value == self.username {
                        ref.child("highScores").child(self.username!).setValue(self.pHighScore)
                        print("saving users high score data to leaderboard")
                    }
                    
                })
                
    
               // original store values below
                //ref.child("highScores").child(self.username!).setValue(self.pHighScore)
                //print("saving users high score data to leaderboard")
                //original store values ^
                //pulls data from highscores arranges from least to greatest
                /*
                ref.child("highScores").queryOrderedByValue().observe(.value, with: { (snapshot) in
                    for child in snapshot.children {
                        print((child as! DataSnapshot).key)
                        
                        //print(child as! DataSnapshot)
                    }
                    
                })
                */
                
                //ref.child("highScores").child(pHighScoreString).setValue(username)
                //ref.child("highScores").observeSingleEvent(of: .value, with: { (snapshot) in
                //    if snapshot.hasChild(pHighScoreString) {
                        
                //     ref.child("highScores").child(self.username!).setValue(self.pHighScore)

                //        print("updating highscore leaderboard data for user")
                //    }
                //    else {
                        
                        //ref.child("highScores").child(self.username!).setValue([self.pHighScore])
                //        print("saving highscore leaderboard data first time for user")
                //        }
                //    })
                
            }
            let alertController = UIAlertController(title: "Game Over", message: "Your High Score is " + String(pHighScore), preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            //UserDefaults.standard.setValue(playerHighScore.text, forKey: "highScore")
            
            currentCount = 0
            currentScore.text = String(currentCount)
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
        
        //let uid = Auth.auth().currentUser!.uid
        //let ref = Database.database().reference()
      //  let myString = pHighScore
       // playerHighScore.text = String(myString)
        
        

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.show()
        if CheckInternet.Connection(){
            //SVProgressHUD.dismiss()
            print("connected")
            if Auth.auth().currentUser != nil {
                let uid = Auth.auth().currentUser!.uid
                let ref = Database.database().reference()
                ref.child("users").child(uid).child("highScore").observe(.value, with: {(snapshot) in
                    let value = snapshot.value as? Int
                    //let highscore = value!["highScore"] as? String
                    if value != nil {
                        let highscore = String(value!)
                        
                        self.playerHighScore.text = highscore
                        SVProgressHUD.dismiss()
                        print("reading score data vwa")
                    }
                        
                    else {
                        SVProgressHUD.dismiss()
                        print("No highscore found vwa")
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
        playerHighScore.adjustsFontSizeToFitWidth = true
        //playerHighScore.font = playerHighScore.font.withSize(playerHighScore.frame.height * 6/10)
        //playerHighScore.font = playerHighScore.font.withSize(playerHighScore.bounds.height * 0.6)
        currentScore.adjustsFontSizeToFitWidth = true
        //Testing
        //bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        //Live
        bannerView.adUnitID = ""
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        NotificationCenter.default.addObserver(self, selector: #selector(PlayGameViewController.resetTimer), name: NSNotification.Name(rawValue: "ResetTimer"), object: nil)
        //SVProgressHUD.setDefaultMaskType(.custom)
        //SVProgressHUD.show()
        
        if Auth.auth().currentUser != nil{
            //let uid = Auth.auth().currentUser!.uid
            usernameLabel.text = Auth.auth().currentUser?.displayName
            let uid = Auth.auth().currentUser!.uid
            let ref = Database.database().reference()
            ref.child("users").child(uid).child("highScore").observe(.value, with: {(snapshot) in
                let value = snapshot.value as? Int
                //let highscore = value!["highScore"] as? String
                if value != nil {
                    let highscore = String(value!)
                    
                    self.playerHighScore.text = highscore
                    SVProgressHUD.dismiss()
                    print("reading score data vdl")
                }
                    
                else {
                    print("No highscore found vdl")
                }
                
            })
           //line code below, checks what score was
           // print(pHighScore)
           
            
        }
        //Sets String of textbox to Int pHighScore
       
        
        //ref = Database.database().reference()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

