//
//  weatherDataModel.swift
//  MyWeatherApp
//
//  Created by Decagon on 14/09/2020.
//  Copyright © 2020 Decagon. All rights reserved.
//

import UIKit

struct WeatherDataModel: Codable {
    var main: Main
    var weather: [Weather]
}

struct Main: Codable {
    let temp, temp_min, temp_max: Double
}

struct Weather: Codable {
    let main: String
}
