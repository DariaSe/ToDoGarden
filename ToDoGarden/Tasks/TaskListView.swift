//
//  TaskListView.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 15.01.2022.
//

import SwiftUI

struct TaskListView: View {
    
    enum ViewState {
        case idle
        case noActive
        case loading
        case loadingError
    }
    
    @EnvironmentObject var appState: AppState
    
    var interactor: TasksInteractor
    
    @Binding var date: Date
    
    @State private var isCalendarShown: Bool = false
    
    @State private var selectedTask: Task?
    
    var tasksActive: [TaskViewModel] { appState.tasksActive }
    var tasksCompleted: [TaskViewModel] { appState.tasksCompleted }
    
    var body: some View {
        ScrollView {
            VStack {
                ZStack {
                    CalendarHeaderView(date: $date, isCalendarShown: $isCalendarShown)
                        .frame(maxWidth: UIScreen.main.bounds.width - 90)
                    HStack {
                        Spacer()
                        Button {
                            addTask()
                        } label: {
                            Image(systemName: "plus")
                                .foregroundColor(.black)
                                .font(.system(.headline, design: .rounded))
                        }
                        .frame(width: 60, height: 60)
                    }
                }
                if isCalendarShown {
                    CalendarView(date: $date, isShown: $isCalendarShown)
                }
                if tasksActive.isEmpty {
                    Text("No active tasks")
                }
                else {
                    VStack {
                        ForEach(tasksActive) { viewModel in
                                Button {
                                    selectedTask = viewModel.task.copy()
                                } label: {
                                    TaskCell(viewModel: viewModel) {
                                        interactor.setCompletedOrCancel(taskID: viewModel.id, date: date)
                                    }
                                }
                                .frame(height: 76)
                                .buttonStyle(TaskListButtonStyle())
                            }
                    }
                    .padding()
                }
                if !tasksCompleted.isEmpty {
                    Divider().padding(.horizontal, 40)
                }
                VStack {
                    ForEach(tasksCompleted) { viewModel in
                            Button {
                                selectedTask = viewModel.task.copy()
                            } label: {
                                TaskCell(viewModel: viewModel) {
                                    interactor.setCompletedOrCancel(taskID: viewModel.id, date: date)
                                }
                            }
                            .frame(height: 76)
                            .buttonStyle(TaskListButtonStyle())
                    }
                }
                .padding()
            }
        }
        .onAppear {
            interactor.getTasks()
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
            TaskListView(interactor: TasksInteractor(appState: AppState()), date: .constant(Date()))
                .environmentObject(AppState())
            TaskListView(interactor: TasksInteractor(appState: AppState()), date: .constant(Date()))
                .environmentObject(AppState())
                .previewDevice("iPhone 8")
        }
    }
}


struct TaskListButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .opacity(configuration.isPressed ? 0.85 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
