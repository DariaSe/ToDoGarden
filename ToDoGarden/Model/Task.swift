//
//  Task.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 20.01.2022.
//

import Foundation
import SwiftUI

class Task: Codable, Orderable, Identifiable, ObservableObject {
    
    var id: Int = Int.random(in: 1...Int.max)
    @Published var orderID: Int
    @Published var title: String = ""
    @Published var startDate: Date = Date()
    @Published var recurrenceRule: RecurrenceRule?
    @Published var executionLog: [Date] = []
    var tasksCompleted: Int {
        return executionLog.count
    }
    var tasksTotal: Int {
        var date = startDate
        var taskModels = [TaskViewModel]()
        repeat {
            if let taskModel = self.taskViewModel(date: date) {
                taskModels.append(taskModel)
            }
            date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        } while date <=^ Date()
        return taskModels.count
    }
    @Published var notificationDate: Date?
    var notificationTime: String? {
        guard let notificationDate = notificationDate else { return nil }
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: notificationDate)
    }
    @Published var color: Int?
    @Published var notes: String = ""
    
    init(orderID: Int, title: String, recurrenceRule: RecurrenceRule?, color: Int?) {
        self.orderID = orderID
        self.title = title
        self.recurrenceRule = recurrenceRule
        self.color = color
    }
    
    func viewModel(isDone: Bool, date: Date) -> TaskViewModel {
        return TaskViewModel(task: self, isDone: isDone, date: date)
    }
    
    func taskViewModel(date: Date) -> TaskViewModel? {
        guard self.recurrenceRule != nil else {
            return singleTaskViewModel(date: date)
        }
        // search if there is executed task on that day
        let executedOnDate = self.executionLog.map { $0.dayStart }.filter { $0 == date.dayStart }
        if !executedOnDate.isEmpty {
            return self.viewModel(isDone: true, date: executedOnDate.first!)
        }
        else {
            return recurrenceTaskViewModel(date: date)
        }
        
    }
    
    private func singleTaskViewModel(date: Date) -> TaskViewModel? {
        // if task is already executed
        if let executionDate = self.executionLog.first {
            return executionDate ==^ date ? self.viewModel(isDone: true, date: executionDate) : nil
        }
        // if task is active
        else {
            return startDate ==^ date ? self.viewModel(isDone: false, date: startDate) : nil
        }
    }
    
    private func recurrenceTaskViewModel(date: Date) -> TaskViewModel? {
        guard let recurrenceRule = recurrenceRule else { return nil }
        return date.matches(startDate: startDate, recurrenceRule: recurrenceRule) ? self.viewModel(isDone: false, date: date) : nil
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
    
    func copy() -> Task {
        let copyTask = Task(orderID: self.orderID, title: self.title, recurrenceRule: self.recurrenceRule, color: self.color)
        copyTask.id = self.id
        copyTask.startDate = self.startDate
        copyTask.executionLog = self.executionLog
        copyTask.notificationDate = self.notificationDate
        copyTask.notes = self.notes
        return copyTask
    }
    
    static func newTask(orderID: Int) -> Task {
        Task(orderID: orderID, title: "", recurrenceRule: nil, color: 0)
    }
    
    static var sample: [Task] { [
        Task(orderID: 1, title: "Task 1", recurrenceRule: RecurrenceRule.sample1,  color: 2),
        Task(orderID: 2, title: "Task 2", recurrenceRule: RecurrenceRule.sample2, color: 6),
        Task(orderID: 3, title: "Task 3", recurrenceRule: RecurrenceRule.sample3, color: 8),
        Task(orderID: 4, title: "Task 4", recurrenceRule: nil, color: 2)
    ] }
    
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
    
    required init(from decoder: Decoder) throws {
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
