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
        case loaded
        case loading
        case error
    }
    
    @EnvironmentObject var appState: AppState
    
    @EnvironmentObject var interactor: TasksInteractor
    
    @Binding var date: Date
    
    @State private var isCalendarShown: Bool = false
    
    @State private var selectedTask: Task?
    
    
    
    @State private var isShowingDeletionWarning: Bool = false
    @State private var isShowingActivityIndicator: Bool = false
    @State private var isShowingErrorMessage: Bool = false
    
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
                TaskListContainer(selectedTask: $selectedTask, date: $date)
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


struct TaskListButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}
