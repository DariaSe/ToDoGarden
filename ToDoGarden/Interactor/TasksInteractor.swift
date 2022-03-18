//
//  TasksInteractor.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 31.01.2022.
//

import Foundation
import SwiftUI

final class TasksInteractor: ObservableObject {
    
    var appState : AppState
    
    var repository: TasksRepositoryLogic = TasksRepository()
    
    //    var subscriptions: [AnyCancellable] = []
    
    init(appState: AppState) {
        self.appState = appState
        appState.date = Date().dayStart
    }
    
    
    func getTasks() {
        appState.loadingState = .loading
        repository.getTasks(completion: { [unowned self] tasks, error in
            DispatchQueue.main.async {
                if let tasks = tasks {
                    self.appState.loadingState = tasks.isEmpty ? .idle : .success
                    self.appState.tasks = tasks
                    NotificationService.shared.scheduleNotifications(for: tasks)
                }
                if let error = error {
                    self.appState.loadingState = .error
                }
            }
        })
    }
    
    func toggleTaskCompletion(taskID: Int) {
        appState.loadingState = .loading
        repository.toggleTaskCompletion(taskID: taskID, date: appState.date, completion: { [unowned self] success, error in
            DispatchQueue.main.async {
                if success {
                    self.appState.loadingState = .success
                    InMemoryTasksWorker.toggleTaskCompletion(taskID: taskID, in: &appState.tasks, on: appState.date)
                }
                if let error = error {
                    self.appState.loadingState = .error
                }
            }
        })
    }
    
    func save(task: Task, completion: @escaping (Bool) -> Void) {
        appState.loadingState = .loading
        repository.save(task: task, completion: { [unowned self] success, error in
            DispatchQueue.main.async {
                if success {
                    self.appState.loadingState = .success
                    InMemoryTasksWorker.saveTask(task, in: &appState.tasks)
                    NotificationService.shared.scheduleNotifications(for: self.appState.tasks)
                    completion(true)
                }
                if let error = error {
                    self.appState.loadingState = .error
                    completion(false)
                }
            }
        })
    }
    
    func saveReorderedTasks(_ tasks: [Task]) {
        appState.loadingState = .loading
        repository.saveReorderedTasks(tasks, completion: { [unowned self] success, error in
            DispatchQueue.main.async {
                if success {
                    appState.loadingState = .success
                    for task in tasks {
                        appState.tasks.updateExisting(with: task)
                    }
                    appState.objectWillChange.send()
                }
                if let error = error {
                    appState.loadingState = .error
                }
            }
        })
    }
    
    func delete(taskID: Int, completion: @escaping (Bool) -> Void) {
        appState.loadingState = .loading
        repository.deleteTask(taskID: taskID, completion: { [unowned self] success, error in
            DispatchQueue.main.async {
                if success {
                    InMemoryTasksWorker.deleteTask(taskID: taskID, in: &appState.tasks)
                    NotificationService.shared.scheduleNotifications(for: appState.tasks)
                    completion(true)
                }
                if let error = error {
                    appState.loadingState = .error
                    completion(false)
                }
            }
        })
    }
}
