//
//  TasksInteractor.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 31.01.2022.
//

import Foundation
import Combine

class TasksInteractor {
    
    var appState: AppState
    
    var subscriptions: [AnyCancellable] = []
    
    init(appState: AppState) {
        self.appState = appState
    }
    
    func setCompletedOrCancel(taskID: Int, date: Date) {
        // api call
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            guard let task = self.appState.tasks.filter({$0.id == taskID}).first else { return }
            if task.executionLog.contains(where: {$0 ==^ date}) {
                task.executionLog = task.executionLog.without(date.dayStart)
            }
            else {
                task.executionLog.append(date.dayStart)
            }
            self.appState.objectWillChange.send()
            Task.saveToFile(tasks: self.appState.tasks)
        }
    }
    
    func getTasks() {
        appState.tasks = Task.loadFromFile() ?? []
    }
    
    func save(task: Task, completion: @escaping (Bool) -> Void) {
        // api call
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if let existingTask = self.appState.tasks.filter({$0.id == task.id}).first {
                self.appState.tasks.replace(existingTask, with: task)
            }
            else {
                self.appState.tasks.append(task)
            }
            Task.saveToFile(tasks: self.appState.tasks)
            completion(true)
        }
    }
    
    func delete(task: Task, completion: @escaping (Bool) -> Void) {
        // api call
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.appState.tasks = self.appState.tasks.without(task)
            Task.saveToFile(tasks: self.appState.tasks)
            completion(true)
        }
    }
}
