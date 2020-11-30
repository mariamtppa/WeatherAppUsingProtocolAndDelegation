//
//  dataLoader.swift
//  MyWeatherApp
//
//  Created by Decagon on 14/09/2020.
//  Copyright © 2020 Decagon. All rights reserved.
//

import Foundation


class DataLoader {
    var fetchData: GetDailyWeatherData?
    
    func getData() {
        
        let url = "https://api.openweathermap.org/data/2.5/weather?id=2332785&units=metric&appid=73d46ec792f7188ca13af020d5a05ecf"
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                print("something went wrong")
                return
            }
            var results: WeatherDataModel?
            do {
                results = try JSONDecoder().decode(WeatherDataModel.self, from: data)
            }
            catch {
                print("failed to convert \(error.localizedDescription)")
            }
            
            guard let json = results else {
                return
            }
            self.fetchData?.getDailyWeatherData(value: json)
        })
        task.resume()
        
    }
}
