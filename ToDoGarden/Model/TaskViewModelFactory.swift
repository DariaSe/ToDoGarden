//
//  TaskViewModelFactory.swift
//  ToDoGame
//
//  Created by Дарья Селезнёва on 17.05.2021.
//

import Foundation

class TaskViewModelFactory {
    
    func makeTaskViewModel(from task: Task, date: Date) -> TaskViewModel? {
        guard task.recurrenceRule != nil else {
            return singleTaskViewModel(from: task, date: date)
        }
        // search if there is executed task on that day
        let executedOnDate = task.executionLog.map { $0.dayStart }.filter { $0 == date.dayStart }
        if !executedOnDate.isEmpty {
            return task.viewModel(isDone: true, date: executedOnDate.first!)
        }
        else {
            return recurrenceTaskViewModel(from: task, date: date)
        }
        
    }
    
    private func singleTaskViewModel(from task: Task, date: Date) -> TaskViewModel? {
        // if task is already executed
        if let executionDate = task.executionLog.first {
            return executionDate ==^ date ? task.viewModel(isDone: true, date: executionDate) : nil
        }
        // if task is active
        else {
            return task.startDate ==^ date ? task.viewModel(isDone: false, date: task.startDate) : nil
        }
    }
    
    private func recurrenceTaskViewModel(from task: Task, date: Date) -> TaskViewModel? {
        let startDate = task.startDate
        guard let recurrenceRule = task.recurrenceRule else { return nil }
        return date.matches(startDate: startDate, recurrenceRule: recurrenceRule) ? task.viewModel(isDone: false, date: date) : nil
    }
}
