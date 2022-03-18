//
//  TasksRepository.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 17.03.2022.
//

import Foundation

final class TasksRepository: TasksRepositoryLogic {
    
    private var apiService: TasksRepositoryLogic = TasksAPIServiceMock()
    private var localStorageService: TasksRepositoryLogic = TasksLocalStorageService()
    
    func getTasks(completion: @escaping ([Task]?, Error?) -> ()) {
        apiService.getTasks(completion: { [weak self] tasks, error in
            if let error = error {
                self?.localStorageService.getTasks(completion: { localTasks, localError in
                    if localError != nil {
                        completion(nil, error)
                    }
                    else {
                        completion(tasks, error)
                    }
                })
            }
            else if let tasks = tasks, error == nil {
                completion(tasks, nil)
            }
        })
    }
    
    func toggleTaskCompletion(taskID: Int, date: Date, completion: @escaping (Bool, Error?) -> ()) {
        apiService.toggleTaskCompletion(taskID: taskID, date: date) { [weak self] success, error in
            if !success, let error = error {
                completion(false, error)
            }
            else {
                self?.localStorageService.toggleTaskCompletion(taskID: taskID, date: date) { success, localError in
                    if let localError = localError {
                        completion(true, localError)
                    }
                    else {
                        completion(true, nil)
                    }
                }
            }
        }
    }
    
    func saveReorderedTasks(_ tasks: [Task], completion: @escaping (Bool, Error?) -> ()) {
        
    }
    
    func save(task: Task, completion: @escaping (Bool, Error?) -> ()) {
        apiService.save(task: task) { [weak self] success, error in
            if !success, let error = error {
                completion(false, error)
            }
            else {
                self?.localStorageService.save(task: task, completion: { success, localError in
                    if let localError = localError {
                        completion(true, localError)
                    }
                    else {
                        completion(true, nil)
                    }
                })
            }
        }
    }
    
    func deleteTask(taskID: Int, completion: @escaping (Bool, Error?) -> ()) {
        apiService.deleteTask(taskID: taskID) { [weak self] success, error in
            if !success, let error = error {
                completion(false, error)
            }
            else {
                self?.localStorageService.deleteTask(taskID: taskID) { success, localError in
                    if let localError = localError {
                        completion(true, localError)
                    }
                    else {
                        completion(true, nil)
                    }
                }
            }
        }
    }
}
