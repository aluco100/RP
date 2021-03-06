//
//  RouteManager.swift
//  RoutePro
//
//  Created by Alfredo Luco on 24-05-16.
//  Copyright © 2016 citymovil. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift
import CoreLocation

public class RouteManager{
    
    private var Url: String
    
    init(){
        self.Url = "http://routepro.cl/area_comercial/Rest/"
        //self.Url = "http://192.168.2.130:8080/route_pro_webapp/Rest/"
    }
    
    //MARK: - Methods
    
    //Login Verification for RoutePro users
    
    public func signInDriverById(vehicleId: String, completion: (externalId: String)->Void){
        
        Alamofire.request(.POST, "\(self.Url)validation", parameters: ["vehicle" : vehicleId]).responseJSON(completionHandler: {
            response in
            
            print(response.result)
            
            if let dictionary = response.result.value as? NSDictionary{
                
                if let externalId = dictionary["external_id"] as? String{
                    
                    let vehicle = Vehicle(id: externalId, capacity: 0, driver: "")
                    vehicle.setLogState(true)
                    
                    let realm = try!Realm()
                    
                    try! realm.write({
                        void in
                        
                        realm.add(vehicle, update: true)
                        completion(externalId: externalId)
                        
                    })
                    
                }
            }
            
        })
        
    }
    
    //Get RoutePro's trips by User
    
    public func getTripsDriverById(vehicleId: String, completion: (trips: List<Trip>)->Void){
        
        Alamofire.request(.POST, "\(self.Url)routeCustomers", parameters: ["external_id" : vehicleId], encoding: .JSON).responseJSON(completionHandler: {
            response in
            print(response.result)
            let trips = List<Trip>()
            let realm = try! Realm()
            let vehicle = realm.objects(Vehicle).first
            
            if let megaDictionary = response.result.value as? NSDictionary{
                
                if let arrayOfObjects = megaDictionary["trips"] as? NSArray{
                    
                    for i in arrayOfObjects{
                        
                        if let trip = i["trip"] as? String, let id = i["route_id"] as? String, let start = i["start"] as? String, end = i["end_of_trip"] as? String{
                            
                            let locs = List<Location>()
                            
                            if let locations = i["location"] as? NSArray{
                                
                                
                                for j in locations{
                                    if let name = j["name"] as? String, let arrivalTime = j["arrival_time"] as? String, let address = j["address"] as? String, let latitude = j["latitude"] as? String, let longitude = j["longitude"] as? String, let sequence = j["sequence"] as? String, let customer = j["scheduled_customer_id"] as? String{
                                        
                                        let newLocation = Location(sequence: Int(sequence)!, address: address, name: name, arrival: arrivalTime, latitude: latitude, longitude: longitude, status: 1, scheduleCustomer: customer)
                                        locs.append(newLocation)
                                        
                                        
                                    }
                                    
                                }
                                
                                let newTrip = Trip(id: Int(id)!, number: trip, location: locs, driver: vehicle!, start: start, end: end)
                                trips.append(newTrip)
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
            try!realm.write({
                for i in trips{
                    realm.add(i, update: true)
                }
                
                completion(trips: trips)
            })
            
        })
        
        
    }
    
    
    //TODO: Esto se hace despues
    
    //Vehicle's coordinates verification
    
    func validateVehicleLocation(customerId: String, vehicleId:String,coordinates:CLLocation,date: NSDate, completion:()->Void) {
        
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale.systemLocale()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let params = [
            "scheduled_customer_id": customerId,
            "external_id" : vehicleId,
            "latitude": "\(String(coordinates.coordinate.latitude))",
            "longitude": "\(String(coordinates.coordinate.longitude))",
            "date": formatter.stringFromDate(date)
        ]
        
        Alamofire.request(.POST, "\(self.Url)position_check_mobile", parameters: params,encoding: .JSON).responseJSON(completionHandler: {
            response in
            //code
            print(response.result.error)
            print(response.result.value)
        })
        
    }
    
    //Confirm customer details
    
    
    func pushClientConfirmation(vehicleId: String,customerId: String,statusDelivery: String, detailDelivery: String, commentsDelivery: String,coordinates: CLLocation,completion: ()->Void){
        
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale.systemLocale()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let params = [
            "type_result" : statusDelivery,
            "detail" : detailDelivery,
            "comment" : commentsDelivery,
            "latitude": "\(coordinates.coordinate.latitude)",
            "longitude" : "\(coordinates.coordinate.longitude)",
            "date" : formatter.stringFromDate(NSDate()),
            "scheduled_customer_id" : customerId,
            "external_id" : vehicleId,
            "firm" : "1"
        ]
        
        print(params)
        
        Alamofire.request(.POST, "\(self.Url)result_delivery", parameters: params, encoding: .JSON).responseJSON(completionHandler: {
            response in
            
            print(response.result.error)
            if(response.result.error == nil){
                
                completion()
                
            }
            
        })
        
    }
    
    //Getting options of Delivery
    
    func getOptions(completion: (options:[Option])->Void){
        Alamofire.request(.GET, "\(self.Url)delivery_option").responseJSON(completionHandler: {
            response in
            print(response.result.value)
            
            var values:[Option] = []
            
            let dictionary = response.result.value as? NSDictionary
            let arrayOptions = dictionary!["options"] as? NSArray
            
            for i in arrayOptions! {
                var optionValues: [String] = []
                
                let id = i["delivery_result_id"] as? String
                let description = i["description"] as? String
                let details = i["details"] as? NSArray
                
                for j in details!{
                    let detailValue = j["detail"] as? String
                    optionValues.append(detailValue!)
                }
                
                let optionValue = Option(id: id!, description: description!, details: optionValues)
                values.append(optionValue)
            }
            completion(options: values)
        })
    }
    
    func sendLocations(driverPatent: String,location: CLLocation,heading: CLHeading){
        //Getting the data 
        //1.- Get the current dateTime
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale.systemLocale()
        formatter.dateFormat = "dd-MM-yyyy hh:mm:ss"
        
        //2.- Get the Current Speed
        let velocidad = location.speed < 0 ? 0 : location.speed
        
        //Make the XML schema
        let data: String = "<?xml version=\"1.0\"?>\n<row>\n<ppu>\(driverPatent)</ppu>\n<datetime>\(formatter.stringFromDate(date))</datetime>\n<latitud>\(location.coordinate.latitude)</latitud>\n<longitud>\(location.coordinate.longitude)</longitud>\n<speed>\(velocidad)</speed>\n<heading>\(heading.magneticHeading)</heading>\n<type>14</type>\n</row>"
        print(data)
        
        //URL Request
        let url: NSURL = NSURL(string: "http://")!
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = "POST"
        request.setValue("application/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = NSData(bytes: data, length: data.characters.count)
        
        
        //Send Into NSURLResponse
        
        var response: NSURLResponse? = nil
        
        if let responseData = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: &response){
            print(responseData)
        }else{
            print("error")
        }
        
        
    }
}
