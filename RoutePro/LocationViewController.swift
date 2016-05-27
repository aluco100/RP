//
//  LocationViewController.swift
//  RoutePro
//
//  Created by Alfredo Luco on 27-05-16.
//  Copyright © 2016 citymovil. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tripAsociated: Trip? = nil
    var locations: [Location] = []

    @IBOutlet var locationTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(tripAsociated?.TripLocations)
        
        for i in (tripAsociated?.TripLocations)!{
            locations.append(i)
        }
        
        //TableView delegate
        self.locationTableView.delegate = self
        self.locationTableView.dataSource = self
        
        //TableView Settings
        self.locationTableView.separatorStyle = .None
        self.locationTableView.allowsSelection = false

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("locationCell", forIndexPath: indexPath) as? LocationTableViewCell
        
        cell?.customerLabel.text = "\(locations[indexPath.row].Name) Hora: \(locations[indexPath.row].arrivalTime)"
        
        cell?.addressLabel?.text = locations[indexPath.row].Address
        
        return cell!
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
