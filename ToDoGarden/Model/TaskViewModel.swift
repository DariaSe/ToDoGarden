//
//  TaskViewModel.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 20.01.2022.
//

import Foundation

struct TaskViewModel: Identifiable {
    
    var task: Task
    
    var id: Int { task.id }
    var orderID: Int { task.orderID }
    var title: String { task.title }
    var isDone: Bool
    var date: Date
    var color: Int? { task.color }
    
    static var sample: [TaskViewModel] { [
        TaskViewModel(task: Task.sample[0], isDone: true, date: Date()),
        TaskViewModel(task: Task.sample[1], isDone: false, date: Date()),
        TaskViewModel(task: Task.sample[2], isDone: false, date: Date()),
        TaskViewModel(task: Task.sample[3], isDone: true, date: Date())
    ] }
}

extension TaskViewModel: Comparable {
    
    static func < (lhs: TaskViewModel, rhs: TaskViewModel) -> Bool {
        return lhs.orderID < rhs.orderID
    }
    
    static func == (lhs: TaskViewModel, rhs: TaskViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
}
