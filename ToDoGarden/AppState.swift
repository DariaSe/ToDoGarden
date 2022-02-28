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
    
    @Published var loadingState : LoadingState = .idle
    
    @Published var tasks : [Task] = [] {
        didSet {
            sortTasks()
        }
    }
    
    @Published var date = Date() {
        didSet {
            sortTasks()
        }
    }
    
    func sortTasks() {
        tasksActive = tasks
            .filter({ $0.appearsOnDate(date) })
            .filter({!$0.isDoneOnDate(date)})
            .sorted()
        tasksCompleted = tasks
            .filter({ $0.appearsOnDate(date) })
            .filter({$0.isDoneOnDate(date)})
            .sorted()
    }
    
    @Published var tasksActive : [Task] = []
    @Published var tasksCompleted : [Task] = []
    
    enum ContentState {
        case empty
        case onlyActive
        case onlyDone
        case activeAndDone
    }
    
    var contentState : ContentState {
        if tasksActive.isEmpty && tasksCompleted.isEmpty { return .empty }
        else if !tasksActive.isEmpty && tasksCompleted.isEmpty { return .onlyActive }
        else if tasksActive.isEmpty && !tasksCompleted.isEmpty { return .onlyDone }
        else { return .activeAndDone }
    }
}
