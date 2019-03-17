//
//  HistoryTableViewCell.swift
//  ERLWeatherApp
//
//  Created by Esteban on 3/15/19.
//  Copyright © 2019 Esteban. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var historyEntryLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initFromWeatherRealm(weatherEntry:WeatherRealm) {
        historyEntryLabel.text = weatherEntry.cityName + " " + weatherEntry.date + " " + weatherEntry.weatherStatus
    }

}
