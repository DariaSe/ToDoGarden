//
//  e_Date.swift
//  ToDoGame
//
//  Created by Дарья Селезнёва on 17.05.2021.
//

import Foundation

extension Date {
    
    var midday: Date {
        var components = Calendar.current.dateComponents([.day, .month, .year], from: self)
        components.hour = 12
        components.minute = 0
        return Calendar.current.date(from: components)!
    }
    
    var tomorrow: Date {
        Calendar.current.date(byAdding: .day, value: 1, to: self.dayStart)!
    }
    var yesterday: Date {
        Calendar.current.date(byAdding: .day, value: -1, to: self.dayStart)!
    }
    
    func belongsToMonth(of date: Date) -> Bool {
        let selfMonth = Calendar.current.component(.month, from: self)
        let dateMonth = Calendar.current.component(.month, from: date)
        return selfMonth == dateMonth
    }
    
    var monthAndYear: String {
        let month = Calendar.current.component(.month, from: self)
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateFormat = "YYYY"
        let language = Locale.preferredLanguages.first
        if let language = language {
            formatter.locale = Locale(identifier: language)
        }
        return formatter.standaloneMonthSymbols[month - 1].capitalized + " " + formatter.string(from: self)
    }
    
    var formattedForHeader: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        if self ==^ Date() {
            return Strings.today + ", " + formatter.string(from: self)
        }
        else if self == Date().yesterday {
            return Strings.yesterday + ", " + formatter.string(from: self)
        }
        else if self == Date().tomorrow {
            return Strings.tomorrow + ", " + formatter.string(from: self)
        }
        else {
            return formatter.string(from: self)
        }
    }
    
    static let oneDay: TimeInterval = 86400
}

