//
//  Task.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 20.01.2022.
//

import Foundation
import SwiftUI

class Task: Orderable, Identifiable, ObservableObject {
    
    var id: Int = Int.random(in: 1...Int.max)
    var orderID: Int = 0
    var title: String = ""
    @Published var startDate: Date = Date()
    var recurrenceRule: RecurrenceRule?
    var executionLog: [Date] = []
    var tasksCompleted: Int {
        return executionLog.count
    }
    var tasksTotal: Int {
        var date = startDate
        var taskModels = [TaskViewModel]()
        let factory = TaskViewModelFactory()
        repeat {
            if let taskModel = factory.makeTaskViewModel(from: self, date: date) {
                taskModels.append(taskModel)
            }
            date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        } while date <=^ Date()
        return taskModels.count
    }
    var notificationDate: Date?
    var color: Int?
    var notes: String = ""
    
    init(orderID: Int, title: String, recurrenceRule: RecurrenceRule?, color: Int) {
        self.orderID = orderID
        self.title = title
        self.recurrenceRule = recurrenceRule
        self.color = color
    }
    
    func viewModel(isDone: Bool, date: Date) -> TaskViewModel {
        return TaskViewModel(id: id, orderID: orderID, title: title, isDone: isDone, date: date, color: color)
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
    
    static func newTask(orderID: Int) -> Task {
        Task(orderID: orderID, title: "", recurrenceRule: nil, color: 0)
    }
    
    static var sample: [Task] { [
        Task(orderID: 1, title: "Task 1", recurrenceRule: RecurrenceRule.sample1,  color: 2),
        Task(orderID: 2, title: "Task 2", recurrenceRule: RecurrenceRule.sample2, color: 6),
        Task(orderID: 3, title: "Task 3", recurrenceRule: RecurrenceRule.sample3, color: 8),
        Task(orderID: 4, title: "Task 4", recurrenceRule: nil, color: 2)
    ] }
    
//    //MARK: Decoding and encoding
//
//    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//    static let archiveURL = documentsDirectory.appendingPathComponent("tasks").appendingPathExtension("plist")
//
//    static func saveToFile(tasks: [Task]) {
//        let propertyListEncoder = PropertyListEncoder()
//        let encodedTasks = try? propertyListEncoder.encode(tasks)
//        try? encodedTasks?.write(to: archiveURL, options: .noFileProtection)
//    }
//
//    static func loadFromFile() -> [Task]? {
//        let propertyListDecoder = PropertyListDecoder()
//        guard let retrievedTasksData = try? Data(contentsOf: archiveURL) else { return nil }
//        return try? propertyListDecoder.decode(Array<Task>.self, from: retrievedTasksData)
//    }
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
