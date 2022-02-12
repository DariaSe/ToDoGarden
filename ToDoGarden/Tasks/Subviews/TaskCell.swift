//
//  TaskCell.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 19.01.2022.
//

import SwiftUI

struct TaskCell: View {
    
    @EnvironmentObject var interactor: TasksInteractor
    
    let viewModel : TaskViewModel
    
    @State private var offset : CGFloat = 0
    @State private var showFullWidth : Bool = false
    let buttonWidth : CGFloat = 80
    @State var isActive : Bool = true
    
    @State var isShowingDeletionWarning : Bool = false
    
    var onSelection: () -> Void
    
    var body: some View {
        Button {
            onSelection()
        } label: {
            ZStack {
                // bottom view
                HStack {
                    Spacer()
                    // Delete button
                    Button {
                        isActive = true
                        isShowingDeletionWarning = true
                        withAnimation(.easeOut(duration: 0.2)) {
                            offset = 0
                        }
                    } label: {
                        Image(systemName: "trash")
                            .font(.system(.largeTitle, design: .rounded))
                            .foregroundColor(.taskCellBGColor)
                            .padding()
                    }
                    .alert(isPresented: $isShowingDeletionWarning) {
                        Alert.taskDeletion {
                            interactor.delete(task: viewModel.task) { _ in }
                        }
                    }
                }
                .frame(height: 78)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .background(Color.destructiveColor.opacity(0.9)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1))
                // top view
                TaskCellTopView(viewModel: viewModel, isActive: $isActive) {
                    interactor.setCompletedOrCancel(taskID: viewModel.id, date: viewModel.date)
                }
                .offset(x: offset, y: 0)
                .gesture(DragGesture()
                            .onChanged { gesture in
                    guard abs(gesture.translation.width) > abs(gesture.translation.height) else { return }
                    isActive = false
                    offset = gesture.translation.width > 0 ? 0 : max(gesture.translation.width, -80)
                }
                            .onEnded { _ in
                    withAnimation(.easeOut(duration: 0.2)) {
                        offset = offset < -40 ? -80 : 0
                        isActive = offset == 0
                    }
                })
            }
        }
        .disabled(!isActive)
    }
}

struct TaskCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TaskCell(viewModel: TaskViewModel.sample[0], onSelection: {})
                .environmentObject(TasksInteractor(appState: AppState()))
                .frame(width: 387, height: 80)
                .previewLayout(.sizeThatFits)
        }
    }
}

