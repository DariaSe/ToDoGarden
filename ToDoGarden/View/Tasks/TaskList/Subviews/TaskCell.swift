//
//  TaskCell.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 19.01.2022.
//

import SwiftUI

struct TaskCell: View {
    
    @EnvironmentObject var interactor: TasksInteractor
    
    let task : Task
    let date : Date
    
    @State private var offset : CGFloat = 0
    
    @State var isEnabled : Bool = true
    var isDragging : Bool
    
    var onSelection: () -> Void
    
    var body: some View {
        ZStack {
            // MARK: - Dragging placeholder
            RoundedRectangle(cornerRadius: 20).fill(Color.gray.opacity(0.15))
            // MARK: - Bottom view
            if !isDragging {
                TaskCellBottomView() {
                    isEnabled = true
                    withAnimation(.easeOut(duration: 0.2)) {
                        offset = 0
                    }
                    interactor.delete(task: task) { _ in }
                }
                // MARK: - Top view
                TaskCellTopView(task: task, date: date, isEnabled: $isEnabled) {
                    interactor.setCompletedOrCancel(taskID: task.id)
                }
                .offset(x: offset, y: 0)
                .onTapGesture {
                    onSelection()
                }
                .gesture(DragGesture()
                            .onChanged { gesture in
                    guard abs(gesture.translation.width) > abs(gesture.translation.height) else { return }
                    isEnabled = false
                    offset = gesture.translation.width > 0 ? 0 : max(gesture.translation.width, -80)
                }
                            .onEnded { _ in
                    withAnimation(.easeOut(duration: 0.2)) {
                        offset = offset < -40 ? -80 : 0
                        isEnabled = offset == 0
                    }
                })
            }
        }
        .frame(height: 80)
    }
}

struct TaskCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TaskCell(task: Task.sample[0], date: Date(), isDragging: false, onSelection: {})
                .environmentObject(TasksInteractor(appState: AppState()))
                .frame(width: 387, height: 80)
                .previewLayout(.sizeThatFits)
        }
    }
}
