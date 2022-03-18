//
//  TasksAPIService.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 12.02.2022.
//

import Foundation

final class TasksAPIServiceMock: TasksRepositoryLogic {
    
    func getTasks(completion: @escaping ([Task]?, Error?) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            do {
                let tasks = try Task.loadFromFile()
                completion(tasks, nil)
            } catch {
                let sampleTasks = Task.sample
                do {
                    try Task.saveToFile(tasks: sampleTasks)
                    completion(sampleTasks, nil)
                } catch {
                    completion(nil, Task.PlistStorageError.writingError)
                }
            }
        }
    }
    
    func toggleTaskCompletion(taskID: Int, date: Date, completion: @escaping (Bool, Error?) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            completion(true, nil)
        }
    }
    
    func saveReorderedTasks(_ tasks: [Task], completion: @escaping (Bool, Error?) -> ()) {
        
    }
    
    func save(task: Task, completion: @escaping (Bool, Error?) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            completion(true, nil)
        }
    }
    
    func deleteTask(taskID: Int, completion: @escaping (Bool, Error?) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            completion(true, nil)
        }
    }
}
