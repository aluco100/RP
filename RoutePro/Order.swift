//
//  Order.swift
//  RoutePro
//
//  Created by Alfredo Luco on 24-05-16.
//  Copyright © 2016 citymovil. All rights reserved.
//

import Foundation
import RealmSwift

public class Order: Object {
    
    //MARK: - Properties
    private dynamic var Id: Int = 1
    
    public dynamic var OrderName: String = ""
    
    public var OrderLocation: Location? = nil
    
    public var OrderCustomer: Customer? = nil
    
    public var OrderTrip: Trip? = nil
    
    public dynamic var Date: NSDate = NSDate()
    
    //MARK: - Initializer
    
    convenience init(id: Int, name: String, location: Location, customer: Customer, trip: Trip, date: NSDate){
        self.init()
        self.Id = id
        self.OrderName = name
        self.OrderLocation = location
        self.OrderCustomer = customer
        self.OrderTrip = trip
        self.Date = date
    }
    
    //MARK: - Methods
    
    public func getId()->Int{
        return self.Id
    }
    
}