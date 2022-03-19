//
//  LootGenerator.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 18.03.2022.
//

import Foundation

typealias Loot = ((resourceType: ResourceType, amount: Int)?, item: Item?)

struct LootGenerator {
    
    static func generateLoot(currentLevel: Int, buffed: Bool) -> Loot {
        if let resource = generateResource(currentLevel: currentLevel, buffed: buffed) {
            return Loot(resource, nil)
        }
        if let item = generateItem(buffed: buffed) {
            return Loot(nil, item)
        }
        else {
            return Loot(nil, nil)
        }
    }
    
    private static func generateResource(currentLevel: Int, buffed: Bool) -> (ResourceType, Int)? {
        let resourceTypeIndex = Int.random(in: 0..<ResourceType.allCases.count)
        let resourceType = ResourceType.allCases[resourceTypeIndex]
        var upperBound: Int = 0
        switch resourceType {
        case .gold, .water: upperBound = buffed ? 2 : 4 // 25% probability when not buffed
        case .fertilizer, .oil, .firewood: upperBound = buffed ? 3 : 6 // 16,7% probability when not buffed
        case .fabric, .metal: upperBound = buffed ? 5 : 10 // 10% probability when not buffed
        default: break
        }
        let shouldGenerate = Int.random(in: 0..<upperBound) == 0
        if shouldGenerate {
            let multiplier = Double.random(in: 1...2)
            var amount: Int = 0
            switch resourceType {
            case .gold:
                let goldToAdd = LevelManager.goldToAdd(currentLevel: currentLevel)
                amount = Int(round(Double(goldToAdd) * multiplier))
            case .water:
                let waterToAdd = LevelManager.waterToAdd(currentLevel: currentLevel)
                amount = Int(round(Double(waterToAdd) * multiplier))
            case .fertilizer: amount = Int(round(2 * multiplier))
            case .firewood: amount = Int(round(2 * multiplier))
            case .oil: amount = Int(round(multiplier))
            case .fabric: amount = 1
            case .metal: amount = 1
            default: break
            }
            return (resourceType, amount)
        }
        else {
             return nil
        }
    }
    
    private static func generateItem(buffed: Bool) -> Item? {
        let upperBound = buffed ? 5 : 10
        let shouldGenerate = Int.random(in: 0..<upperBound) == 0 // 10% probability when not buffed
        guard shouldGenerate else { return nil }
        let itemType = Int.random(in: 0..<4) // 75% probability to get a seed, 25% - to get a crystal
        switch itemType {
        case 0: // crystal
            let crystalType = Int.random(in: 0..<Crystal.allCases.count)
            return Crystal.allCases[crystalType]
        default: // seed
            let seedType = Int.random(in: 0..<PlantName.allCases.count)
            return PlantName.allCases[seedType]
        }
    }
}
