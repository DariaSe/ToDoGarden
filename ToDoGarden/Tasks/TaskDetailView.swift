//
//  TaskDetailView.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 21.01.2022.
//

import SwiftUI

struct TaskDetailView: View {
    
    var interactor: TasksInteractor
    
    @StateObject var task: Task
    var isNew: Bool
    
    @State private var isCalendarShown: Bool = false
    
    @State private var isRepeating: Bool = false
    @State private var temporaryRecurrenceRule: RecurrenceRule?
    
    @State private var isNotificationOn: Bool = false
    @State private var notificationDate: Date = Date()
    
    @State private var isColorSelected: Bool = false
    @State private var isColorPickerShown: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // MARK: - Header
                Text(isNew ? Strings.newTask : Strings.task)
                    .font(.system(.title2, design: .rounded))
                // MARK: - Title
                TextField(Strings.taskTitle, text: $task.title)
                    .font(.system(.body, design: .rounded))
                    .padding()
                    .background(Capsule().fill(Color.textControlsBGColor))
                // MARK: - Start date
                HStack(spacing: 40) {
                    Text(task.recurrenceRule == nil ? Strings.date : Strings.startDate)
                        .font(.system(.body, design: .rounded))
                        .padding(.leading, 50)
                    Button {
                        isCalendarShown.toggle()
                    } label: {
                        Text(task.startDate.formattedForHeader)
                    }
                    .foregroundColor(Color.buttonColor)
                    .font(.system(.headline, design: .rounded))
                    Spacer()
                }
                if isCalendarShown {
                    CalendarHeaderView(date: $task.startDate, isCalendarShown: .constant(true))
                    CalendarView(date: $task.startDate, isShown: $isCalendarShown)
                }
                // MARK: - Recurrence
                HStack {
                    CheckboxButton(isOn: $isRepeating)
                    Text(Strings.repeatt)
                        .font(.system(.body, design: .rounded))
                        .opacity(isRepeating ? 1 : 0.8)
                    Spacer()
                }
                // MARK: - Notification
                HStack {
                    CheckboxButton(isOn: $isNotificationOn)
                    Text(Strings.notification)
                        .font(.system(.body, design: .rounded))
                        .opacity(isNotificationOn ? 1 : 0.8)
                    if isNotificationOn {
                        DatePicker(selection: $notificationDate, displayedComponents: .hourAndMinute) {}
                        .padding(.trailing, 60)
                    }
                    Spacer()
                }
                // MARK: - Color
                HStack {
                    CheckboxButton(isOn: $isColorSelected)
                    Text(Strings.color)
                        .font(.system(.body, design: .rounded))
                        .opacity(isNotificationOn ? 1 : 0.8)
                    if isColorSelected {
                        RoundedRectangle(cornerRadius: 16)
                            .inset(by: 10)
                            .fill(Color.taskColors[task.color ?? 0])
                            .frame(width: 50, height: 50)
                            .onTapGesture {
                                isColorPickerShown.toggle()
                            }
                        
                    }
                    Spacer()
                }
                if isColorPickerShown {
                    LazyVGrid(columns: [GridItem](repeating: GridItem(.flexible()), count: 6)) {
                        ForEach(0..<12) { int in
                            RoundedRectangle(cornerRadius: 16)
                                .inset(by: 10)
                                .fill(Color.taskColors[int])
                                .frame(width: 50, height: 50)
                                .onTapGesture {
                                    task.color = int
                                    isColorPickerShown = false
                                }
                        }
                    }
                    .padding(.horizontal, 50)
                }
                
                // MARK: - Notes
                VStack(alignment: .leading) {
                    Text(Strings.notes + ":")
                        .padding(.horizontal)
                    TextEditor(text: $task.notes)
                        .padding(.horizontal)
                        .background(RoundedRectangle(cornerRadius: 25).fill(Color.textControlsBGColor))
                        .frame(height: 100)
                }
                .font(.system(.body, design: .rounded))
                // MARK: - Save button
                Button(action: {
                    saveTask()
                }, label: {
                    ZStack {
                        Capsule()
                            .inset(by: 8)
                            .fill(Color.buttonColor)
                        Text(Strings.save)
                            .font(.system(.headline, design: .rounded))
                            .foregroundColor(Color.white)
                    }
                })
                    .frame(width: 160, height: 60)
            }
            
            .padding()
        }
        .onAppear {
            UITextView.appearance().backgroundColor = .clear
            isRepeating = task.recurrenceRule != nil
            temporaryRecurrenceRule = task.recurrenceRule
            isNotificationOn = task.notificationTime != nil
            isColorSelected = task.color != 0
        }
    }
    
    func saveTask() {
        
    }
}

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TaskDetailView(interactor: TasksInteractor(), task: Task(orderID: 1, title: "Some task", recurrenceRule: nil,  color: 2), isNew: false)
            TaskDetailView(interactor: TasksInteractor(), task: Task(orderID: 1, title: "Some task", recurrenceRule: nil,  color: 2), isNew: true)
                .previewDevice("iPhone 8")
        }
    }
}




