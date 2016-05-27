//
//  LocationViewController.swift
//  RoutePro
//
//  Created by Alfredo Luco on 27-05-16.
//  Copyright © 2016 citymovil. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,LocationTableViewCellDelegate,UIActionSheetDelegate {
    
    var tripAsociated: Trip? = nil
    var locations: [Location] = []
    var locationSelected: Location? = nil

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
        
        cell?.index = indexPath.row
        
        cell?.customerLabel.text = "\(locations[indexPath.row].Name) Hora: \(locations[indexPath.row].arrivalTime)"
        
        cell?.addressLabel?.text = locations[indexPath.row].Address
        
        //make circle
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: 25,y: 40), radius: CGFloat(10.0), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.CGPath
        
        //change the fill color
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        //you can change the stroke color
        shapeLayer.strokeColor = UIColor.blackColor().CGColor
        //you can change the line width
        shapeLayer.lineWidth = 1.0
        
        cell?.CGPoints.layer.addSublayer(shapeLayer)
        
        if(cell?.index == 0){
            let line =  UIView(frame: CGRectMake(25, 129.5, 1, 79.5))
            line.backgroundColor = UIColor.blackColor()
            self.view.addSubview(line)
            
        }
        
        cell?.delegate = self
        
        return cell!
    }

    
    //MARK: - Custom Cell delegate
    
    func showActionSheet(locationAtIndex: Int) {
        
        self.locationSelected = locations[locationAtIndex]
        
        print(self.locationSelected)
        
        let manager : UIApplication = UIApplication.sharedApplication()
        
        
        let actionSheet : UIActionSheet = UIActionSheet(title: "Go To Point", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil)
        
        actionSheet.actionSheetStyle = .BlackTranslucent
        
        
        if(manager.canOpenURL(NSURL(string: "waze://")!)){
            
            actionSheet.addButtonWithTitle("Waze")
            
        }
        
        
        if(manager.canOpenURL(NSURL(string: "comgooglemaps://")!)){
            
            actionSheet.addButtonWithTitle("Google Maps")
            
        }
        
        actionSheet.showInView(self.view)
    }
    
    
    //MARK: - Action Sheet Delegate
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        
        if(actionSheet.buttonTitleAtIndex(buttonIndex) == "Waze"){
            
            UIApplication.sharedApplication().openURL(NSURL(string: "waze://?ll=\(self.locationSelected!.Latitude),\(self.locationSelected!.Longitude)&navigate=yes")!)
            
        }else if(actionSheet.buttonTitleAtIndex(buttonIndex) == "Google Maps"){
            
            UIApplication.sharedApplication().openURL(NSURL(string: "comgooglemaps://?saddr=&daddr=\(self.locationSelected!.Latitude),\(self.locationSelected!.Longitude)")!)
            
        }
        
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
