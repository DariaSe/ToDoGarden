//
//  TaskViewModel.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 20.01.2022.
//

import Foundation

struct TaskViewModel: Identifiable {
    
    var id: Int
    var orderID: Int
    var title: String
    var isDone: Bool
    var date: Date
    var color: Int?
    
    static var sample: [TaskViewModel] { [
        TaskViewModel(id: 1, orderID: 1, title: "Task 1", isDone: true, date: Date(), color: 2),
        TaskViewModel(id: 2, orderID: 2, title: "Task 2", isDone: false, date: Date(), color: 6),
        TaskViewModel(id: 3, orderID: 3, title: "Task 3", isDone: false, date: Date(), color: 8),
        TaskViewModel(id: 4, orderID: 4, title: "Task 4", isDone: true, date: Date(), color: 2)
    ] }
    
    var dict: [String : Any] {
        return ["id" : id, "orderID": orderID, "title" : title, "isDone" : isDone, "date" : date, "color" : color ?? 1]
    }
    
    static func recreatedFromDict(_ dict: [String : Any]) -> TaskViewModel? {
        guard let id = dict["id"] as? Int,
              let orderID = dict["orderID"] as? Int,
              let title = dict["title"] as? String,
              let isDone = dict["isDone"] as? Bool,
              let date = dict["date"] as? Date else { return nil }
        let color = dict["color"] as? Int
        return TaskViewModel(id: id, orderID: orderID, title: title, isDone: isDone, date: date, color: color)}
}

extension TaskViewModel: Comparable {
    
    static func < (lhs: TaskViewModel, rhs: TaskViewModel) -> Bool {
        return lhs.orderID < rhs.orderID
    }
    
    static func == (lhs: TaskViewModel, rhs: TaskViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
}
