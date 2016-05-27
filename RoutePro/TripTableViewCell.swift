//
//  TripTableViewCell.swift
//  RoutePro
//
//  Created by Alfredo Luco on 24-05-16.
//  Copyright © 2016 citymovil. All rights reserved.
//

import UIKit

class TripTableViewCell: UITableViewCell {

    @IBOutlet var NumberOfTrip: UILabel!
    @IBOutlet var RangeOfTime: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
