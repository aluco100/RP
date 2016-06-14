//
//  SignInViewController.swift
//  RoutePro
//
//  Created by Alfredo Luco on 24-05-16.
//  Copyright © 2016 citymovil. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController,UIGestureRecognizerDelegate {
    
    
    @IBOutlet var logBlock: UIView!
    @IBOutlet var patentTextField: UITextField!
    @IBOutlet var passTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logBlock.layer.cornerRadius = 5
        logBlock.layer.masksToBounds = true
        
        let dismissGesture = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        dismissGesture.delegate = self
        self.view.addGestureRecognizer(dismissGesture)
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
