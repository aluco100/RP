//
//  LocationViewController.swift
//  RoutePro
//
//  Created by Alfredo Luco on 27-05-16.
//  Copyright © 2016 citymovil. All rights reserved.
//

import UIKit
import CoreLocation
import RealmSwift

class LocationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,LocationTableViewCellDelegate,UIActionSheetDelegate,UIAlertViewDelegate, CLLocationManagerDelegate {
    
    
    //MARK: - Global Variables
    var tripAsociated: Trip? = nil
    var locations: [Location] = []
    var locationSelected: Location? = nil
    var locationManager: CLLocationManager = CLLocationManager()
    
    //MARK: - IBOutlets

    @IBOutlet var locationTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - View settings
        self.locationTableView.backgroundColor = UIColor(patternImage: UIImage(named: "signinWall")!)
        
        //per each trip append trip locations in Realm database
        
        for i in (tripAsociated?.TripLocations)!{
            locations.append(i)
        }
        
        //TableView delegate settings
        self.locationTableView.delegate = self
        self.locationTableView.dataSource = self
        
        //TableView Settings
        self.locationTableView.separatorStyle = .None
        self.locationTableView.allowsSelection = false
        
        //LocationManager settings
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        
        //Every 5 minutes update location states
        
        NSTimer.scheduledTimerWithTimeInterval(300, target: self, selector: #selector(LocationViewController.updatePoints), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: - Table view Delegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("locationCell", forIndexPath: indexPath) as? LocationTableViewCell
        
        //MARK: - Table View Cell Settings
        
        cell?.index = indexPath.row
        
        //Name and Time Scheduled
        
        cell?.customerLabel.text = "\(locations[indexPath.row].Name) Hora: \(locations[indexPath.row].arrivalTime)"
        
        //Address
        
        cell?.addressLabel?.text = locations[indexPath.row].Address
        
        //State
        
        //make circle width CoreGraphics
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: 25,y: 40), radius: CGFloat(10.0), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.CGPath
        
        //change the fill color
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        //you can change the stroke color
        shapeLayer.strokeColor = UIColor.blackColor().CGColor
        //you can change the line width
        shapeLayer.lineWidth = 1.0
        
        /*
         Si status = 1 -> Ni atrasado ni entregado
         Si status = 2 -> Entregado
         Si status = 3 -> Atrasado
         */
        
        //Fill the circle with location status
        
        if(locations[indexPath.row].getStatus() == 2){
            shapeLayer.fillColor = UIColor.greenColor().CGColor
        }else if(locations[indexPath.row].getStatus() == 3){
            shapeLayer.fillColor = UIColor.redColor().CGColor
        }
        
        cell?.CGPoints.layer.addSublayer(shapeLayer)
        
        //MARK: - CoreGraphics configuration
        
        if(cell?.index == 0){
            let line =  UIBezierPath(rect: CGRectMake(25, 50, 1, 79.5))
            let layer = CAShapeLayer()
            layer.path = line.CGPath
            layer.strokeColor = UIColor.blackColor().CGColor
            cell?.CGPoints.layer.addSublayer(layer)
            
        }else if(cell?.index == locations.count - 1){
            let line =  UIBezierPath(rect: CGRectMake(25, 0, 1, 30))
            let layer = CAShapeLayer()
            layer.path = line.CGPath
            layer.strokeColor = UIColor.blackColor().CGColor
            cell?.CGPoints.layer.addSublayer(layer)
        }else{
            let line1 =  UIBezierPath(rect: CGRectMake(25, 0, 1, 30))
            let layer1 = CAShapeLayer()
            layer1.path = line1.CGPath
            layer1.strokeColor = UIColor.blackColor().CGColor
            cell?.CGPoints.layer.addSublayer(layer1)
            let line2 =  UIBezierPath(rect: CGRectMake(25, 50, 1, 79.5))
            let layer2 = CAShapeLayer()
            layer2.path = line2.CGPath
            layer2.strokeColor = UIColor.blackColor().CGColor
            cell?.CGPoints.layer.addSublayer(layer2)

        }
        
        cell?.delegate = self
        
        return cell!
    }

    
    //MARK: - Location Table View Cell delegate
    
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
    
    func confirmOrder(locationAtIndex: Int) {
        self.locationSelected = locations[locationAtIndex]
        let alertView = UIAlertView(title: "Confirmacion de Destino", message: "¿Ha LLegado a su destino?", delegate: self, cancelButtonTitle: "No", otherButtonTitles: "Si")
        alertView.show()
    }
    
    //MARK: - AlertView Delegate
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if(buttonIndex == 1){
            
            let realm = try!Realm()
            let vehicle = realm.objects(Vehicle).first
            
            let RManager = RouteManager()
            
            RManager.validateVehicleLocation(self.locationSelected!.Customer, vehicleId: (vehicle!.getId()), coordinates: self.locationManager.location!, date: NSDate(), completion: {
                
            })
            
            self.performSegueWithIdentifier("signatureSegue", sender: self)
        }
        
    }
    
    //MARK: - Action Sheet Delegate
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        
        if(actionSheet.buttonTitleAtIndex(buttonIndex) == "Waze"){
            
            UIApplication.sharedApplication().openURL(NSURL(string: "waze://?ll=\(self.locationSelected!.Latitude),\(self.locationSelected!.Longitude)&navigate=yes")!)
            
        }else if(actionSheet.buttonTitleAtIndex(buttonIndex) == "Google Maps"){
            
            UIApplication.sharedApplication().openURL(NSURL(string: "comgooglemaps://?saddr=&daddr=\(self.locationSelected!.Latitude),\(self.locationSelected!.Longitude)")!)
            
        }
        
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
                
        if(segue.identifier == "signatureSegue"){
            
            if let destination = segue.destinationViewController as? SignatureViewController{
                
                destination.locationAsociated = self.locationSelected
                destination.vehicleCoordinates = self.locationManager.location
                
            }
        }
        
    }
    
    //MARK: - Logout
    
    @IBAction func logout(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - Update Points
    
    func updatePoints(){
        //code for updating car location and delivery status
        print("points updated")
    }
    

}
