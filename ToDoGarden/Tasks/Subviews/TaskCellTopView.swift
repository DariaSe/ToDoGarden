//
//  TaskCellTopView.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 12.02.2022.
//

import SwiftUI

struct TaskCellTopView: View {
    
    let task : Task
    let date : Date
    
    var color : Color { Color.tagColor(index: task.color ?? 0) }
    var text : String { task.title }
    var tasksDone : Int { task.tasksCompleted }
    var tasksTotal : Int { task.tasksTotal }
    var notificationTime : String? { task.notificationTime }
    var isDone : Bool { task.isDoneOnDate(date) }
    
    @Binding var isEnabled : Bool
    
    var action: () -> Void
    
    var body: some View {
        HStack {
            color
                .frame(width: 16)
            VStack(alignment: .leading, spacing: 8) {
                let progressText: String = "\(tasksDone)" + "/" + "\(tasksTotal)"
                Text(text)
                    .foregroundColor(isDone ? .gray : .black)
                    .font(.system(.body, design: .rounded))
                    .strikethrough(isDone)
                HStack {
                    Text(progressText)
                    Spacer()
                    if let notificationTime = notificationTime {
                        Label(notificationTime, systemImage: "alarm")
                    }
                }
                .font(.system(.caption, design: .rounded))
                .foregroundColor(.black)
            }
            .lineLimit(2)
            .padding(.horizontal, 5)
            Spacer()
            // Done button
            Button {
                action()
            } label: {
                Image(systemName: isDone ? "checkmark.circle" : "circle")
                    .font(.system(size: 44))
            }
            .disabled(!isEnabled)
            .foregroundColor(isEnabled ? color : color.opacity(0.7))
            .padding(.all, 12)
            .frame(alignment: .trailing)
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .background(Color.taskCellBGColor
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
                        .shadow(color: .white.opacity(0.4), radius: 5, x: 0, y: -3))
    }
}

struct TaskCellTopView_Previews: PreviewProvider {
    static var previews: some View {
        TaskCellTopView(task: Task.sample[0], date: Date(), isEnabled: .constant(true), action: {})
            .frame(width: 387, height: 80)
            .previewLayout(.sizeThatFits)
    }
}
