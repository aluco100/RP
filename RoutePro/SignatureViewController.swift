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

class SignatureViewController: UIViewController,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource {

    //MARK: - Global Variables
    var locationAsociated: Location? = nil
    var vehicleCoordinates: CLLocation? = nil
    var dateTime: NSDate = NSDate()
    var options: [Option] = []
    var status:[String] = []
    var statusSelected: String? = nil
    
    //MARK: - IBOutlets
    @IBOutlet var detailTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Load status with deliveryOptions
        
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
    
    //MARK: - Navigation
    
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
