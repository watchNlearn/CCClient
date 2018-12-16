//
//  ShopViewController.swift
//  ClickerClash
//
//  Created by Caleb Lee on 11/12/18.
//  Copyright © 2018 WithoutAnyLimits. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD




struct UserInfo: Encodable {
    var username: String
    var uid: String
    var ccValue: Int
    var date: Int
}



class ShopViewController: UIViewController {
    var clientusername = Auth.auth().currentUser?.displayName
    var clientuid = Auth.auth().currentUser!.uid
    var clientccValue = 0
    
    @IBOutlet weak var paypalButtonOut: UIButton!
    @IBAction func paypalButton(_ sender: UIButton) {
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.show()
        
            if clientccValue >= 1000 {
                SVProgressHUD.dismiss()
                
                let alertController1 = UIAlertController(title: "Confirmation", message: "Spend 1000 CC?", preferredStyle: UIAlertControllerStyle.alert)
                alertController1.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    print("Continue")
                    self.sendUserInfoPost()
                }))
                
                alertController1.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (action: UIAlertAction!) in
                    print("Handle Cancel Logic here")
                }))
                self.present(alertController1, animated: true, completion: nil)
            }
            else {
                SVProgressHUD.dismiss()
                let alertController = UIAlertController(title: "Error Purchasing", message: "Not enough Clash Coins", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                print("not enough")
            }
            
    
        
    }
    
    func sendUserInfoPost() {
        guard let url = URL(string: "http://127.0.0.1:8000/payout/postrequest/")else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //guard let httpBody = try? JSONSerialization.data(withJSONObject: sendInformation, options: [])else{return}
        let currentDate = Int(NSDate().timeIntervalSince1970)
        
        
        
        let sendInformation = UserInfo(username: clientusername!, uid: clientuid, ccValue: clientccValue, date: currentDate)
        do {
            let jsonBody = try JSONEncoder().encode(sendInformation)
            let jsonString = String(data: jsonBody, encoding: .utf8)
            print(jsonString as Any)
            request.httpBody = jsonBody
            print(jsonBody)
        }
        catch {}
        let session = URLSession.shared
        session.dataTask(with: request) {(data, response, error)
            in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                    print(json)
                }
                catch {
                    print(error)
                }
            }
            }.resume()
        
    }
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.show()
        if CheckInternet.Connection(){
            SVProgressHUD.dismiss()
            print("connected")
        }
        else{
            print("No connection")
        }
        //self.paypalButtonOut.isEnabled = false
        //self.paypalButtonOut.setTitleColor(UIColor.gray, for: .disabled)

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let ref = Database.database().reference()
        let clientUid = Auth.auth().currentUser?.uid
        let clientUsername = Auth.auth().currentUser?.displayName
        
        ref.child("clashCoins").child(clientUsername!).child(clientUid!).child("cc").observe(.value, with: {(snapshot) in
            self.clientccValue = snapshot.value as! Int
            print("Got Client CC value")
            
            
        })
        
        
        
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
extension UITabBar{
    func inActiveTintColor() {
        if let items = items{
            for item in items{
                item.image =  item.image?.withRenderingMode(.alwaysOriginal)
                item.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.lightGray], for: .normal)
                item.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.blue], for: .selected)
            }
        }
    }
}
