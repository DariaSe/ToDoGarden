//
//  TaskDetailView.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 21.01.2022.
//

import SwiftUI

struct TaskDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var interactor: TasksInteractor
    
    let task: Task
//    @StateObject private var editingTask: Task
    
    init(interactor: TasksInteractor, task: Task) {
        self.interactor = interactor
        self.task = task
        self._isNew = State(initialValue: task.title.isEmpty)
        self._title = State(initialValue: task.title)
        self._startDate = State(initialValue: task.startDate)
        self._isRepeating = State(initialValue: task.recurrenceRule != nil)
        if let recurrenceRule = task.recurrenceRule {
            self._recurrenceType = State(initialValue: recurrenceRule.recurrenceType)
            self._recurrenceFrequency = State(initialValue: recurrenceRule.recurrenceFrequency ?? .daily)
            self._recurrenceInterval = State(initialValue: recurrenceRule.interval)
            self._selectedWeekdays = State(initialValue: recurrenceRule.weekdays)
        }
        self._isNotificationOn = State(initialValue: task.notificationDate != nil)
        self._notificationDate = State(initialValue: task.notificationDate ?? Date())
        self._isColorSelected = State(initialValue: task.color != nil)
        self._color = State(initialValue: task.color ?? 0)
    }
    
    @State var isNew : Bool = true
    @State private var title : String = ""
    @State private var startDate : Date = Date().addingTimeInterval(86400)
    
    @State private var isRepeating : Bool = true
    @State private var recurrenceType : RecurrenceRule.RecurrenceType = .regular
    @State private var recurrenceFrequency : RecurrenceFrequency = .daily
    @State private var recurrenceInterval : Int = 0
    @State private var selectedWeekdays : [Int] = []
    
    @State private var isNotificationOn : Bool = false
    @State private var notificationDate : Date = Date()
    
    @State private var isColorSelected: Bool = false
    @State private var color : Int?
    
    @State private var notes : String = ""
    
    @State private var isShowingValidationWarning : Bool = false
    @State private var isShowingDeletionWarning : Bool = false
    @State private var isShowingActivityIndicator : Bool = false
    @State private var isShowingErrorMessage : Bool = false
    
    var body: some View {
        ScrollView {
            ZStack {
                VStack(spacing: 20) {
                    // MARK: - Header and close button
                    ZStack {
                        Text(isNew ? Strings.newTask : Strings.task)
                            .font(.system(.title2, design: .rounded))
                        HStack {
                            Spacer()
                            Button {
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                Image(systemName: "xmark")
                                    .foregroundColor(.buttonColor)
                                    .font(.system(.headline, design: .rounded))
                            }
                            .frame(width: 60, height: 60)
                        }
                    }
                    // MARK: - Title
                    TextField(Strings.taskTitle, text: $title)
                        .font(.system(.body, design: .rounded))
                        .padding()
                        .background(Capsule().fill(Color.textControlsBGColor))
                    // MARK: - Start date
                    TaskDetailDateView(startDate: $startDate, isRecurring: task.recurrenceRule != nil)
                    // MARK: - Recurrence
                    TaskDetailRecurrenceView(isRepeating: $isRepeating, recurrenceType: $recurrenceType, recurrenceFrequency: $recurrenceFrequency, interval: $recurrenceInterval, selectedWeekdays: $selectedWeekdays)
                    // MARK: - Notification
                    TaskDetailNotificationView(isNotificationOn: $isNotificationOn, notificationDate: $notificationDate)
                    // MARK: - Color
                    TaskDetailColorView(isColorSelected: $isColorSelected, color: $color)
                    // MARK: - Notes
                    TaskDetailNotesView(notes: $notes)
                    // MARK: - Save button
                    VStack {
                        Button {
                            isShowingValidationWarning = updatedTask.validationWarning != nil
                            if !isShowingValidationWarning {
                                saveTask()
                            }
                        } label: {
                            ZStack {
                                Capsule()
                                    .inset(by: 8)
                                    .fill(Color.buttonColor)
                                Text(Strings.save)
                                    .font(.system(.headline, design: .rounded))
                                    .foregroundColor(Color.white)
                            }
                        }
                        .alert(isPresented: $isShowingValidationWarning, content: {
                            Alert(title: Text(updatedTask.validationWarning ?? ""))
                        })
                        .frame(width: 160, height: 60)
                        // MARK: - Delete button
                        if !isNew {
                            Button {
                                isShowingDeletionWarning = true
                            } label: {
                                Text(Strings.deleteTask)
                                    .foregroundColor(Color.destructiveColor)
                                    .font(.system(.headline, design: .rounded))
                            }
                            .alert(isPresented: $isShowingDeletionWarning) {
                                Alert.taskDeletion {
                                    interactor.delete(taskID: task.id) { success in
                                        if success {
                                            presentationMode.wrappedValue.dismiss()
                                        }
                                        else {
                                            showError()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                // MARK: - Activity Indicator
                if isShowingActivityIndicator {
                    ProgressView()
                }
                if isShowingErrorMessage {
                    ErrorMessage()
                }
            }
            .padding()
        }
        .onAppear {
            UITextView.appearance().backgroundColor = .clear
        }
    }
    
    var updatedTask: Task {
        if recurrenceType == .withIntervals && recurrenceInterval == 1 {
            recurrenceType = .regular
        }
        let recurrenceRule = isRepeating ? RecurrenceRule(recurrenceType: recurrenceType,
                                                          recurrenceFrequency: recurrenceFrequency,
                                                          interval: recurrenceInterval,
                                                          weekdays: selectedWeekdays) : nil
        var updatedTask = Task(orderID: task.orderID,
                               title: title,
                               startDate: startDate,
                               recurrenceRule: recurrenceRule,
                               notificationDate: isNotificationOn ? notificationDate : nil,
                               color: isColorSelected ? color : nil,
                               notes: notes)
        updatedTask.id = task.id
        return updatedTask
    }
    
    func saveTask() {
        isShowingActivityIndicator = true
        interactor.save(task: updatedTask) { success in
            isShowingActivityIndicator = false
            if success {
                presentationMode.wrappedValue.dismiss()
            }
            else {
                showError()
            }
        }
    }
    
    func showError() {
        withAnimation(.easeOut(duration: 0.2)) {
            isShowingErrorMessage = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeInOut(duration: 0.2)) {
                isShowingErrorMessage = false
            }
        }
    }
}

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TaskDetailView(interactor: TasksInteractor(appState: AppState()), task: Task(orderID: 1, title: "Some task", recurrenceRule: RecurrenceRule.sample1,  color: 2))
            TaskDetailView(interactor: TasksInteractor(appState: AppState()), task: Task(orderID: 1, title: "Some task", recurrenceRule: RecurrenceRule.sample3,  color: 2))
                .previewDevice("iPhone 8")
            
        }
    }
}




