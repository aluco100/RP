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
    
    //global variables
    var detailSelected: String? = nil
    var statusSelected: String? = nil
    var driver: Vehicle? = nil
    var locationAssociated: Location? = nil
    var vehicleCoordinates: CLLocation? = nil
    
    //IBOutlets
    @IBOutlet var commentTextView: UITextView!
    @IBOutlet var sendButton: UIBarButtonItem!
    
    //Constraints associated
    @IBOutlet var topConstraint: NSLayoutConstraint!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sendButton.enabled = false
        
        self.commentTextView.delegate = self
        
        let realm = try! Realm()
        self.driver = realm.objects(Vehicle).first
        
        print("detail: \(self.detailSelected) stat: \(self.statusSelected) driver: \(self.driver?.getId()) location: \(self.locationAssociated?.Address) coords: \(self.vehicleCoordinates?.coordinate)")
        
        let dismissGesture = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        dismissGesture.delegate = self
        self.view.addGestureRecognizer(dismissGesture)
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        
        self.view.layoutIfNeeded()
        
        self.topConstraint.constant = 320
        
        if(self.commentTextView.text != ""){
            self.sendButton.enabled = true
        }else{
            self.sendButton.enabled = false
        }
        
        UIView.animateWithDuration(1, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        
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
        if(self.commentTextView.text != ""){
            self.sendButton.enabled = true
        }else{
            self.sendButton.enabled = false
        }
        return true
    }
    
    
    @IBAction func sendData(sender: AnyObject) {
        
        let data = RouteManager()
        data.pushClientConfirmation(self.driver!.getId(), customerId: self.locationAssociated!.Customer, statusDelivery: self.statusSelected!, detailDelivery: self.detailSelected!, commentsDelivery: self.commentTextView.text, coordinates: self.vehicleCoordinates!, completion: {
            
            let currentIndex = self.navigationController?.viewControllers.indexOf(self)
            
            self.navigationController?.popToViewController((self.navigationController?.viewControllers[currentIndex!-3])!, animated: true)
            
        })
        
    }
    
    func dismissKeyboard(){
        self.view.endEditing(true)
    }
    

}
