//
//  TasksInteractor.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 31.01.2022.
//

import Foundation
import Combine
import SwiftUI

class TasksInteractor: ObservableObject {
    
    var appState : AppState
    
//    var subscriptions: [AnyCancellable] = []
    
    init(appState: AppState) {
        self.appState = appState
        appState.date = Date().dayStart
    }
    
    
    func getTasks() {
        appState.loadingState = .loading
        // api call
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            var tasks = Task.loadFromFile() ?? []
            for (index, task) in tasks.enumerated() {
                var newTask = task
                newTask.orderID = index
                tasks.updateExisting(with: newTask)
            }
            self.appState.loadingState = tasks.isEmpty ? .idle : .success
            self.appState.tasks = tasks.sorted()
            NotificationService.shared.scheduleNotifications(for: tasks)
        }
    }
    
    func setCompletedOrCancel(taskID: Int) {
        appState.loadingState = .loading
        // api call
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.appState.loadingState = .success
            guard var task = self.appState.tasks.filter({$0.id == taskID}).first else { return }
            let date = self.appState.date
            if task.executionLog.contains(where: {$0 ==^ date}) {
                task.executionLog = task.executionLog.without(date.dayStart)
            }
            else {
                task.executionLog.append(date.dayStart)
            }
            self.appState.tasks.updateExisting(with: task)
            Task.saveToFile(tasks: self.appState.tasks)
        }
    }
    
    func save(task: Task, completion: @escaping (Bool) -> Void) {
        appState.loadingState = .loading
        // api call
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.appState.loadingState = .success
            if let existingTask = self.appState.tasks.filter({$0.id == task.id}).first {
                self.appState.tasks.replace(existingTask, with: task)
            }
            else {
                self.appState.tasks.append(task)
            }
            Task.saveToFile(tasks: self.appState.tasks)
            NotificationService.shared.scheduleNotifications(for: self.appState.tasks)
            completion(true)
        }
    }
    
    func saveReorderedTasks(_ tasks: [Task], completion: @escaping (Bool) -> Void) {
        appState.loadingState = .loading
        // api call
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.appState.loadingState = .success
            for task in tasks {
                self.appState.tasks.updateExisting(with: task)
            }
        }
        self.appState.objectWillChange.send()
        Task.saveToFile(tasks: self.appState.tasks)
    }
    
    func delete(task: Task, completion: @escaping (Bool) -> Void) {
        appState.loadingState = .loading
        // api call
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.appState.loadingState = .success
            self.appState.tasks = self.appState.tasks.without(task)
            Task.saveToFile(tasks: self.appState.tasks)
            NotificationService.shared.scheduleNotifications(for: self.appState.tasks)
            completion(true)
        }
    }
}
