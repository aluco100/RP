//
//  LocationTableViewCell.swift
//  RoutePro
//
//  Created by Alfredo Luco on 27-05-16.
//  Copyright © 2016 citymovil. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

//    @IBOutlet var customerLabel: UILabel!
    
    @IBOutlet var customerLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var CGPoints: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func goToPoint(sender: AnyObject) {
    }
    
    
    @IBAction func proceedToSign(sender: AnyObject) {
    }
    
}
