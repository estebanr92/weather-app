//
//  SettingsViewController.swift
//  ERLWeatherApp
//
//  Created by Esteban on 3/13/19.
//  Copyright © 2019 Esteban. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var maxDaysTextField: UITextField!
    @IBOutlet weak var addCityTextField: UITextField!
    @IBAction func changeSettingsButtonPressed(_ sender: Any) {
        let defaults = UserDefaults.standard
        var cities = defaults.stringArray(forKey: "CitiesArray") ?? [String]()
        cities.append(addCityTextField.text!)
        defaults.set(cities, forKey: "CitiesArray")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        maxDaysTextField.delegate = self
        let defaults = UserDefaults.standard
        let maxNumberOfDaysToShow = defaults.string(forKey: "MaxNumberOfDays")
        maxDaysTextField.text = maxNumberOfDaysToShow
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        let maxNumberOfDaysToShow = defaults.string(forKey: "MaxNumberOfDays")
        maxDaysTextField.text = maxNumberOfDaysToShow
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        let maxDays = maxDaysTextField.text
        let maxDaysInt = Int(maxDays!)
        if maxDays == "" {
            return
        }
        if maxDaysInt == nil || maxDaysInt! > 5 || maxDaysInt! < 1 {
            return
        }
        
        defaults.set(maxDays, forKey: "MaxNumberOfDays")
    }
    
}
