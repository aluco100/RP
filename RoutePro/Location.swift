//
//  Location.swift
//  RoutePro
//
//  Created by Alfredo Luco on 24-05-16.
//  Copyright © 2016 citymovil. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

public class Location: Object {
    
    //MARK: - Properties
    
    private dynamic var Sequence: Int = 1
    public dynamic var Address: String = ""
    public dynamic var Name: String = ""
    public dynamic var arrivalTime: String = ""
    public dynamic var Latitude: String = ""
    public dynamic var Longitude: String = ""
    private dynamic var Status: Int = 1
    public dynamic var Customer: String = ""
    
    //MARK: - Initializer
    
    convenience init(sequence: Int, address: String, name: String, arrival: String, latitude: String, longitude: String, status: Int, scheduleCustomer: String){
        self.init()
        self.Sequence = sequence
        self.Address = address
        self.Name = name
        self.arrivalTime = arrival
        self.Latitude = latitude
        self.Longitude = longitude
        self.Status = status
        self.Customer = scheduleCustomer
    }
    
    //MARK: - Methods
    
    public func getId()->Int{
        return self.Sequence
    }
    
    public func getStatus()->Int{
        return self.Status
    }
}