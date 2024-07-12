//
//  Extension+Date.swift
//  WebSocket
//
//  Created by Salva Moreno on 14/3/24.
//

import Foundation

extension Date {
    var currentDate: Date {
        var dateComponents = DateComponents()
        dateComponents.minute = Calendar.current.component(.minute, from: Date())
        dateComponents.hour = Calendar.current.component(.hour, from: Date())
        dateComponents.day = Calendar.current.component(.day, from: Date())
        dateComponents.month = Calendar.current.component(.month, from: Date())
        dateComponents.year = Calendar.current.component(.year, from: Date())
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        
        return calendar.date(from: dateComponents)!
    }
    
    func convertISO8601StringToDate(dateString: String, dateFormat: String) -> Date? {
        let dateFormatter = ISO8601DateFormatter()

        guard let date = dateFormatter.date(from: dateString) else {
            return nil
        }
        
        return date
    }
    
    func convertDateToString(dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        return dateFormatter.string(from: self)
    }
}
