//
//  detailTableViewController.swift
//  RoutePro
//
//  Created by Alfredo Luco on 14-06-16.
//  Copyright © 2016 citymovil. All rights reserved.
//

import UIKit
import CoreLocation

class detailTableViewController: UITableViewController {
    
    //MARK: - Global Variables
    
    var locationAssociated: Location? = nil
    var vehicleCoordinates: CLLocation? = nil
    var statusSelected: String? = nil
    var details: [String] = []
    
    var detailSelected: String? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - Configuration
        
        //get details in realm database
        
        let routeManager: RouteManager = RouteManager()
        
        routeManager.getOptions({options in
            for i in options{
                
                if(i.descriptionOption == self.statusSelected){
                    
                    for j in i.detailsOption{
                        self.details.append(j)
                    }
                    
                }
            }
            
            self.tableView.reloadData()
            
        })
        
        //Table View Settings
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return details.count
    }
    
    //MARK: - Table View Delegate

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("detailIdentifier", forIndexPath: indexPath)

        // Configure the cell...
        
        cell.textLabel?.text = details[indexPath.row]

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.detailSelected = details[indexPath.row]
        self.performSegueWithIdentifier("commentSegue", sender: self)
    }
    
    
    
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "commentSegue"){
            if let destination = segue.destinationViewController as? CommentViewController{
                destination.detailSelected = self.detailSelected
                destination.statusSelected = self.statusSelected
                destination.locationAssociated = self.locationAssociated
                destination.vehicleCoordinates = self.vehicleCoordinates
                
            }
        }
        
    }
    

}
