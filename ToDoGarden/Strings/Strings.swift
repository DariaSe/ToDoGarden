//
//  Strings.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 19.01.2022.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localizedForCount(_ count: Int) -> String {
        let formatString : String = NSLocalizedString(self, comment: "")
        let resultString : String = String.localizedStringWithFormat(formatString, count)
        return resultString
    }
    
    var localizedGame: String {
        return NSLocalizedString(self, tableName: "Game", comment: "")
    }
}

struct Strings {
    
    static let arrowDown = "\u{25BC}"
    static let arrowUp = "\u{25B2}"
    static let cross = "\u{00D7}"
    static let glasses = "\u{1F60E}"
    
    static let today = "Today".localized
    static let yesterday = "Yesterday".localized
    static let tomorrow = "Tomorrow".localized
    
    static let level = "Level".localized
    
    static let yes = "Yes".localized
    static let no = "No".localized
    
    static let active = "Active".localized
    static let completed = "Completed".localized
    
    static let taskDeletionTitle = "Do you want to delete this task?".localized
    static let taskDeletionMessage = "All scheduled tasks will also be deleted.".localized
    static let delete = "Delete".localized
    static let cancel = "Cancel".localized
    
    static let task = "Task".localized
    static let newTask = "New task".localized
    static let taskTitle = "Task title".localized
    static let notes = "Notes".localized
    static let date = "Date".localized
    static let startDate = "Start date".localized
    static let time = "Time".localized
    static let repeatt = "Repeat".localized
    
    static let daily = "Daily".localized
    static let weekly = "Weekly".localized
    static let monthly = "Monthly".localized
    static let yearly = "Yearly".localized
    
    static let every = "Every".localized
    static let day = "day".localized
    static let week = "week".localized
    static let month = "month".localized
    static let year = "year".localized
    
    static let daysCount = "days_count"
    static let weeksCount = "weeks_count"
    static let monthsCount = "months_count"
    static let yearsCount = "years_count"
    
    static let onWeekdays = "On weekdays:".localized
    
    static let notification = "Notification".localized
    static let oneMBefore = "1 min before".localized
    static let fiveMBefore = "5 min before".localized
    static let fifteenMBefore = "15 min before".localized
    static let thirtyMBefore = "30 min before".localized
    static let oneHBefore = "1 hour before".localized
    static let twoHBefore = "2 hours before".localized
    
    static let color = "Color".localized
    
    static let save = "Save".localized
    static let deleteTask = "Delete task".localized
    
    static let emptyTitleAlert = "A task should have a title".localized
    static let setTimeAlert = "Set time first".localized
    static let enterInterval = "Enter repeat interval".localized
    
}
