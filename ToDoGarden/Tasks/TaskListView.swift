//
//  TaskListView.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 15.01.2022.
//

import SwiftUI

struct TaskListView: View {
    
    @EnvironmentObject var appState: AppState
    
    let interactor = TasksInteractor()
    let taskViewModelFactory = TaskViewModelFactory()
    
    @State private var isCalendarShown: Bool = false
    @State var date = Date()
    
    @State private var selectedTask: Task?
    
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
                LazyVStack {
                    ForEach(appState.tasks) { task in
                        if let viewModel = taskViewModelFactory.makeTaskViewModel(from: task, date: date) {
                            Button {
                                selectedTask = task
                            } label: {
                                TaskCell(color: Color.taskColors[task.color ?? 0],
                                         text: task.title,
                                         tasksDone: task.tasksCompleted,
                                         tasksTotal: task.tasksTotal,
                                         notificationTime: nil,
                                         isDone: viewModel.isDone,
                                         onTapDone: {
                                    interactor.setCompletedOrCancel(taskID: task.id)
                                })
                            }
                            .frame(height: 76)
                            .buttonStyle(TaskListButtonStyle())
                        }
                    }
                }
                .padding()
            }
        }
        .sheet(item: $selectedTask, onDismiss: nil, content: { task in
            TaskDetailView(interactor: interactor, task: task, isNew: task.title.isEmpty)
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
            TaskListView()
                .environmentObject(AppState())
            TaskListView()
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
