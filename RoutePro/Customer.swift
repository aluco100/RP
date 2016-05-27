//
//  Customer.swift
//  RoutePro
//
//  Created by Alfredo Luco on 24-05-16.
//  Copyright © 2016 citymovil. All rights reserved.
//

import Foundation
import RealmSwift

public class Customer: Object {
    
    //MARK: - Properties
    
    private dynamic var Id: Int = 1
    public dynamic var CustomerName: String = ""
    
    
    //MARK: - Initializer
    
    convenience init(id: Int, name: String){
        self.init()
        self.Id = id
        self.CustomerName = name
    }
    
    //MARK: - Methods
    
    public func getId()->Int{
        return self.Id
    }
}