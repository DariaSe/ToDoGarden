//
//  TaskListContainer.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 12.02.2022.
//

import SwiftUI

struct TaskListContainer: View {
    
    enum ContentState {
        case empty
        case onlyActive
        case onlyDone
        case activeAndDone
    }
    
    var contentState: ContentState {
        if tasksActive.isEmpty && tasksCompleted.isEmpty { return .empty }
        else if !tasksActive.isEmpty && tasksCompleted.isEmpty { return .onlyActive }
        else if tasksActive.isEmpty && !tasksCompleted.isEmpty { return .onlyDone }
        else { return .activeAndDone }
    }
    
    @EnvironmentObject var appState: AppState
    
    @Binding var selectedTask: Task?
    @Binding var date: Date
    
    var tasksActive: [TaskViewModel] { appState.tasksActive }
    var tasksCompleted: [TaskViewModel] { appState.tasksCompleted }
    
    var body: some View {
        VStack {
            switch contentState {
            case .empty:
                Text(Strings.noTasks)
            
            case .onlyActive:
                TaskListVStack(selectedTask: $selectedTask, date: $date, tasks: tasksActive)
            
            case .onlyDone:
                Text(Strings.allDone)
                Divider().padding(.horizontal, 40)
                TaskListVStack(selectedTask: $selectedTask, date: $date, tasks: tasksCompleted)
                
            default:
                TaskListVStack(selectedTask: $selectedTask, date: $date, tasks: tasksActive)
                Divider().padding(.horizontal, 40)
                TaskListVStack(selectedTask: $selectedTask, date: $date, tasks: tasksCompleted)
            }
        }
    }
}

struct TaskListContainer_Previews: PreviewProvider {
    static var previews: some View {
        TaskListContainer(selectedTask: .constant(Task.sample[0]), date: .constant(Date()))
    }
}
