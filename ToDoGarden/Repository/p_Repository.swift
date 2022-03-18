//
//  p_Repository.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 07.03.2022.
//

import Foundation

protocol TasksRepositoryLogic {
    
    func getTasks(completion: @escaping ([Task]?, Error?) -> ())
    func toggleTaskCompletion(taskID: Int, date: Date, completion: @escaping (Bool, Error?) -> ())
    func saveReorderedTasks(_ tasks: [Task], completion: @escaping (Bool, Error?) -> ())
    func save(task: Task, completion: @escaping (Bool, Error?) -> ())
    func deleteTask(taskID: Int, completion: @escaping (Bool, Error?) -> ())
    
}

protocol GameRepositoryLogic {
    
    
}
