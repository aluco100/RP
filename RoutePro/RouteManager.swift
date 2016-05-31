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
        //self.Url = "http://routepro.cl/area_comercial/Rest/"
        self.Url = "http://192.168.2.130:8080/route_pro_webapp/Rest/"
    }
    
    //MARK: - Methods
    
    public func signInDriverById(vehicleId: String, completion: (externalId: String)->Void){
        
        Alamofire.request(.POST, "\(self.Url)validation", parameters: ["vehicle" : vehicleId]).responseJSON(completionHandler: {
            response in
            
            print(response.result)
            
            if let dictionary = response.result.value as? NSDictionary{
                
                if let externalId = dictionary["external_id"] as? String{
                    
                    let vehicle = Vehicle(id: externalId, capacity: 0, driver: "")
                    
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
            "schedule_customer_id" : customerId,
            "external_id" : vehicleId
        ]
        
        Alamofire.request(.POST, "\(self.Url)result_delivery", parameters: params, encoding: .JSON).responseJSON(completionHandler: {
            response in
            
            print(response.result)
            if(response.result.error == nil){
                
                completion()
                
            }
            
        })
        
    }
    
}
