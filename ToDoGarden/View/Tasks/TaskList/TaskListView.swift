//
//  TaskListView.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 15.01.2022.
//

import SwiftUI

struct TaskListView: View {
    
    @State private var refresh: Bool = false
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var interactor: TasksInteractor
    
    var loadingState: AppState.LoadingState { appState.loadingState }
    
    @Binding var date: Date
    
    @State private var selectedTask: Task?
    
    var body: some View {
        VStack {
            TaskListHeader(date: $date, onTapAdd: { addTask() })
            TaskListResourcesView()
                .padding()
            ScrollView {
                RefreshIndicator(needsRefresh: $refresh) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        interactor.getTasks()
                        refresh = false
                    }
                }
                VStack {
                    switch loadingState {
                    case .idle:
                        Spacer(minLength: 200)
                        Text(Strings.addFirstTask)
                            .multilineTextAlignment(.center)
                            .opacity(0.5)
                    default:
                        TaskListContainer(selectedTask: $selectedTask, date: $date)
                            .padding()
                    }
                }
            }
            .coordinateSpace(name: RefreshIndicator.coordinateSpaceName)
            .sheet(item: $selectedTask, onDismiss: nil, content: { task in
                TaskDetailView(interactor: interactor, task: task)
            })
        }
        .background(Color.backgroundColor
                        .edgesIgnoringSafeArea(.all))
    }
    
    func addTask() {
        let nextOrderID = appState.tasks.map({$0.orderID}).sorted().last
        selectedTask = Task.newTask(orderID: (nextOrderID ?? 0) + 1, date: date)
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



