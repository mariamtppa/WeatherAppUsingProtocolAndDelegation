//
//  UpperCell.swift
//  MyWeatherApp
//
//  Created by Decagon on 13/09/2020.
//  Copyright © 2020 Decagon. All rights reserved.
//

import UIKit

class WeatherAppController: UIViewController {
    
    @IBOutlet weak var lowerDisplay: UITableView?
    @IBOutlet weak var backgroundImage: UIImageView?
    @IBOutlet weak var currentTempUpTop: UILabel?
    @IBOutlet weak var daysWeatherDescription: UILabel?
    @IBOutlet weak var maximumTemp: UILabel?
    @IBOutlet weak var currentTemp: UILabel?
    @IBOutlet weak var minimumTemp: UILabel?
    
    var extractedData: WeatherDataModel?
    var weeklyExtractedData: [List]?

    func theData(_ forecast: [List]) {
        DispatchQueue.main.async {
            if let encoded = try? JSONEncoder().encode(forecast) {
                UserDefaults.standard.set(encoded, forKey: "WeeklyPerson" )
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let loadData = DataLoader()
        loadData.fetchData = self
        loadData.getData()
        
        self.dailyWeatherdefaultUser()
        self.loadUpperWeatherView()
        
        let loadTheWeeklyData = WeeklyDataLoader()
        loadTheWeeklyData.weeklyDataDelegate = self
        loadTheWeeklyData.getWeeklyData()
        self.weeklyWeatherDefaultUser()
    }
    
    func dailyWeatherdefaultUser() {
        if let savedData = UserDefaults.standard.data(forKey: "SavedData"),
           let savedDatas = try? JSONDecoder().decode(WeatherDataModel.self, from: savedData) {
            self.extractedData = savedDatas
            print(savedDatas)
            print(extractedData)
        }
    }
    
    func weeklyWeatherDefaultUser() {
        if let weeklyData = UserDefaults.standard.data(forKey: "WeeklyPerson"),
           let weeklyDatas = try? JSONDecoder().decode([List].self, from: weeklyData) {
            self.weeklyExtractedData = weeklyDatas
        }
        self.lowerDisplay?.reloadData()
    }
  
    func loadUpperWeatherView() {
        DispatchQueue.main.async {
            if String((self.extractedData?.weather[0].main ?? "")) == "Clouds" {
                self.daysWeatherDescription?.text = String((self.extractedData?.weather[0].main ?? "")).dropLast() + "y"
                self.backgroundImage?.image = UIImage(named: "forest_cloudy")
                self.view.backgroundColor = UIColor(red:84/255.0, green: 110/255.0, blue: 122/255.0, alpha: 1.0)
            } else if String( (self.extractedData?.weather[0].main ?? "")) == "Clear" {
                self.daysWeatherDescription?.text = "Sunny"
                self.backgroundImage?.image = UIImage(named: "forest_sunny")
                self.view.backgroundColor = UIColor(red: 71/255.0, green: 171/255.0, blue: 47/255.0, alpha: 1.0)
            }else {
                if String((self.extractedData?.weather[0].main ?? ""))  == "Rain" {
                    self.daysWeatherDescription?.text = String((self.extractedData?.weather[0].main ?? "")) + "y"
                    self.backgroundImage?.image = UIImage(named: "forest_rainy")
                    self.view.backgroundColor = UIColor(red: 87/255.0, green: 87/255.0, blue: 93/255.0, alpha: 1.0)
                }
            }
            self.minimumTemp?.text = "\(Int(self.extractedData?.main.temp_min ?? 0))" + "°"
            self.currentTempUpTop?.text = "\(Int(self.extractedData?.main.temp ?? 0))" +  "°"
            self.currentTemp?.text = "\(Int(self.extractedData?.main.temp ?? 0))" +  "°"
            self.maximumTemp?.text = "\(Int(self.extractedData?.main.temp_max ?? 0))" +  "°"
        }
    }
}

extension WeatherAppController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weeklyExtractedData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "theBottomCell", for: indexPath) as? BottomDataDisplay {
            let aRow = weeklyExtractedData?[indexPath.row]
            cell.temp.text = "\(Int(aRow?.main.temp ?? 0.0))" + "°"
            cell.days.text = DateConverter().convertDate(String(Array(aRow?.day ?? "")[0 ... 9]))
            
            if aRow?.weather[0].main == "Rain" || aRow?.weather[0].main == "Thunderstorm" || aRow?.weather[0].main == "Drizzle" {
                cell.weatherIcon.image = UIImage(named: "rain")
            } else if aRow?.weather[0].main == "Clear" {
                cell.weatherIcon.image = UIImage(named: "clear")
            } else {
                if aRow?.weather[0].main == "Clouds" || aRow?.weather[0].main == "Atmosphere" {
                    cell.weatherIcon.image = UIImage(named: "partlysunny")
                }
            }
            return cell
        }
        return UITableViewCell()
    }
}

extension WeatherAppController: GetDailyWeatherData, GetWeeklyWeatherData {
    func getDailyWeatherData(value: WeatherDataModel) {
        DispatchQueue.main.async {
            if let encoded = try? JSONEncoder().encode(value) {
                UserDefaults.standard.set(encoded, forKey: "SavedData")
            }
        }
    }
    func getWeeklyWeatherData(value: [List]) {
        DispatchQueue.main.async {
            self.theData(value)
        }
    }
}
