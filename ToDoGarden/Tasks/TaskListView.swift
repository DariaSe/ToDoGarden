//
//  TaskListView.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 15.01.2022.
//

import SwiftUI

struct TaskListView: View {
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var interactor: TasksInteractor
    
    @Binding var date: Date
    
    @State private var selectedTask: Task?
    
    var body: some View {
        ScrollView {
            VStack {
                TaskListHeader(date: $date, onTapAdd: { addTask() })
                TaskListContainer(selectedTask: $selectedTask, date: $date)
                .padding()
            }
        }
        .sheet(item: $selectedTask, onDismiss: nil, content: { task in
            TaskDetailView(interactor: interactor, task: task)
        })
        .background(Color.backgroundColor
                        .edgesIgnoringSafeArea(.all))
    }
    
    func addTask() {
        let nextOrderID = appState.tasks.map({$0.orderID}).sorted().last
        selectedTask = Task.newTask(orderID: (nextOrderID ?? 0) + 1)
    }
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TaskListView(date: .constant(Date()))
                .environmentObject(AppState())
                .environmentObject(TasksInteractor(appState: AppState()))
            TaskListView(date: .constant(Date()))
                .environmentObject(AppState())
                .environmentObject(TasksInteractor(appState: AppState()))
                .previewDevice("iPhone 8")
        }
    }
}



