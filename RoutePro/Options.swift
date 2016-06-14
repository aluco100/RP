//
//  Options.swift
//  RoutePro
//
//  Created by Alfredo Luco on 03-06-16.
//  Copyright © 2016 citymovil. All rights reserved.
//

import Foundation

public class Option {
    
    //Custom class for getting options on Customer Confirmation
    
    //MARK: - Properties
    
    private var idOption: String
    public var descriptionOption: String
    public var detailsOption: [String]
    
    //MARK: - Initializer
    
    init(id: String, description: String, details: [String]){
        self.idOption = id
        self.descriptionOption = description
        self.detailsOption = details
    }
    
    //MARK: - Methods
    
    public func getId()->String{
        return self.idOption
    }
    
}