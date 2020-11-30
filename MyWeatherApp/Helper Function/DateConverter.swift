//
//  DateConverter.swift
//  MyWeatherApp
//
//  Created by Decagon on 16/09/2020.
//  Copyright © 2020 Decagon. All rights reserved.
//

import UIKit

class DateConverter {
    func convertDate(_ date: String) -> String? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let todayDate = formatter.date(from: date) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        let weekdaysArray = ["","Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        return weekdaysArray[weekDay]
    }
}
