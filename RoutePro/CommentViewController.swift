//
//  CommentViewController.swift
//  RoutePro
//
//  Created by Alfredo Luco on 14-06-16.
//  Copyright © 2016 citymovil. All rights reserved.
//

import UIKit
import CoreLocation
import RealmSwift

class CommentViewController: UIViewController,UITextViewDelegate,UIGestureRecognizerDelegate {
    
    //MARK: - Global variables
    var detailSelected: String? = nil
    var statusSelected: String? = nil
    var driver: Vehicle? = nil
    var locationAssociated: Location? = nil
    var vehicleCoordinates: CLLocation? = nil
    
    //MARK: - IBOutlets
    @IBOutlet var commentTextView: UITextView!
    @IBOutlet var sendButton: UIBarButtonItem!
    @IBOutlet var commentLabel: UILabel!
    
    //MARK: - Constraints associated
    @IBOutlet var topConstraint: NSLayoutConstraint!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - View Settings
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "signatureWall")!)
        self.navigationController?.navigationBar.barStyle = .Black
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.commentLabel.textColor = UIColor.whiteColor()
        self.commentTextView.layer.cornerRadius = 5
        self.commentTextView.clipsToBounds = true
        
        //MARK: - Configuration
        
        //Button Initial Status
        self.sendButton.enabled = false
        
        //Comment Text View Configuration
        self.commentTextView.delegate = self
        
        //Getting Driver data
        let realm = try! Realm()
        self.driver = realm.objects(Vehicle).first
        
        //Gesture Recognizers
        
        let dismissGesture = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        dismissGesture.delegate = self
        self.view.addGestureRecognizer(dismissGesture)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - TextView Delegate
    
    func textViewDidBeginEditing(textView: UITextView) {
        
        //Adjust Layout
        self.view.layoutIfNeeded()
        
        //setup the constrint
        
        self.topConstraint.constant = 320
        
        //Enable/Disable button when there's a comment
        if(self.commentTextView.text != ""){
            self.sendButton.enabled = true
        }else{
            self.sendButton.enabled = false
        }
        
        //setting up an animation
        UIView.animateWithDuration(1, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        
        //IDEM
        
        self.view.layoutIfNeeded()
        
        self.topConstraint.constant = 20
        
        if(self.commentTextView.text != ""){
            self.sendButton.enabled = true
        }else{
            self.sendButton.enabled = false
        }
        
        UIView.animateWithDuration(1, animations: {
            
            self.view.layoutIfNeeded()
        
        })
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        //IDEM
        if(self.commentTextView.text != ""){
            self.sendButton.enabled = true
        }else{
            self.sendButton.enabled = false
        }
        return true
    }
    
    
    //MARK: - User Interaction
    
    @IBAction func sendData(sender: AnyObject) {
        
        let data = RouteManager()
        data.pushClientConfirmation(self.driver!.getId(), customerId: self.locationAssociated!.Customer, statusDelivery: self.statusSelected!, detailDelivery: self.detailSelected!, commentsDelivery: self.commentTextView.text, coordinates: self.vehicleCoordinates!, completion: {
            
            let currentIndex = self.navigationController?.viewControllers.indexOf(self)
            
            self.navigationController?.popToViewController((self.navigationController?.viewControllers[currentIndex!-3])!, animated: true)
            
        })
        
    }
    
    //MARK: - Selectors
    
    func dismissKeyboard(){
        self.view.endEditing(true)
    }
    

}
