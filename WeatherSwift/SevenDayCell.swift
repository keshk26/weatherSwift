//
//  SevenDayCell.swift
//  WeatherSwift
//
//  Created by Keshav on 8/20/17.
//  Copyright © 2017 Keshav. All rights reserved.
//

import UIKit

class SevenDayCell: UITableViewCell {

    @IBOutlet var weekdayLabel: UILabel!
    @IBOutlet var minTempLabel: UILabel!
    @IBOutlet var maxTempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
