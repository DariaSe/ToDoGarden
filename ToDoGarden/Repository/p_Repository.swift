//
//  p_Repository.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 07.03.2022.
//

import Combine

protocol Repository {
    
    func getTasks()
    func setCompletedOrCancel(taskID: Int) -> AnyPublisher?
    func save(task: Task, completion: @escaping (Bool) -> Void)
    func saveReorderedTasks(_ tasks: [Task], completion: @escaping (Bool) -> Void)
    func delete(task: Task, completion: @escaping (Bool) -> Void)
    
}
