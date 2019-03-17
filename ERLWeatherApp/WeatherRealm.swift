//
//  WeatherRealm.swift
//  ERLWeatherApp
//
//  Created by Esteban on 3/14/19.
//  Copyright © 2019 Esteban. All rights reserved.
//

import Foundation
import RealmSwift

class WeatherRealm: Object
{
    @objc dynamic var cityName:String = ""
    @objc dynamic var temperature:Double = 0
    @objc dynamic var weatherStatus:String = ""
    @objc dynamic var weatherStatusIconId:String = ""
    @objc dynamic var date:String = ""
    
    convenience init(weather:Weather) {
        self.init()
        let unformattedDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "E d HH:mm"
        cityName = weather.cityName!
        temperature = weather.temperature!
        weatherStatus = (weather.condition?.status)!
        weatherStatusIconId = (weather.condition?.statusIconId)!
        date = formatter.string(from: unformattedDate)
    }

}
