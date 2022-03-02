//
//  Task.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 20.01.2022.
//

import Foundation
import SwiftUI

struct Task: Codable, Orderable, Identifiable {
    
    // MARK: - Stored properties
    
    var id: Int = Int.random(in: 1...Int.max)
    var orderID: Int
    var title: String = ""
    var startDate: Date = Date()
    var recurrenceRule: RecurrenceRule?
    var executionLog: [Date] = []
    var notificationDate: Date?
    var color: Int?
    var notes: String = ""
    
    // MARK: - Computed properties
    
    var notificationTime: String? {
        guard let notificationDate = notificationDate else { return nil }
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: notificationDate)
    }
    
    var tasksCompleted: Int {
        return executionLog.count
    }
    
    var tasksTotal: Int {
        var date = startDate
        var count = 0
        repeat {
            if self.appearsOnDate(date) {
                count += 1
            }
            date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        } while date <=^ Date()
        return count
    }
    
    var tasksDonePercentage: String {
        return String(Int(round(Double(tasksCompleted) / Double(tasksTotal) * 100))) + "%"
    }
    
    
    func appearsOnDate(_ date: Date) -> Bool {
        if let recurrenceRule = self.recurrenceRule { // if is recurring
            return date.matches(startDate: startDate, recurrenceRule: recurrenceRule)
        }
        else { // if is single
            return startDate ==^ date
        }
    }
    
    func isDoneOnDate(_ date: Date) -> Bool {
        let executedOnDate = self.executionLog.map { $0.dayStart }.filter { $0 ==^ date }
        return !executedOnDate.isEmpty
    }
    
    var closestDate: Date {
        if let recurrenceRule = self.recurrenceRule {
            var date = Date()
            while !date.matches(startDate: startDate, recurrenceRule: recurrenceRule) {
                date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
            }
            return date
        }
        else {
            return startDate
        }
    }
    
    func nextOccurenceDate(from date: Date) -> Date {
        guard let recurrenceRule = self.recurrenceRule else { return startDate }
        var date = date
        while !date.matches(startDate: startDate, recurrenceRule: recurrenceRule) {
            date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        }
        return date
    }
    
    
    // MARK: - Interface helpers
    var validationWarning: String? {
        if title.isEmpty {
            return Strings.emptyTitleAlert
        }
        if let recurrenceRule = recurrenceRule, recurrenceRule.recurrenceType == .withIntervals, recurrenceRule.interval == 0 {
            return Strings.enterInterval
        }
        if let recurrenceRule = recurrenceRule, recurrenceRule.recurrenceType == .onWeekdays, recurrenceRule.weekdays.isEmpty {
            return Strings.selectWeekdays
        }
        else {
            return nil
        }
    }

    
    static func newTask(orderID: Int, date: Date) -> Task {
        Task(orderID: orderID, title: "", startDate: date, recurrenceRule: nil, color: 0)
    }
    
    static var sample: [Task] { [
        Task(orderID: 1, title: "Task 1", recurrenceRule: RecurrenceRule.sample1,  color: 2),
        Task(orderID: 2, title: "Task 2", recurrenceRule: RecurrenceRule.sample2, color: 6),
        Task(orderID: 3, title: "Task 3", recurrenceRule: RecurrenceRule.sample3, color: 8),
        Task(orderID: 4, title: "Task 4", recurrenceRule: nil, color: 2)
    ] }
    
    // MARK: - Init
    init(orderID: Int,
         title: String,
         startDate: Date = Date(),
         recurrenceRule: RecurrenceRule?,
         notificationDate: Date? = nil,
         color: Int?,
         notes: String = "") {
        self.orderID = orderID
        self.title = title
        self.startDate = startDate
        self.recurrenceRule = recurrenceRule
        self.notificationDate = notificationDate
        self.color = color
        self.notes = notes
    }
    
    //MARK: Decoding and encoding
    
    private enum CodingKeys : String, CodingKey {
        case id
        case orderID = "order_id"
        case title
        case startDate = "start_date"
        case executionLog = "execution_log"
        case recurrenceRule = "recurrence_rule"
        case notificationDate = "notification_date"
        case color
        case notes
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        orderID = try values.decode(Int.self, forKey: .orderID)
        title = try values.decode(String.self, forKey: .title)
        startDate = try values.decode(Date.self, forKey: .startDate)
        executionLog = try values.decode([Date].self, forKey: .executionLog)
        recurrenceRule = try values.decode(RecurrenceRule?.self, forKey: .recurrenceRule)
        notificationDate = try values.decode(Date?.self, forKey: .notificationDate)
        color = try values.decode(Int?.self, forKey: .color)
        notes = try values.decode(String.self, forKey: .notes)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(orderID, forKey: .orderID)
        try container.encode(title, forKey: .title)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(executionLog, forKey: .executionLog)
        try container.encode(recurrenceRule, forKey: .recurrenceRule)
        try container.encode(notificationDate, forKey: .notificationDate)
        try container.encode(color, forKey: .color)
        try container.encode(notes, forKey: .notes)
    }
    
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = documentsDirectory.appendingPathComponent("tasks").appendingPathExtension("plist")
    
    static func saveToFile(tasks: [Task]) {
        let propertyListEncoder = PropertyListEncoder()
        let encodedTasks = try? propertyListEncoder.encode(tasks)
        try? encodedTasks?.write(to: archiveURL, options: .noFileProtection)
    }
    
    static func loadFromFile() -> [Task]? {
        let propertyListDecoder = PropertyListDecoder()
        guard let retrievedTasksData = try? Data(contentsOf: archiveURL) else { return nil }
        return try? propertyListDecoder.decode(Array<Task>.self, from: retrievedTasksData)
    }
}

extension Task: Comparable {
    
    static func < (lhs: Task, rhs: Task) -> Bool {
        return lhs.orderID < rhs.orderID
    }
    
    static func == (lhs: Task, rhs: Task) -> Bool {
        return lhs.id == rhs.id
    }
    
}

protocol Orderable {
    var orderID: Int { get set }
}
