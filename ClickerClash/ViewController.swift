//
//  ViewController.swift
//  ClickerClash
//
//  Created by Caleb Lee on 8/26/18.
//  Copyright © 2018 WithoutAnyLimits. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {
    
    @IBOutlet weak var login: UIButton!
    
    @IBOutlet weak var signup: UIButton!
    
    var gradient : CAGradientLayer!
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Do any additional setup after loading the view, typically from a nib.
        //login.backgroundColor = UIColor.magenta
        //login.setTitleColor(UIColor.cyan, for: .normal)
        //login.layer.shadowColor = UIColor.cyan.cgColor
        login.clipsToBounds = true
        login.layer.cornerRadius = 11
        //self.login.applyGradient(colors: [UIColor.darkGray.cgColor, UIColor.gray.cgColor])
        
        
        
        /*
        signup.backgroundColor = UIColor.magenta
        signup.setTitleColor(UIColor.cyan, for: .normal)
        signup.layer.shadowColor = UIColor.cyan.cgColor
        */
        signup.clipsToBounds = true
        signup.layer.cornerRadius = 11
        //self.signup.applyGradient(colors: [UIColor.darkGray.cgColor, UIColor.gray.cgColor])

        
        gradient = CAGradientLayer()
        gradient.frame = self.view.bounds
        //gradient.colors = [UIColor.darkGray.cgColor, UIColor.black.cgColor]
        self.view.layer.addSublayer(gradient)
        self.view.bringSubview(toFront: login)
        self.view.bringSubview(toFront: signup)
        self.view.sendSubview(toBack: view)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /*
        if Auth.auth().currentUser != nil {
            
            self.performSegue(withIdentifier: "menuToMainGameSegue", sender: self)
        }
         */
        
    }
    override func viewWillLayoutSubviews() {
        if Auth.auth().currentUser != nil {
            
            self.performSegue(withIdentifier: "menuToMainGameSegue", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }


}
extension UIButton
{
    func applyGradient(colors: [CGColor])
    {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = self.bounds
        self.layer.addSublayer(gradientLayer)
    }
}

/*
extension UIColor {
    func toColor(_ color: UIColor, percentage: CGFloat) -> UIColor {
        let percentage = max(min(percentage, 100), 0) / 100
        switch percentage {
        case 0: return self
        case 1: return color
        default:
            var (r1, g1, b1, a1): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
            var (r2, g2, b2, a2): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
            guard self.getRed(&r1, green: &g1, blue: &b1, alpha: &a1) else { return self }
            guard color.getRed(&r2, green: &g2, blue: &b2, alpha: &a2) else { return self }
            
            return UIColor(red: CGFloat(r1 + (r2 - r1) * percentage),
                           green: CGFloat(g1 + (g2 - g1) * percentage),
                           blue: CGFloat(b1 + (b2 - b1) * percentage),
                           alpha: CGFloat(a1 + (a2 - a1) * percentage))
        }
    }
}
*/
