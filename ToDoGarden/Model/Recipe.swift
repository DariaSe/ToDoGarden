//
//  Recipe.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 18.03.2022.
//

import Foundation

struct Recipe {
    
    var id: Int
    var title: String
    var fruits: [PlantName : Int]
    var crystals: [Crystal : Int]
    var water: Int
    var oil: Int
    var firewood: Int
    
    func matches(resources: GameResources, items: GameItems) -> Bool {
        let recipeFruit = fruits.keys.first!
        guard let userFruitsCount = items.fruits[recipeFruit] else { return false }
        let fruitsMatch = userFruitsCount >= fruits[recipeFruit]!
        let recipeCrystal = crystals.keys.first!
        guard let userCrystalsCount = items.crystals[recipeCrystal] else { return false }
        let crystalsMatch = userCrystalsCount >= crystals[recipeCrystal]!
        let resourcesMatch = resources.water >= water && resources.oil >= oil && resources.firewood >= firewood
        return fruitsMatch && crystalsMatch && resourcesMatch
    }
    
    static let fire: Recipe = Recipe(
        id: 1,
        title: Potion.fire.rawValue.localizedGame,
        fruits: [PlantName.chiliPepper : 3],
        crystals: [Crystal.garnet : 3],
        water: 1,
        oil: 3,
        firewood: 7)
    static let air: Recipe = Recipe(
        id: 2,
        title: Potion.air.rawValue.localizedGame,
        fruits: [PlantName.apple : 3],
        crystals: [Crystal.rhinestone : 3],
        water: 1,
        oil: 2,
        firewood: 5)
    static let water: Recipe = Recipe(
        id: 3,
        title: Potion.water.rawValue.localizedGame,
        fruits: [PlantName.watermelon : 1],
        crystals: [Crystal.tourmaline : 3],
        water: 3,
        oil: 1,
        firewood: 4)
    static let earth: Recipe = Recipe(
        id: 4,
        title: Potion.earth.rawValue.localizedGame,
        fruits: [PlantName.strawberry : 7],
        crystals: [Crystal.morion : 3],
        water: 2,
        oil: 2,
        firewood: 6)
    static let defence: Recipe = Recipe(
        id: 5,
        title: Potion.defence.rawValue.localizedGame,
        fruits: [PlantName.coconut : 2],
        crystals: [Crystal.garnet : 3],
        water: 1,
        oil: 3,
        firewood: 6)
    static let hibernation: Recipe = Recipe(
        id: 6,
        title: Potion.hibernation.rawValue.localizedGame,
        fruits: [PlantName.cherry : 20],
        crystals: [Crystal.morion : 3],
        water: 2,
        oil: 2,
        firewood: 5)
}
