//
//  TaskCell.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 19.01.2022.
//

import SwiftUI

struct TaskCell: View {
    
    var color: Color
    var text: String
    var tasksDone: Int
    var tasksTotal: Int
    var notificationTime: String?
    @State var isDone: Bool
    
    var body: some View {
        GeometryReader { geometry in
            let height = geometry.size.height
            color
                .frame(width: 20, height: height, alignment: .leading)
            HStack() {
                VStack(alignment: .leading, spacing: 8) {
                    let progressText: String = "\(tasksDone)" + "/" + "\(tasksTotal)"
                    Text(text)
                        .foregroundColor(isDone ? .gray : .black)
                        .strikethrough(isDone)
                    HStack {
                        Text(progressText)
                        Spacer()
                        if let notificationTime = notificationTime {
                            Label(notificationTime, systemImage: "alarm")
                        }
                    }
                    .font(.subheadline)
                }
                .lineLimit(2)
                Spacer()
                Button {
                    isDone.toggle()
                } label: {
                    Image(systemName: isDone ? "checkmark.circle" : "circle")
                        .resizable()
                }
                .foregroundColor(color)
                .padding()
                .frame(width: height, height: height, alignment: .trailing)
                .animation(.easeIn(duration: 0.1), value: isDone)
            }
            .padding(.leading, 35)
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

struct TaskCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TaskCell(color: Color.red, text: "Some very very bloody long long task bla bla", tasksDone: 2, tasksTotal: 5, isDone: true)
                .frame(width: 387, height: 80)
                .previewLayout(.sizeThatFits)
            TaskCell(color: Color.red, text: "Short task", tasksDone: 7, tasksTotal: 7, notificationTime: "14 : 00", isDone: false)
                .frame(width: 387, height: 80)
                .previewLayout(.sizeThatFits)
        }
    }
}
