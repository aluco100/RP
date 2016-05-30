//
//  TripViewController.swift
//  RoutePro
//
//  Created by Alfredo Luco on 24-05-16.
//  Copyright © 2016 citymovil. All rights reserved.
//

import UIKit
import RealmSwift

class TripViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: - Global Variables
    
    var dataTrips: [Trip] = []
    var tripToSend: Trip? = nil
    
    @IBOutlet var tripTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - Realm setting
        
        let realm = try! Realm()
        
        let vehicle = realm.objects(Vehicle).first
        
        let data = RouteManager()
        data.getTripsDriverById(String(vehicle!.getId()), completion: {
            trips in
            
            for i in trips{
                self.dataTrips.append(i)
                print(i.NumberOfTrip)
            }
            
            self.tripTableView.reloadData()
            
        })
        
        //MARK: - Table view setting
        
        self.tripTableView.delegate = self
        self.tripTableView.dataSource = self
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Table View Delegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataTrips.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tripIdentifier") as? TripTableViewCell
        
        cell?.NumberOfTrip.text = "Trip \(dataTrips[indexPath.row].NumberOfTrip)"
        
        cell?.RangeOfTime.text = "Start: \(dataTrips[indexPath.row].startTrip) - End: \(dataTrips[indexPath.row].endTrip)"
        
        return cell!
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tripToSend = dataTrips[indexPath.row]
        self.performSegueWithIdentifier("locationSegue", sender: self)
        
        
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "locationSegue"){
            
            if let destination = segue.destinationViewController as? LocationViewController{
                
                destination.tripAsociated = tripToSend
                
            }
            
        }
        
    }
    
    //MARK: - Button Interactions
    
    @IBAction func logout(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    

}
