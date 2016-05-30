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

class SignatureViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {

    
    var locationAsociated: Location? = nil
    var vehicleCoordinates: CLLocation? = nil
    var dateTime: NSDate = NSDate()
    
    var statusPickerView = UIPickerView()
    var detailPickerView = UIPickerView()
    
    //Outlets
    @IBOutlet var statusTextField: UITextField!
    @IBOutlet var detailsTextField: UITextField!
    @IBOutlet var commentsTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("customer-id:\(locationAsociated!.Customer)")
        
        let realm = try!Realm()
        let driver = realm.objects(Vehicle).first
        print("external_id: \(driver!.getId())")
        
        print("Lat: \(vehicleCoordinates!.coordinate.latitude) Lon:\(vehicleCoordinates!.coordinate.longitude)")
        
        //obtener fecha dd-MM-yyyy hh:mm
        
        let dateFormatter : NSDateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.systemLocale()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        print("date: \(dateFormatter.stringFromDate(self.dateTime))")
        
        //Picker View Settings
        self.statusPickerView = UIPickerView(frame: CGRect(x: 0, y: 200, width: view.frame.width, height: 300))
        self.detailPickerView = UIPickerView(frame: CGRect(x: 0, y: 200, width: view.frame.width, height: 300))
        
        self.statusPickerView.delegate = self
        self.statusPickerView.dataSource = self
        self.statusPickerView.showsSelectionIndicator = true
        self.detailPickerView.delegate = self
        self.detailPickerView.dataSource = self
        self.detailPickerView.showsSelectionIndicator = true
        
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
        
        let statusButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("doneStatusButton"))
        let detailButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: Selector("doneDetailButton"))
        
        statusToolbar.setItems([statusButton], animated: false)
        statusToolbar.userInteractionEnabled = true
        detailToolbar.setItems([detailButton], animated: false)
        detailToolbar.userInteractionEnabled = true
        
        self.statusTextField.inputView = self.statusPickerView
        self.statusTextField.inputAccessoryView = statusToolbar
        self.detailsTextField.inputView = self.detailPickerView
        detailsTextField.inputAccessoryView = detailToolbar

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
        <#code#>
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        <#code#>
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        <#code#>
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
