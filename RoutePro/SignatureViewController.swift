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

//TODO: - Triple Vista!

class SignatureViewController: UIViewController,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource {

    
    var locationAsociated: Location? = nil
    var vehicleCoordinates: CLLocation? = nil
    var dateTime: NSDate = NSDate()
    
    
    //Outlets
    @IBOutlet var detailTableView: UITableView!
   
    
    
    //variables para picker
    var options: [Option] = []
    var status:[String] = []
    
    //global variables
    
    var statusSelected: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let data = RouteManager()
        data.getOptions({
            options in
            for i in options{
                self.status.append(i.descriptionOption)
                self.options.append(i)
            }
            self.detailTableView.reloadData()
        })
        
        //tableView Settings
        self.detailTableView.delegate = self
        self.detailTableView.dataSource = self
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - TableView Delegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return status.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("optionIdentifier", forIndexPath: indexPath)
        
        cell.textLabel?.text = status[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.statusSelected = self.status[indexPath.row]
        self.performSegueWithIdentifier("detailSegue", sender: self)
    }
    
    
    //MARK: - IBActions
    
    @IBAction func confirmData(sender: AnyObject) {
        
//        let realm = try!Realm()
//        let driver = realm.objects(Vehicle).first
        
        //escribir datos
//        let RManager = RouteManager()
//
//        RManager.pushClientConfirmation(driver!.getId(), customerId: self.locationAsociated!.Customer, statusDelivery: self.statusLocation, detailDelivery: self.detailsTextField.text!, commentsDelivery: self.commentsTextView.text, coordinates: self.vehicleCoordinates!,completion: {
//            
//            self.navigationController?.popViewControllerAnimated(true)
//            
//        })
        
        
    }
    
    //MARK: - Logout
    
    @IBAction func logout(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "detailSegue"){
            if let destination = segue.destinationViewController as? detailTableViewController{
                destination.statusSelected = self.statusSelected
                destination.locationAssociated = self.locationAsociated
                destination.vehicleCoordinates = self.vehicleCoordinates
            }
        }
    }
    

}
