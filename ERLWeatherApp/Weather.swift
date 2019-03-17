//
//  Pokemon.swift
//  PokedexApp
//
//  Created by Santiago Villagómez on 3/7/19.
//  Copyright © 2019 Santiago Villagómez. All rights reserved.
//

import Foundation
import ObjectMapper

class WeatherList: Mappable {
    var weatherList: Array<Weather>?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        weatherList <- map["list"]
    }
}

class Weather: Mappable {
    var cityName:String?
    var temperature: Double?
    var condition: Condition?
    var date: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        cityName <- map["name"]
        temperature <- map["main.temp"]
        condition <- map["weather.0"]
        date <- map["dt_txt"]
    }
}

class Condition: Mappable {
    
    var status:String?
    var statusIconId: String?
    var statusIcon: UIImage?
    
    required init?(map:Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["main"]
        statusIconId <- map["icon"]
    }
}
