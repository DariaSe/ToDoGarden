//
//  e_Date TaskFactory.swift
//  ToDoGame
//
//  Created by Дарья Селезнёва on 12.07.2021.
//

import Foundation

infix operator ==^
infix operator <^
infix operator >^
infix operator <=^
infix operator >=^

extension Date {
    
    var dayStart: Date {
        let comp = Calendar.current.dateComponents([.year, .month, .day], from: self)
        return Calendar.current.date(from: comp)!
    }
    
    static func ==^(lhs: Date, rhs: Date) -> Bool {
        return lhs.dayStart == rhs.dayStart
    }
    
    static func <^(lhs: Date, rhs: Date) -> Bool {
        return lhs.dayStart < rhs.dayStart
    }
    
    static func >^(lhs: Date, rhs: Date) -> Bool {
        return lhs.dayStart > rhs.dayStart
    }
    
    static func <=^(lhs: Date, rhs: Date) -> Bool {
        return lhs.dayStart <= rhs.dayStart
    }
    
    static func >=^(lhs: Date, rhs: Date) -> Bool {
        return lhs.dayStart >= rhs.dayStart
    }
    
    func matches(startDate: Date, recurrenceRule: RecurrenceRule) -> Bool {
        if let weekdays = recurrenceRule.weekdays {
            let dateWeekday = Calendar.current.ordinality(of: .weekday, in: .weekOfYear, for: self)!
            return weekdays.contains(dateWeekday) && (startDate <=^ self)
        }
        if let recurrenceFrequency = recurrenceRule.recurrenceFrequency, let interval = recurrenceRule.interval {
            let dayInSeconds = 86400
            var dateToIncrement = startDate
            let startDateDay = Calendar.current.component(.day, from: startDate)
            var startDateMonth = Calendar.current.component(.month, from: startDate)
            var startDateYear = Calendar.current.component(.year, from: startDate)
            switch recurrenceFrequency {
            case .daily:
                while dateToIncrement <^ self {
                    dateToIncrement += TimeInterval(dayInSeconds * interval)
                }
            case .weekly:
                while dateToIncrement <^ self {
                    dateToIncrement += TimeInterval(dayInSeconds * interval * 7)
                }
            case .monthly:
                while dateToIncrement <^ self {
                    if startDateMonth < 11 {
                        startDateMonth += interval
                    }
                    else {
                        startDateMonth = 1
                        startDateYear += 1
                    }
                    let newDateComponents = DateComponents(year: startDateYear, month: startDateMonth, day: startDateDay)
                    dateToIncrement = Calendar.current.date(from: newDateComponents)!
                }
            case .yearly:
                while dateToIncrement <^ self {
                    startDateYear += interval
                    let newDateComponents = DateComponents(year: startDateYear, month: startDateMonth, day: startDateDay)
                    dateToIncrement = Calendar.current.date(from: newDateComponents)!
                }
            }
            return dateToIncrement ==^ self
        }
        else { return false }
    }
}
