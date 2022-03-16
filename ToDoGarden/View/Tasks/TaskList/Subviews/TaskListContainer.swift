//
//  TaskListContainer.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 12.02.2022.
//

import SwiftUI

struct TaskListContainer: View {
    
    @EnvironmentObject var appState: AppState
    
    var contentState : AppState.ContentState { appState.contentState }
    
    @Binding var selectedTask : Task?
    @Binding var date : Date
    
    
    var activeTasksVStack: some View {
        return TaskListVStack(tasks: $appState.tasksActive, selectedTask: $selectedTask, date: $date)
    }
    
    var completedTasksVStack: some View {
        TaskListVStack(tasks: $appState.tasksCompleted, selectedTask: $selectedTask, date: $date)
    }
    
    var body: some View {
        VStack {
            switch contentState {
            case .empty:
                Text(Strings.noTasks)
            case .onlyActive:
                activeTasksVStack
            case .onlyDone:
                Text(Strings.allDone)
                Divider().padding(.horizontal, 40)
                completedTasksVStack
            default:
                activeTasksVStack
                Divider().padding(.horizontal, 40)
                completedTasksVStack
            }
        }
    }
}

struct TaskListContainer_Previews: PreviewProvider {
    static var previews: some View {
        TaskListContainer(selectedTask: .constant(Task.sample[0]), date: .constant(Date()))
            .environmentObject(AppState())
    }
}
