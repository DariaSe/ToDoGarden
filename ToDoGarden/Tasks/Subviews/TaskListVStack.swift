//
//  TaskListVStack.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 11.02.2022.
//

import SwiftUI
import UniformTypeIdentifiers

struct TaskListVStack: View {
    
    @EnvironmentObject var interactor: TasksInteractor

    @Binding var tasks : [Task]
    
    @Binding var selectedTask : Task?
    @Binding var date : Date

    let cellHeight : CGFloat = 80
    let spacing : CGFloat = 8
    
    @State var isDragging : Bool = false
    
    @State var draggedItem : Task?
    @State private var position : CGPoint?
    @State private var oldPosition : CGPoint?
    
    @State private var translationY : CGFloat?
    
    var isStaying : Bool? {
        guard let position = position, let oldPosition = oldPosition else { return nil }
        return position.y == oldPosition.y
    }
    
    var isDraggingUp : Bool? {
        guard let position = position, let oldPosition = oldPosition else { return nil }
        if position.y > cellHeight / 2 && oldPosition.y < -(cellHeight / 2) { return true }
        else { return position.y < oldPosition.y }
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: spacing) {
                ForEach(tasks) { task in
                    let index = tasks.firstIndex(of: task)!
                    TaskCell(task: task, date: date, isDragging: isDragging && draggedItem?.id == task.id) {
                        selectedTask = task
                    }
                    .simultaneousGesture(LongPressGesture()
                                            .onEnded({ _ in
                                                draggedItem = task
                                            })
                                            .sequenced(before: DragGesture()
                                                        .onChanged({ value in
                                                            isDragging = true
                                                            let locationY = value.location.y + (cellHeight + spacing) * CGFloat(index)
                                                            let listHeight = cellHeight * CGFloat(tasks.count) + spacing * CGFloat(tasks.count)
                                                            var adjustedLocationY : CGFloat
                                                            adjustedLocationY = max(locationY, cellHeight / 3)
                                                            adjustedLocationY = min(adjustedLocationY, listHeight - cellHeight / 3)
                                                            oldPosition = position
                                                            position = CGPoint(x: value.location.x, y: adjustedLocationY)
                                                            translationY = value.translation.height
                                                            handleDrag()
                                                        })
                                                        .onEnded({ value in
                                                            isDragging = false
                                                            draggedItem = nil
                                                            position = nil
                                                            translationY = nil
                                                            saveReorderedTasks()
                                                        })))
                }
            }
            if let draggedItem = draggedItem, isDragging, let position = position {
                TaskCell(task: draggedItem, date: date, isDragging: false) {}
                    .position(position)
                    .rotationEffect(Angle(degrees: 2))
            }
        }
    }
    
    func handleDrag() {
        guard let draggedItem = draggedItem, let translationY = translationY, let isDraggingUp = isDraggingUp, let isStaying = isStaying, !isStaying else { return }
        let sourceIndex = tasks.firstIndex(of: draggedItem)!
        // if dragging up
        if isDraggingUp, translationY < -(cellHeight / 2) && sourceIndex != 0 {
            let upperIndex = sourceIndex - 1
            swapDraggedTask(withTaskAt: upperIndex)
        }
        // if dragging down
        if !isDraggingUp, translationY > (cellHeight / 2) && sourceIndex != (tasks.count - 1) {
            let lowerIndex = sourceIndex + 1
            swapDraggedTask(withTaskAt: lowerIndex)
        }
    }
    
    func swapDraggedTask(withTaskAt index: Int) {
        guard var draggedItem = draggedItem else { return }
        var destinationTask = tasks[index]
        let sourceIndex = tasks.firstIndex(of: draggedItem)!
        let sourceOrderID = tasks[sourceIndex].orderID
        let destinationOrderID = destinationTask.orderID
        draggedItem.orderID = destinationOrderID
        destinationTask.orderID = sourceOrderID
        var tasksToSwap = tasks
        tasksToSwap.updateExisting(with: draggedItem)
        tasksToSwap.updateExisting(with: destinationTask)
        tasks = tasksToSwap.sorted()
    }
    
    func saveReorderedTasks() {
        interactor.saveReorderedTasks(tasks, completion: {_ in })
    }
}

struct TaskListVStack_Previews: PreviewProvider {
    static var previews: some View {
        TaskListVStack(tasks: .constant(Task.sample), selectedTask: .constant(nil), date: .constant(Date()))
    }
}
