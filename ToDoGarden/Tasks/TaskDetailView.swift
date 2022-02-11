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
    @StateObject private var editingTask: Task
    
    init(interactor: TasksInteractor, task: Task) {
        self.interactor = interactor
        self.task = task
        self._editingTask = StateObject(wrappedValue: task)
        self._isNew = State(initialValue: task.title.isEmpty)
        if let recurrenceRule = task.recurrenceRule {
            self._recurrenceType = State(initialValue: recurrenceRule.recurrenceType)
            self._recurrenceFrequency = State(initialValue: recurrenceRule.recurrenceFrequency ?? .daily)
            self._recurrenceInterval = State(initialValue: recurrenceRule.interval)
            self._selectedWeekdays = State(initialValue: recurrenceRule.weekdays)
        }
    }
    
    @State var isNew: Bool = true
    
    @State private var isRepeating: Bool = true
    @State private var recurrenceType: RecurrenceRule.RecurrenceType = .regular
    @State private var recurrenceFrequency: RecurrenceFrequency = .daily
    @State private var recurrenceInterval: Int = 0
    @State private var selectedWeekdays: [Int] = []
    
    @State private var isNotificationOn: Bool = false
    @State private var notificationDate: Date = Date()
    
    @State private var isColorSelected: Bool = false
    
    @State private var isShowingValidationWarning: Bool = false
    @State private var isShowingDeletionWarning: Bool = false
    @State private var isShowingActivityIndicator: Bool = false
    @State private var isShowingErrorMessage: Bool = false
    
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
                    TextField(Strings.taskTitle, text: $editingTask.title)
                        .font(.system(.body, design: .rounded))
                        .padding()
                        .background(Capsule().fill(Color.textControlsBGColor))
                    // MARK: - Start date
                    TaskDetailDateView(startDate: $editingTask.startDate, isRecurring: editingTask.recurrenceRule != nil)
                    // MARK: - Recurrence
                    TaskDetailRecurrenceView(isRepeating: $isRepeating, recurrenceType: $recurrenceType, recurrenceFrequency: $recurrenceFrequency, interval: $recurrenceInterval, selectedWeekdays: $selectedWeekdays)
                    // MARK: - Notification
                    TaskDetailNotificationView(isNotificationOn: $isNotificationOn, notificationDate: $notificationDate)
                    // MARK: - Color
                    TaskDetailColorView(isColorSelected: $isColorSelected, color: $editingTask.color)
                    // MARK: - Notes
                    TaskDetailNotesView(notes: $editingTask.notes)
                    // MARK: - Save button
                    VStack {
                        Button {
                            updateTask()
                            isShowingValidationWarning = editingTask.validationWarning != nil
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
                            Alert(title: Text(editingTask.validationWarning ?? ""), dismissButton: .default(Text("OK")))
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
                                Alert(
                                    title: Text(Strings.taskDeletionTitle),
                                    message: Text(Strings.taskDeletionMessage),
                                    primaryButton: .destructive(Text(Strings.delete), action: {
                                        isShowingActivityIndicator = true
                                        interactor.delete(task: task) { success in
                                            isShowingActivityIndicator = false
                                            if success {
                                                presentationMode.wrappedValue.dismiss()
                                            }
                                            else {
                                                showError()
                                            }
                                        }
                                    }),
                                    secondaryButton: .default(Text(Strings.cancel), action: {}))
                            }
                        }
                    }
                }
                // MARK: - Activity Indicator
                if isShowingActivityIndicator {
                    ProgressView()
                        .progressViewStyle(.circular)
                }
                if isShowingErrorMessage {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.destructiveColor)
                            .frame(width: 300, height: 60)
                        Text(Strings.errorMessage)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }
                }
            }
            .padding()
        }
        .onAppear {
            UITextView.appearance().backgroundColor = .clear
            isRepeating = editingTask.recurrenceRule != nil
            isNotificationOn = editingTask.notificationDate != nil
            notificationDate = editingTask.notificationDate ?? Date()
            isColorSelected = editingTask.color != nil
        }
    }
    
    func updateTask() {
        if recurrenceType == .withIntervals && recurrenceInterval == 1 {
            recurrenceType = .regular
        }
        editingTask.recurrenceRule = isRepeating ? RecurrenceRule(recurrenceType: recurrenceType, recurrenceFrequency: recurrenceFrequency, interval: recurrenceInterval, weekdays: selectedWeekdays) : nil
        editingTask.notificationDate = isNotificationOn ? notificationDate : nil
        editingTask.color = isColorSelected ? editingTask.color : nil
    }
    
    func saveTask() {
        isShowingActivityIndicator = true
        interactor.save(task: editingTask) { success in
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




