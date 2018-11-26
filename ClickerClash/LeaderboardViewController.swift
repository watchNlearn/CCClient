//
//  LeaderboardViewController.swift
//  ClickerClash
//
//  Created by Caleb Lee on 9/9/18.
//  Copyright © 2018 WithoutAnyLimits. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD

class LeaderboardViewController: UIViewController {
    var ref: DatabaseReference!
    
    
    
    
    
    //------ USERNAME LABELS-------//
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
    //------ USERNAME SCORES-------//
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
    //------       END      -------//

   
    
     //var leaderboardResults = [String]()
    var highScoresArray = [String]()
    var myString: String = ""
    
    //public typealias JSON = [String : AnyObject]

//table view
    
    func updateLeaderboard(){
        let ref = Database.database().reference()
        
        //var leaderboardResults = [String]()
        // Do any additional setup after loading the view.
        
        ref.child("highScores").queryOrderedByValue().queryLimited(toLast: 10).observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            self.highScoresArray = []
            for child in snapshot.children {
                // let test = snapshot.value as? [String:AnyObject]
                //let users = child as! DataSnapshot
                //print(child)
                //let test = child as! Data
                //let value = snapshot.value as? NSDictionary
                if snapshot.value != nil {
                    let key = (child as AnyObject).key as String
                    
                    //print((child as! DataSnapshot).key)
                    //self.highScoresArray.append(key)*
                    self.highScoresArray.insert(key, at: 0)
                    //print(self.highScoresArray)
                    
                }
                //self.highScoresArray = self.highScoresArray.reversed()
            }
            //self.highScoresArray = self.highScoresArray.reversed()*
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
                ref.child("highScores").child(hs1Username!).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as! Int
                    let hs1Value = String(value)
                    self.hs1s.text = hs1Value
                    
                })
            }
            if self.hs2.text != "" {
                let hs2Username = self.hs2.text
                ref.child("highScores").child(hs2Username!).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as! Int
                    let hs2Value = String(value)
                    self.hs2s.text = hs2Value
                    
                })
            }
            if self.hs3.text != "" {
                let hs3Username = self.hs3.text
                ref.child("highScores").child(hs3Username!).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as! Int
                    let hs3Value = String(value)
                    self.hs3s.text = hs3Value
                    
                })
            }
            if self.hs4.text != "" {
                let hs4Username = self.hs4.text
                ref.child("highScores").child(hs4Username!).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as! Int
                    let hs4Value = String(value)
                    self.hs4s.text = hs4Value
                    
                })
            }
            if self.hs5.text != "" {
                let hs5Username = self.hs5.text
                ref.child("highScores").child(hs5Username!).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as! Int
                    let hs5Value = String(value)
                    self.hs5s.text = hs5Value
                    
                    
                })
            }
            if self.hs6.text != "" {
                let hs6Username = self.hs6.text
                ref.child("highScores").child(hs6Username!).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as! Int
                    let hs6Value = String(value)
                    self.hs6s.text = hs6Value
                    
                })
            }
            if self.hs7.text != "" {
                let hs7Username = self.hs7.text
                ref.child("highScores").child(hs7Username!).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as! Int
                    let hs7Value = String(value)
                    self.hs7s.text = hs7Value
                    
                })
            }
            if self.hs8.text != "" {
                let hs8Username = self.hs8.text
                ref.child("highScores").child(hs8Username!).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as! Int
                    let hs8Value = String(value)
                    self.hs8s.text = hs8Value
                    
                })
            }
            if self.hs9.text != "" {
                let hs9Username = self.hs9.text
                ref.child("highScores").child(hs9Username!).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as! Int
                    let hs9Value = String(value)
                    self.hs9s.text = hs9Value
                    
                })
            }
            //print("is it breaking right here?")
            if self.hs10.text != "" {
                //print("no way it breaks here")
                let hs10Username = self.hs10.text
                ref.child("highScores").child(hs10Username!).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as! Int
                    let hs10Value = String(value)
                    self.hs10s.text = hs10Value
                    
                })
            }
            //print("no way it breaks here")
            
            SVProgressHUD.dismiss()
            
        })
        
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //updateLeaderboard()
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.show()
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateLeaderboard()
        
        //print("hi")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
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
extension Collection {
    
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
