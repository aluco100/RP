//
//  Options.swift
//  RoutePro
//
//  Created by Alfredo Luco on 03-06-16.
//  Copyright © 2016 citymovil. All rights reserved.
//

import Foundation

public class Option {
    
    private var idOption: String
    public var descriptionOption: String
    public var detailsOption: [String]
    
    init(id: String, description: String, details: [String]){
        self.idOption = id
        self.descriptionOption = description
        self.detailsOption = details
    }
    
    public func getId()->String{
        return self.idOption
    }
    
}