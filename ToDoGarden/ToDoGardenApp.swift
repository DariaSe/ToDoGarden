//
//  ToDoGardenApp.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 15.01.2022.
//

import SwiftUI

@main
struct ToDoGardenApp: App {
    
    let appState: AppState = AppState()
    
    var body: some Scene {
        WindowGroup {
            MainView(tasksInteractor: TasksInteractor(appState: appState))
                .environmentObject(appState)
        }
    }
}
