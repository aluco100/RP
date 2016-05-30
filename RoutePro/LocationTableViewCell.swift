//
//  LocationTableViewCell.swift
//  RoutePro
//
//  Created by Alfredo Luco on 27-05-16.
//  Copyright © 2016 citymovil. All rights reserved.
//

import UIKit
import CoreLocation


protocol LocationTableViewCellDelegate{
    func showActionSheet(locationAtIndex: Int)
    func confirmOrder(locationAtIndex: Int)
}

class LocationTableViewCell: UITableViewCell,UIActionSheetDelegate {

//    @IBOutlet var customerLabel: UILabel!
    
    @IBOutlet var customerLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var CGPoints: UIView!
    
    var delegate = LocationTableViewCellDelegate?()
    var index: Int? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func goToPoint(sender: AnyObject) {
                
        if let delegate = self.delegate{
            delegate.showActionSheet(index!)
        }
        
        
        
        
    }
    
    
    @IBAction func proceedToSign(sender: AnyObject) {
        
        if let delegate = self.delegate{
            delegate.confirmOrder(self.index!)
        }
        
    }
    
}
