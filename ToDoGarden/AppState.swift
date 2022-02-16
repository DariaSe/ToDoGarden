//
//  AppState.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 31.01.2022.
//

import Foundation
import SwiftUI

class AppState: ObservableObject {
    
    enum LoadingState {
        case idle
        case loading
        case success
        case error
    }
    
    @Published var loadingState: LoadingState = .idle
    
    @Published var tasks: [Task] = []
    
    @Published var date = Date()
    
    var tasksActive: [TaskViewModel] {
        tasks.compactMap({$0.taskViewModel(date: date)}).filter({!$0.isDone})
    }
    var tasksCompleted: [TaskViewModel] {
        tasks.compactMap({$0.taskViewModel(date: date)}).filter({$0.isDone})
    }
    
}
