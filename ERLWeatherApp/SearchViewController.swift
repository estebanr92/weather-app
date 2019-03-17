//
//  SearchViewController.swift
//  ERLWeatherApp
//
//  Created by Esteban on 3/13/19.
//  Copyright © 2019 Esteban. All rights reserved.
//

import UIKit
import RealmSwift

class SearchViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityPicker: UIPickerView!
    @IBOutlet weak var weatherStatusIcon: UIImageView!
    let networking = Networking()
    
    var cities: Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        cityPicker.isHidden = true
        cities = defaults.stringArray(forKey: "CitiesArray") ?? [String]()
        cityPicker.reloadAllComponents()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        cityPicker.isHidden = false
        searchTextField.text = cities[cityPicker.selectedRow(inComponent: 0)]
        return false
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cities.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cities[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let pickedCity = cities[row]
        cityPicker.isHidden = true
        searchTextField.text = pickedCity
        networking.getCurrentWeatherFromCity(pickedCity) { weather in
            let celcius = self.kelvinToCelcius(weather.temperature!)
            self.searchTextField.text = weather.cityName!
            self.temperatureLabel.text = celcius
            let statusIconId: String = (weather.condition?.statusIconId)!
            self.networking.getConditionIcon(statusIconId) { imageStatus
                in
                self.weatherStatusIcon.image = imageStatus
                let weatherRealm = WeatherRealm(weather: weather)
                do {
                    let realm = try Realm()
                    
                    try realm.write {
                        print("agregando")
                        realm.add(weatherRealm)
                    }
                } catch {
                    
                }
            }
        }
        return
    }
    
    func kelvinToCelcius(_ value:Double) -> String {
        return String(Int(value - 273)) + "°"
    }
    
}
