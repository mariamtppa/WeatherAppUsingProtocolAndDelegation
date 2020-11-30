//
//  weeklyDataLoader.swift
//  MyWeatherApp
//
//  Created by Decagon on 15/09/2020.
//  Copyright © 2020 Decagon. All rights reserved.
//

import Foundation

class WeeklyDataLoader {
    var weeklyDataDelegate: GetWeeklyWeatherData?
    func getWeeklyData() {
        let url = "https://api.openweathermap.org/data/2.5/forecast?id=2332785&units=metric&appid=73d46ec792f7188ca13af020d5a05ecf"
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                print("something went wrong")
                return
            }
            var results: WeeklyDataModel?
            do {
                results = try JSONDecoder().decode(WeeklyDataModel.self, from: data)
            }
            catch {
                print("failed to convert \(error.localizedDescription)")
            }
            
            guard let json = results else {
                return
            }
            let neededData = Array(arrayLiteral: json)
            let dataExtracted = neededData[0].list
                .map {$0}.filter{$0.day.contains("21:00:00")}
            self.weeklyDataDelegate?.getWeeklyWeatherData(value: dataExtracted)
        })
        task.resume()
        
    }
}
