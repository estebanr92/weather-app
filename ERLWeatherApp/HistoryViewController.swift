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
    
    @IBOutlet weak var historyEntriesTableView: UITableView!
    var weatherEntries:[WeatherRealm] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            let realm = try Realm()
            weatherEntries = Array<WeatherRealm>(realm.objects(WeatherRealm.self))
            print(weatherEntries)
        } catch {
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("asoma")
        historyEntriesTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        historyEntriesTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherEntries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell") as! HistoryTableViewCell
        cell.initFromWeatherRealm(weatherEntry: weatherEntries[indexPath.row])
        return cell
    }
    
    
}
