//
//  MainView.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 15.01.2022.
//

import SwiftUI

struct MainView: View {
    
    init() {
        UITabBar.appearance().backgroundColor = .yellow
    }
    
    @EnvironmentObject var appState: AppState
    
    @EnvironmentObject var tasksInteractor: TasksInteractor
    
    var body: some View {
        TabView {
            TaskListView(date: $appState.date)
                .tabItem {
                    Label(Strings.tasks, systemImage: "list.bullet")
                }
            InventoryView()
                .tabItem {
                    Label(Strings.inventory, systemImage: "leaf")
                }
            QuestsView()
                .tabItem {
                    Label(Strings.quests, systemImage: "lasso.and.sparkles")
                }
            SettingsView()
                .tabItem {
                    Label(Strings.settings, systemImage: "gearshape")
                }
        }
        .accentColor(.black)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(AppState())
            .environmentObject(TasksInteractor(appState: AppState()))
    }
}
