//
//  AppState.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 31.01.2022.
//

import Foundation

class AppState: ObservableObject {
    
    @Published var tasks: [Task] = Task.sample
    
}
