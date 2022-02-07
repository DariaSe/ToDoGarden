//
//  TasksInteractor.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 31.01.2022.
//

import Foundation
import Combine

class TasksInteractor {
    
    var subscriptions: [AnyCancellable] = []
    
    func setCompletedOrCancel(taskID: Int) {
        print("Triggered")
    }
    
    func save(task: Task) {
        
    }
    
    func delete(task: Task, completion: @escaping (Bool) -> Void) {
        // api call
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            completion(false)
        }
    }
}
