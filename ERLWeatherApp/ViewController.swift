//
//  ViewController.swift
//  ERLWeatherApp
//
//  Created by Esteban on 3/13/19.
//  Copyright © 2019 Esteban. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire
import AlamofireObjectMapper
import AlamofireImage


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate {


    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherStatusIcon: UIImageView!
    @IBOutlet weak var weatherTableView: UITableView!
    
    let locationManager = CLLocationManager()
    let networking = Networking()
    var maxNumberOfDaysToShowInt: Int?
    var sortedWeatherEntries: Array<Array<Weather>> = [[],[],[],[],[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        let maxNumberOfDaysToShow = defaults.string(forKey: "MaxNumberOfDays")
        if maxNumberOfDaysToShow == "" || maxNumberOfDaysToShow == nil {
            defaults.set("5", forKey: "MaxNumberOfDays")
        }
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self as? CLLocationManagerDelegate
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
        
    override func viewDidAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        maxNumberOfDaysToShowInt = Int(defaults.string(forKey: "MaxNumberOfDays")!)
        weatherTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        maxNumberOfDaysToShowInt = Int(defaults.string(forKey: "MaxNumberOfDays")!)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        
        networking.getCurrentWeatherFromCoordinates(locValue) { weather
            in
            let celcius = self.kelvinToCelcius(weather.temperature!)
            self.cityLabel.text = weather.cityName!
            self.temperatureLabel.text = celcius
            self.cityLabel.reloadInputViews()
            let statusIconId: String = (weather.condition?.statusIconId)!
            self.networking.getConditionIcon(statusIconId) { imageStatus
                in
                self.weatherStatusIcon.image = imageStatus
            }
        }
    
        networking.getWeatherForNextDays(locValue) { weatherList
            in
            
            let firstDay: String = self.getDayLabel(0)
            let secondDay: String = self.getDayLabel(1)
            let thirdDay: String = self.getDayLabel(2)
            let fourthDay: String = self.getDayLabel(3)
            let fifthDay: String = self.getDayLabel(4)
            let group = DispatchGroup()
            self.sortedWeatherEntries = [[],[],[],[],[]]
        
            for weatherEntry in weatherList {
                 group.enter()
                self.networking.getConditionIcon(weatherEntry.condition!.statusIconId!) { imageStatus
                    in
                    weatherEntry.condition?.statusIcon = imageStatus
                    
                    let weatherEntryFormattedDate = self.getDayLabelByDate(weatherEntry.date!)
                  
                    switch weatherEntryFormattedDate {
                    case firstDay:
                        if self.sortedWeatherEntries[0].count >= 8 {
                            break
                        }
                        self.sortedWeatherEntries[0].append(weatherEntry)
                        
                    case secondDay:
                        if self.sortedWeatherEntries[1].count >= 8 {
                            break
                        }
                        self.sortedWeatherEntries[1].append(weatherEntry)
                    case thirdDay:
                        if self.sortedWeatherEntries[2].count >= 8 {
                            break
                        }
                        self.sortedWeatherEntries[2].append(weatherEntry)
                    case fourthDay:
                        if self.sortedWeatherEntries[3].count >= 8 {
                            break
                        }
                        self.sortedWeatherEntries[3].append(weatherEntry)
                    case fifthDay:
                        if self.sortedWeatherEntries[4].count >= 8 {
                            break
                        }
                        self.sortedWeatherEntries[4].append(weatherEntry)
                    default: break
                        
                    }
                    group.leave()
                }
            }
            group.notify(queue: .main) {
                self.weatherTableView.reloadData()
            }
            
        }
    }
    
    func getDayLabel(_ index:Int) -> String {
        var unformattedDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        
        unformattedDate = Calendar.current.date(byAdding: .day, value: index, to: unformattedDate)!
        return formatter.string(from: unformattedDate)
    }
    
    func getDayLabelByDate(_ date:String) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        var splitDate = date.split{$0 == " "}
        let dateWithoutHour: String = String(splitDate[0])
        
        let partial = formatter.date(from:dateWithoutHour)
        formatter.dateFormat = "EEEE"
        let result = formatter.string(from: partial!)
        return result
    }
    
    
    
    func kelvinToCelcius(_ value:Double) -> String {
        return String(Int(value - 273)) + "°"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return sortedWeatherEntries[0].count
        case 1:
            return sortedWeatherEntries[1].count
        case 2:
            return sortedWeatherEntries[2].count
        case 3:
           return sortedWeatherEntries[3].count
        case 4:
            return sortedWeatherEntries[4].count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "forecastCell") as! ForecastTableViewCell
        switch indexPath.section {
        case 0:
            cell.forecastStatusLabel?.text = sortedWeatherEntries[0][indexPath.row].condition!.status
            cell.forecastHourLabel?.text = getHourFromDate(sortedWeatherEntries[0][indexPath.row].date!)
            cell.forecastStatusImage?.image = sortedWeatherEntries[0][indexPath.row].condition!.statusIcon
        case 1:
            cell.forecastStatusLabel?.text = sortedWeatherEntries[1][indexPath.row].condition!.status
            cell.forecastHourLabel?.text = getHourFromDate(sortedWeatherEntries[1][indexPath.row].date!)
            cell.forecastStatusImage?.image = sortedWeatherEntries[1][indexPath.row].condition!.statusIcon
        case 2:
            cell.forecastStatusLabel?.text = sortedWeatherEntries[2][indexPath.row].condition!.status
            cell.forecastHourLabel?.text = getHourFromDate(sortedWeatherEntries[2][indexPath.row].date!)
            cell.forecastStatusImage?.image = sortedWeatherEntries[2][indexPath.row].condition!.statusIcon
        case 3:
            cell.forecastStatusLabel?.text = sortedWeatherEntries[3][indexPath.row].condition!.status
            cell.forecastHourLabel?.text = getHourFromDate(sortedWeatherEntries[3][indexPath.row].date!)
            cell.forecastStatusImage?.image = sortedWeatherEntries[3][indexPath.row].condition!.statusIcon
        default:
            cell.forecastStatusLabel?.text = sortedWeatherEntries[4][indexPath.row].condition!.status
            cell.forecastHourLabel?.text = getHourFromDate(sortedWeatherEntries[4][indexPath.row].date!)
            cell.forecastStatusImage?.image = sortedWeatherEntries[4][indexPath.row].condition!.statusIcon
        }
        return cell
    }
    
    func getHourFromDate(_ date:String) -> String {
        var splitDate = date.split{$0 == " "}
        return String(splitDate[1])
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return maxNumberOfDaysToShowInt!
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var unformattedDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        var dayPosition = 0
        switch section {
        case 0:
            dayPosition = 0
        case 1:
            
            dayPosition = 1
        case 2:
            dayPosition = 2
        case 3:
            dayPosition = 3
        default:
            dayPosition = 4
        }
        unformattedDate = Calendar.current.date(byAdding: .day, value: dayPosition, to: unformattedDate)!
        return formatter.string(from: unformattedDate)
    }
    
}

