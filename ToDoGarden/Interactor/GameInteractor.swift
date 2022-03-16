//
//  GameInteractor.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 07.03.2022.
//

import Foundation

class GameInteractor: ObservableObject {
    
    var appState: AppState
    
    init(appState: AppState) {
        self.appState = appState
    }
    
}
