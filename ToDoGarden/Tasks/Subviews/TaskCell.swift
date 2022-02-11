//
//  TaskCell.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 19.01.2022.
//

import SwiftUI

struct TaskCell: View {
    
    var viewModel: TaskViewModel
    
    var color: Color { Color.tagColor(index: viewModel.color ?? 0) }
    var text: String { viewModel.title }
    var tasksDone: Int { viewModel.task.tasksCompleted }
    var tasksTotal: Int { viewModel.task.tasksTotal }
    var notificationTime: String? { viewModel.task.notificationTime }
    var isDone: Bool { viewModel.isDone }
    
    var onTapDone: () -> Void
    
    @State private var offset = CGSize.zero
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                let height = geometry.size.height
                color
                    .frame(width: 16, height: height, alignment: .leading)
                HStack {
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
                    Spacer()
                    Button {
                        onTapDone()
                    } label: {
                        Image(systemName: isDone ? "checkmark.circle" : "circle")
                            .resizable()
                    }
                    .foregroundColor(color)
                    .padding()
                    .frame(width: height, height: height, alignment: .trailing)
                }
                .padding(.leading, 30)
            }
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .background(Color.white
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3))
            .gesture(DragGesture())
            HStack {
                Spacer()
                Button {
                    
                } label: {
                    Image(systemName: "trash")
                        .font(.system(.largeTitle, design: .rounded))
                        .foregroundColor(.destructiveColor)
                        .padding()
                }
            }
        }
    }
}

struct TaskCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TaskCell(viewModel: TaskViewModel.sample[0], onTapDone: {})
                .frame(width: 387, height: 80)
                .previewLayout(.sizeThatFits)
        }
    }
}
