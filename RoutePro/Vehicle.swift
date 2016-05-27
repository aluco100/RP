//
//  Vehicle.swift
//  RoutePro
//
//  Created by Alfredo Luco on 24-05-16.
//  Copyright © 2016 citymovil. All rights reserved.
//

import Foundation
import RealmSwift

public class Vehicle: Object {
    
    
    //MARK: - Properties
    
    private dynamic var Id: String = ""
    public dynamic var Capacity: Int = 1
    public dynamic var DriverName: String = ""
    
    //MARK: - Initializer
    
    convenience init(id: String, capacity: Int, driver: String){
        self.init()
        self.Id = id
        self.Capacity = capacity
        self.DriverName = driver
    }
    
    //MARK: - Realm Properties
    
    override public static func primaryKey() -> String? {
        return "Id"
    }
    
    //MARK: - Methods
    
    public func getId()->String{
        return self.Id
    }
}