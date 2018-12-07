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

class ShopViewController: UIViewController {
    var username = Auth.auth().currentUser?.displayName
    var uid = Auth.auth().currentUser!.uid

    @IBOutlet weak var paypalButtonOut: UIButton!
    @IBAction func paypalButton(_ sender: UIButton) {
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.show()
        let ref = Database.database().reference()
        ref.child("clashCoins").child(username!).child(uid).child("cc").observe(.value, with: {(snapshot) in
            let ccValue = snapshot.value as! Int
            print(ccValue)
            if ccValue >= 1000 {
                SVProgressHUD.dismiss()
                let alertController1 = UIAlertController(title: "Confirmation", message: "Are you sure you want to spend 1000 CC?", preferredStyle: UIAlertControllerStyle.alert)
                alertController1.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController1, animated: true, completion: nil)
            }
            else {
                SVProgressHUD.dismiss()
                let alertController = UIAlertController(title: "Error Purchasing", message: "Not enough Clash Coins", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                print("not enough")
            }
            
            
            
            
        })
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.paypalButtonOut.isEnabled = false
        //self.paypalButtonOut.setTitleColor(UIColor.gray, for: .disabled)

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
