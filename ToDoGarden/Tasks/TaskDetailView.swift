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
    
    @StateObject var task: Task
    var isNew: Bool
    
    @State private var isRepeating: Bool = true
    @StateObject var temporaryRecurrenceRule: RecurrenceRule
    
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
                    TextField(Strings.taskTitle, text: $task.title)
                        .font(.system(.body, design: .rounded))
                        .padding()
                        .background(Capsule().fill(Color.textControlsBGColor))
                    // MARK: - Start date
                    TaskDetailDateView(startDate: $task.startDate, isRecurring: task.recurrenceRule != nil)
                    // MARK: - Recurrence
                    TaskDetailRecurrenceView(isRepeating: $isRepeating, recurrenceRule: task.recurrenceRule ?? temporaryRecurrenceRule)
                    // MARK: - Notification
                    TaskDetailNotificationView(isNotificationOn: $isNotificationOn, notificationDate: $notificationDate)
                    // MARK: - Color
                    TaskDetailColorView(isColorSelected: $isColorSelected, color: $task.color)
                    // MARK: - Notes
                    TaskDetailNotesView(notes: $task.notes)
                    // MARK: - Save button
                    VStack {
                        Button {
                            isShowingValidationWarning = task.validationWarning != nil
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
                            Alert(title: Text(task.validationWarning ?? ""), dismissButton: .default(Text("OK")))
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
            isRepeating = task.recurrenceRule != nil
            isNotificationOn = task.notificationDate != nil
            notificationDate = task.notificationDate ?? Date()
            isColorSelected = task.color != nil
        }
    }
    
    func saveTask() {
        isShowingActivityIndicator = true
        task.recurrenceRule = isRepeating ? temporaryRecurrenceRule : nil
        task.notificationDate = isNotificationOn ? notificationDate : nil
        task.color = isColorSelected ? task.color : nil
        interactor.save(task: task) { success in
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
            TaskDetailView(interactor: TasksInteractor(), task: Task(orderID: 1, title: "Some task", recurrenceRule: RecurrenceRule.sample1,  color: 2), isNew: false, temporaryRecurrenceRule: RecurrenceRule.sample1)
            TaskDetailView(interactor: TasksInteractor(), task: Task(orderID: 1, title: "Some task", recurrenceRule: RecurrenceRule.sample3,  color: 2), isNew: true, temporaryRecurrenceRule: RecurrenceRule.sample3)
                .previewDevice("iPhone 8")
            
        }
    }
}




