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
    var ccValue = 0
    
    @IBOutlet weak var paypalButtonOut: UIButton!
    @IBAction func paypalButton(_ sender: UIButton) {
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.show()
        
            if ccValue >= 1000 {
                SVProgressHUD.dismiss()
                
                let alertController1 = UIAlertController(title: "Confirmation", message: "Spend 1000 CC?", preferredStyle: UIAlertControllerStyle.alert)
                alertController1.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    print("Continue")
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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.paypalButtonOut.isEnabled = false
        //self.paypalButtonOut.setTitleColor(UIColor.gray, for: .disabled)

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let ref = Database.database().reference()
        ref.child("clashCoins").child(self.username!).child(uid).child("cc").observe(.value, with: {(snapshot) in
            self.ccValue = snapshot.value as! Int
            
            
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
