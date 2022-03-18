//
//  TasksLocalStorageService.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 17.03.2022.
//

import Foundation

final class TasksLocalStorageService: TasksRepositoryLogic {
    
    func getTasks(completion: @escaping ([Task]?, Error?) -> ()) {
        do {
            let tasks = try Task.loadFromFile()
            completion(tasks, nil)
        } catch { completion(nil, error) }
    }
    
    func toggleTaskCompletion(taskID: Int, date: Date, completion: @escaping (Bool, Error?) -> ()) {
        do {
            var tasks = try Task.loadFromFile() ?? []
            InMemoryTasksWorker.toggleTaskCompletion(taskID: taskID, in: &tasks, on: date)
            do { try Task.saveToFile(tasks: tasks) }
            catch { completion(true, error) }
            completion(true, nil)
        } catch { completion(true, error) }
    }
    
    func saveReorderedTasks(_ tasks: [Task], completion: @escaping (Bool, Error?) -> ()) {
        
    }
    
    func save(task: Task, completion: @escaping (Bool, Error?) -> ()) {
        do {
            var tasks = try Task.loadFromFile() ?? []
            InMemoryTasksWorker.saveTask(task, in: &tasks)
            do { try Task.saveToFile(tasks: tasks) }
            catch { completion(true, error) }
            completion(true, nil)
        } catch { completion(true, error) }
    }
    
    func deleteTask(taskID: Int, completion: @escaping (Bool, Error?) -> ()) {
        do {
            var tasks = try Task.loadFromFile() ?? []
            InMemoryTasksWorker.deleteTask(taskID: taskID, in: &tasks)
            do { try Task.saveToFile(tasks: tasks) }
            catch { completion(true, error) }
            completion(true, nil)
        } catch { completion(true, error) }
    }
}
