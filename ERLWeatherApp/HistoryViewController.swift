//
//  HistoryViewController.swift
//  ERLWeatherApp
//
//  Created by Esteban on 3/13/19.
//  Copyright © 2019 Esteban. All rights reserved.
//

import UIKit
import RealmSwift

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var historyTableView: UITableView!
    
    var weatherEntries:[WeatherRealm] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        getWeatherEntries()
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        getWeatherEntries()
        historyTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherEntries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell") as! HistoryTableViewCell
        cell.initFromWeatherRealm(weatherEntry: weatherEntries[indexPath.row])
        return cell
    }
    
    func getWeatherEntries() {
        do {
            let realm = try Realm()
            weatherEntries = Array<WeatherRealm>(realm.objects(WeatherRealm.self))
        } catch {
            
        }
    }
    
    
}
