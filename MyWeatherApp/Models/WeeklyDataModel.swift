//
//  WeeklyDataModel.swift
//  MyWeatherApp
//
//  Created by Decagon on 15/09/2020.
//  Copyright © 2020 Decagon. All rights reserved.
//

import Foundation

struct WeeklyDataModel: Codable {
    let list: [List]
}

struct List: Codable{
    let main: MainClass
    let weather: [WeeklyWeather]
    let day: String
    
    enum CodingKeys: String, CodingKey {
        case main, weather
        case day = "dt_txt"
    }
}

struct MainClass: Codable {
    let temp: Double
    enum CodingKeys: String, CodingKey {
        case temp
    }
}

struct WeeklyWeather: Codable {
    let main: String
}


