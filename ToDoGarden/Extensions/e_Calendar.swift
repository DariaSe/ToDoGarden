//
//  e_Calendar.swift
//  ToDoGame
//
//  Created by Дарья Селезнёва on 16.06.2021.
//

import Foundation

extension Calendar {
    
    var localWeekdaySymbols: [String] {
        var symbols: [String] = []
        
        let dateFormatter = DateFormatter()
        let language = Locale.preferredLanguages.first
        dateFormatter.dateFormat = "EE" // two letters for weekday
        if let language = language {
            dateFormatter.locale = Locale(identifier: language)
        }
        
        let today = Date()
        let weekStart = Calendar.current.dateInterval(of: .weekOfYear, for: today)!.start
        let weekEnd = Calendar.current.dateInterval(of: .weekOfYear, for: today)!.end.addingTimeInterval(-86400)
        let range = Calendar.current.range(from: weekStart, to: weekEnd)
        for date in range {
            let daySymbol = dateFormatter.string(from: date).uppercased()
            symbols.append(daySymbol)
        }
        return symbols
    }
    
    func range(from: Date, to: Date) -> [Date] {
        // in case "from" date is more than "to" date,
        // it should return an empty array:
        if from > to { return [Date]() }

        var tempDate = from
        var array = [tempDate]

        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }

        return array
    }
    
    func extendedMonth(containing date: Date) -> [Date] {
        let firstMonthDay = Calendar.current.dateInterval(of: .month, for: date)!.start
        let firstDay = Calendar.current.dateInterval(of: .weekOfYear, for: firstMonthDay)!.start
        
        let firstDayOfNextMonth = Calendar.current.dateInterval(of: .month, for: date)!.end
        let lastMonthDay = Calendar.current.date(byAdding: .day, value: -1, to: firstDayOfNextMonth)!
        let lastDay = Calendar.current.dateInterval(of: .weekOfYear, for: lastMonthDay)!.end
        let lastWeekDay = Calendar.current.date(byAdding: .day, value: -1, to: lastDay)!
        return Calendar.current.range(from: firstDay, to: lastWeekDay)
    }
}
