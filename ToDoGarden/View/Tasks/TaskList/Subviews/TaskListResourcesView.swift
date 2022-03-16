//
//  TaskListResourcesView.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 07.03.2022.
//

import SwiftUI

struct TaskListResourcesView: View {
    
    @EnvironmentObject var appState : AppState
    
    var body: some View {
        HStack {
            
        }
    }
}

struct TaskListResourcesView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListResourcesView()
            .environmentObject(AppState())
    }
}
