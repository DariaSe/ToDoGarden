//
//  TaskCellBottomView.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 12.02.2022.
//

import SwiftUI

struct TaskCellBottomView: View {
    
    @State var isShowingDeletionWarning : Bool = false
    
    var onTapDelete: () -> Void
    
    var body: some View {
        HStack {
            Spacer()
            Button {
                isShowingDeletionWarning = true
            } label: {
                Image(systemName: "trash")
                    .font(.system(.largeTitle, design: .rounded))
                    .foregroundColor(.taskCellBGColor)
                    .padding()
            }
            .alert(isPresented: $isShowingDeletionWarning) {
                Alert.taskDeletion {
                    onTapDelete()
                }
            }
        }
        .frame(height: 78)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .background(Color.destructiveColor.opacity(0.9)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1))
    }
}

struct TaskCellBottomView_Previews: PreviewProvider {
    static var previews: some View {
        TaskCellBottomView(onTapDelete: {})
    }
}
