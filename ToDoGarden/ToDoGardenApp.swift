//
//  ToDoGardenApp.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 15.01.2022.
//

import SwiftUI

@main
struct ToDoGardenApp: App {
    
    var appState: AppState = AppState()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(appState)
        }
    }
}
