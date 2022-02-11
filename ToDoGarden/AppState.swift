//
//  AppState.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 31.01.2022.
//

import Foundation
import SwiftUI

class AppState: ObservableObject {
    
    @Published var tasks: [Task] = Task.sample
    
    @Published var date = Date()
    
    var tasksActive: [TaskViewModel] {
        tasks.compactMap({$0.taskViewModel(date: date)}).filter({!$0.isDone})
    }
    var tasksCompleted: [TaskViewModel] {
        tasks.compactMap({$0.taskViewModel(date: date)}).filter({$0.isDone})
    }
    
}
