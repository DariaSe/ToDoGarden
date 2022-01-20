//
//  TaskListView.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 15.01.2022.
//

import SwiftUI

struct TaskListView: View {
    var body: some View {
        NavigationView {
            VStack {
                DaySwitcherView(text: "May 1, 2022",
                                onPressForward: {
                                    
                                },
                                onPressBack: {
                                    
                                })
                List {
                    
                }
            }
        }
    }
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView()
    }
}
