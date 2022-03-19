//
//  LevelManager.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 16.03.2022.
//

import Foundation

class LevelManager {
    
    static let levels: [Int : Int] = [
        1 : 0,
        2 : 10,
        3 : 30,
        4 : 60,
        5 : 100,
        6 : 180,
        7 : 300,
        8 : 500,
        9 : 750,
        10 : 1000,
        11 : 1350,
        12 : 1800,
        13 : 2400,
        14 : 3100,
        15 : 4000,
        16 : 5000,
        17 : 7500,
        18 : 11000,
        19 : 15000,
        20 : 20000,
        21 : 30000,
        22 : 45000,
        23 : 65000,
        24 : 90000,
        25 : 120000,
        26 : 155000,
        27 : 190000,
        28 : 220000,
        29 : 255000,
        30 : 300000
    ]
    
    static func currentLevel(experience: Int) -> Int {
        let currentLevelExperience = levels.map({$0.value}).sorted(by: >).first(where: {$0 <= experience})
        let level = levels.first{$0.value == currentLevelExperience}!.0
        return level
    }
    
    static func nextLevelExperience(experience: Int) -> Int {
        return levels[currentLevel(experience: experience) + 1] ?? 300000 }
    
    static func experienceToAdd(currentLevel: Int) -> Int {
        switch currentLevel {
        case 1-4: return 2
        case 5-9: return 4
        case 10-14: return 8
        case 15-19: return 16
        case 20-24: return 32
        default: return 64
        }
    }
    
    static func goldToAdd(currentLevel: Int) -> Int {
        switch currentLevel {
        case 1-4: return 3
        case 5-9: return 6
        case 10-14: return 12
        case 15-19: return 24
        case 20-24: return 42
        default: return 60
        }
    }
    
    static func waterToAdd(currentLevel: Int) -> Int {
        switch currentLevel {
        case 1-4: return 2
        case 5-9: return 3
        case 10-14: return 5
        case 15-19: return 8
        default: return 12
        }
    }
}
