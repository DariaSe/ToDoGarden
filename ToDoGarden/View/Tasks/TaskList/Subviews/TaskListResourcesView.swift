//
//  TaskListResourcesView.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 07.03.2022.
//

import SwiftUI

struct TaskListResourcesView: View {
    
    @EnvironmentObject var appState : AppState
    
    var experience: Int { appState.resources.experience }
    var water: Int { appState.resources.water }
    var maxWaterCapacity: Int { appState.resources.waterCapacity }
    
    var body: some View {
        HStack {
            ExperienceView(experience: experience)
                .frame(width: 160)
            Spacer()
            Label(water.string + "/" + maxWaterCapacity.string, systemImage: "drop")
        }
    }
}

struct TaskListResourcesView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListResourcesView()
            .previewLayout(.sizeThatFits)
            .environmentObject(AppState())
    }
}
