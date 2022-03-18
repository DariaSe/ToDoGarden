//
//  InMemoryTasksWorker.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 17.03.2022.
//

import Foundation

class InMemoryTasksWorker {
    
    static func toggleTaskCompletion(taskID: Int, in tasks: inout [Task], on date: Date) {
        guard let task = tasks.first(where: {$0.id == taskID}) else { return }
        var updatedTask = task
        if updatedTask.executionLog.contains(date.dayStart) {
            updatedTask.executionLog = updatedTask.executionLog.without(date.dayStart)
        }
        else {
            updatedTask.executionLog.append(date.dayStart)
        }
        tasks.replace(task, with: updatedTask)
    }
    
    static func saveTask(_ task: Task, in tasks: inout [Task]) {
        if tasks.first(where: {$0.id == task.id}) != nil {
            tasks.updateExisting(with: task)
        }
        else {
            tasks.append(task)
        }
    }
    
    static func deleteTask(taskID: Int, in tasks: inout [Task]) {
        guard let task = tasks.first(where: {$0.id == taskID}) else { return }
        tasks = tasks.without(task)
    }
}
