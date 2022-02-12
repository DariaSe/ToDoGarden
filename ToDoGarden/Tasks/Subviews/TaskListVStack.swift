//
//  TaskListVStack.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 11.02.2022.
//

import SwiftUI

struct TaskListVStack: View {
    
    @Binding var selectedTask: Task?
    @Binding var date: Date
    
    let tasks: [TaskViewModel]
    
    var body: some View {
        VStack {
            ForEach(tasks) { viewModel in
                TaskCell(viewModel: viewModel) {
                    selectedTask = viewModel.task.copy()
                }
                .frame(height: 80)
                .buttonStyle(TaskListButtonStyle())
            }
        }
    }
}

struct TaskListVStack_Previews: PreviewProvider {
    static var previews: some View {
        TaskListVStack(selectedTask: .constant(nil), date: .constant(Date()), tasks: TaskViewModel.sample)
    }
}
