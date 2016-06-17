//
//  SignInViewController.swift
//  RoutePro
//
//  Created by Alfredo Luco on 24-05-16.
//  Copyright © 2016 citymovil. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController,UIGestureRecognizerDelegate {
    
    //MARK: - IBOutlets
    
    @IBOutlet var patentTextField: UITextField!
    @IBOutlet var passTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TextField settings
        self.patentTextField.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18.0)
        
        //View settings
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "signinWall")!)
        
        //Gesture Recognizers configuration
        
        let dismissGesture = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        dismissGesture.delegate = self
        self.view.addGestureRecognizer(dismissGesture)
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    //MARK: - Selectors
    
    func dismissKeyboard(){
        
        self.view.endEditing(true)
        
    }

    
    //MARK: - User Interaction
    
    @IBAction func SignIn(sender: AnyObject) {
        
        let data = RouteManager()
        
        data.signInDriverById(self.patentTextField.text!,completion: ({
            Void in
            
            self.performSegueWithIdentifier("signInSegue", sender: self)
            
        }))
    }
    
    
}
