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
    
    @Binding var selectedTask: Task?
    @Binding var date: Date
    
    @State var tasks: [TaskViewModel]
    
    let cellHeight : CGFloat = 80
    let spacing : CGFloat = 8
    
    @State var isDragging : Bool = false
    
    @State var draggedItem : TaskViewModel?
    @State private var position : CGPoint?
    @State private var oldPosition : CGPoint?
    
    @State private var translationY : CGFloat?
    
    var isDraggingUp : Bool? {
        guard let position = position, let oldPosition = oldPosition else { return nil }
        return position.y < oldPosition.y
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: spacing) {
                ForEach(tasks) { viewModel in
                    let index = tasks.firstIndex(of: viewModel)!
                    TaskCell(viewModel: viewModel, isDragging: isDragging && draggedItem?.id == viewModel.id) {
                        selectedTask = viewModel.task.copy()
                    }
                    .simultaneousGesture(LongPressGesture()
                                            .onEnded({ _ in
                        draggedItem = viewModel
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
                        position = nil
                        translationY = nil
                        saveReorderedTasks()
                    })))
                }
            }
            if let draggedItem = draggedItem, isDragging, let position = position {
                TaskCell(viewModel: draggedItem, isDragging: false) {}
                .position(position)
                .rotationEffect(Angle(degrees: 2))
            }
        }
    }
    
    func handleDrag() {
        guard let draggedItem = draggedItem, let translationY = translationY, let isDraggingUp = isDraggingUp else { return }
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
        guard let draggedItem = draggedItem else { return }
        let destinationViewModel = tasks[index]
        let sourceOrderID = draggedItem.orderID
        let destinationOrderID = destinationViewModel.orderID
        draggedItem.task.orderID = destinationOrderID
        destinationViewModel.task.orderID = sourceOrderID
        var tasksToSwap = tasks
        tasksToSwap.updateExisting(with: draggedItem)
        tasksToSwap.updateExisting(with: destinationViewModel)
        tasks = tasksToSwap.sorted()
    }
    
    func saveReorderedTasks() {
        let reorderedTasks = tasks.map({ $0.task })
        interactor.saveReorderedTasks(reorderedTasks, completion: {_ in })
    }
}

struct TaskListVStack_Previews: PreviewProvider {
    static var previews: some View {
        TaskListVStack(selectedTask: .constant(nil), date: .constant(Date()), tasks: TaskViewModel.sample)
    }
}
