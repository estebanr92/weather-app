//
//  ForecastTableViewCell.swift
//  ERLWeatherApp
//
//  Created by Esteban on 3/17/19.
//  Copyright © 2019 Esteban. All rights reserved.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {

    @IBOutlet weak var forecastHourLabel: UILabel!
    @IBOutlet weak var forecastStatusLabel: UILabel!
    @IBOutlet weak var forecastStatusImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
