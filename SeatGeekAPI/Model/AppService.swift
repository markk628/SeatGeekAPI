//
//  AppService.swift
//  SeatGeekAPI
//
//  Created by Mark Kim on 2/11/21.
//

import UIKit

struct AppService {
        
    //MARK: Converting Dates
    static func dateToString(date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: date)!
    }
    
    static func formatDate(date: String) -> String {
        let formattedDate = dateToString(date: date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d yyyy"
        return dateFormatter.string(from: formattedDate)
    }
    
    //MARK: Converting Time
    static func timeToString(time: String) -> Date {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        return timeFormatter.date(from: time)!
    }
    
    static func formatTime(time: String) -> String {
        let formattedTime = timeToString(time: time)
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        return timeFormatter.string(from: formattedTime)
    }
}
