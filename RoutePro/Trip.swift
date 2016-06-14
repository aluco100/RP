//
//  Trip.swift
//  RoutePro
//
//  Created by Alfredo Luco on 24-05-16.
//  Copyright © 2016 citymovil. All rights reserved.
//

import Foundation
import RealmSwift

public class Trip: Object {
    
    //MARK: - Properties
    
    private dynamic var Id: Int = 1
    public dynamic var NumberOfTrip: String = ""
    public dynamic var startTrip: String = ""
    public dynamic var endTrip: String = ""
    public var TripLocations: List<Location> = List<Location>()
    public var Driver: Vehicle? = nil
    
    //MARK: - Initializer
    
    convenience init(id:Int, number:String , location:List<Location>, driver: Vehicle, start: String, end: String){
        self.init()
        self.Id = id
        self.NumberOfTrip = number
        self.TripLocations = location
        self.Driver = driver
        self.startTrip = start
        self.endTrip = end
        
    }
    
    //MARK: - Realm Settings
    
    override public static func primaryKey() -> String? {
        return "Id"
    }
    
}