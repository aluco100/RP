//
//  SignatureViewController.swift
//  RoutePro
//
//  Created by Alfredo Luco on 30-05-16.
//  Copyright © 2016 citymovil. All rights reserved.
//

import UIKit
import CoreLocation
import RealmSwift

class SignatureViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate {

    
    var locationAsociated: Location? = nil
    var vehicleCoordinates: CLLocation? = nil
    var dateTime: NSDate = NSDate()
    
    var statusPickerView = UIPickerView()
    var detailPickerView = UIPickerView()
    
    //Outlets
    @IBOutlet var statusTextField: UITextField!
    @IBOutlet var detailsTextField: UITextField!
    @IBOutlet var commentsTextView: UITextView!
    
    //variables para picker
    let status = ["Entregado","Parcialmente Entregado", "No entregado"]
    let details = ["Falta de tiempo","Preferencia en otro punto","Problemas en el camion","Cierre de caminos","Choque en trayecto","Problemas en indicaciones"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("customer-id:\(locationAsociated!.Customer)")
        
        
        print("Lat: \(vehicleCoordinates!.coordinate.latitude) Lon:\(vehicleCoordinates!.coordinate.longitude)")
        
        //obtener fecha dd-MM-yyyy hh:mm
        
        let dateFormatter : NSDateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.systemLocale()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        print("date: \(dateFormatter.stringFromDate(self.dateTime))")
        
        //Picker View Settings
        self.statusPickerView = UIPickerView(frame: CGRect(x: 0, y: 200, width: view.frame.width, height: 200))
        self.detailPickerView = UIPickerView(frame: CGRect(x: 0, y: 200, width: view.frame.width, height: 200))
        
        self.statusPickerView.delegate = self
        self.statusPickerView.dataSource = self
        self.statusPickerView.showsSelectionIndicator = true
        self.statusPickerView.tag = 1;
        self.detailPickerView.delegate = self
        self.detailPickerView.dataSource = self
        self.detailPickerView.showsSelectionIndicator = true
        self.detailPickerView.tag = 2;
        
        self.detailsTextField.delegate = self
        self.statusTextField.delegate = self
        
        let statusToolbar = UIToolbar()
        statusToolbar.barStyle = UIBarStyle.Default
        statusToolbar.translucent = true
        statusToolbar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        statusToolbar.sizeToFit()
        
        let detailToolbar = UIToolbar()
        detailToolbar.barStyle = UIBarStyle.Default
        detailToolbar.translucent = true
        detailToolbar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        detailToolbar.sizeToFit()
        
        let statusButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SignatureViewController.doneStatusButton))
        let detailButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(SignatureViewController.doneDetailButton))
        
        statusToolbar.setItems([statusButton], animated: false)
        statusToolbar.userInteractionEnabled = true
        detailToolbar.setItems([detailButton], animated: false)
        detailToolbar.userInteractionEnabled = true
        
        self.statusTextField.inputView = self.statusPickerView
        self.statusTextField.inputAccessoryView = statusToolbar
        self.detailsTextField.inputView = self.detailPickerView
        detailsTextField.inputAccessoryView = detailToolbar
        
        //Tap Gesture
        
        let dismissGesture = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        dismissGesture.delegate = self
        self.view.addGestureRecognizer(dismissGesture)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Picker View Delegate
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == 1){
            //code status
            return self.status.count
        }else if(pickerView.tag == 2){
            //code detail
            return self.details.count
        }
        return 0
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag == 1){
            return self.status[row]
        }else if(pickerView.tag == 2){
            return self.details[row]
        }
        return ""
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView.tag == 1){
            self.statusTextField.text = self.status[row]
            if(self.status[row] == "Entregado"){
                self.detailsTextField.enabled = false
            }else{
                self.detailsTextField.enabled = true
            }
        }else if(pickerView.tag == 2){
            self.detailsTextField.text = self.details[row]
        }
    }
    
    //MARK: - Picker Views Selectors
    
    func doneStatusButton(){
        self.statusTextField.resignFirstResponder()
    }
    
    func doneDetailButton(){
        self.detailsTextField.resignFirstResponder()
    }
    
    //MARK: - DismissKeyboard
    func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    //MARK: - IBActions
    
    @IBAction func confirmData(sender: AnyObject) {
        
        let realm = try!Realm()
        let driver = realm.objects(Vehicle).first
        var statusLocation: Int? = nil
        
        switch self.statusTextField.text! {
        case "Entregado":
            statusLocation = 1
            break
        case "Parcialmente Entregado":
            statusLocation = 2
            break
        case "No Entregado":
            statusLocation = 3
            break
        default:
            break
        }
        
        //escribir datos
        let RManager = RouteManager()
        
        RManager.pushClientConfirmation(driver!.getId(), customerId: self.locationAsociated!.Customer, statusDelivery: String(statusLocation), detailDelivery: self.detailsTextField.text!, commentsDelivery: self.commentsTextView.text, coordinates: self.vehicleCoordinates!,completion: {
            
            self.navigationController?.popViewControllerAnimated(true)
            
        })
        
        
    }
    
    //MARK: - Logout
    
    @IBAction func logout(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    

}
