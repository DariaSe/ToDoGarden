//
//  PlantSpecies.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 07.03.2022.
//

import Foundation

struct PlantSpecies {
    var id: Int
    var title: PlantName
    var description: String
    var buyCostGold: Int
    var buyCostDonation: Int
    var sellCost: Int
    var growthType: PlantGrowthType
    var waterConsumption: Int
    var fertilizerConsumption: Int
    var fertilizerOutput: Int?
    var firewoodOutput: Int?
    var levelRequired: Int
    var daysTilBlooming: Int
    var daysTilFruiting: Int
    var nominalYield: Int
    var bloomingDuration: Int { daysTilFruiting - daysTilBlooming }
    var fruitingDuration: Int
    var maxAge: Int { daysTilFruiting + fruitingDuration }
    
    static let tomato = PlantSpecies(id: 1,
                                     title: PlantName.tomato,
                                     description: "",
                                     buyCostGold: 3,
                                     buyCostDonation: 0,
                                     sellCost: 1,
                                     growthType: .bush,
                                     waterConsumption: 2,
                                     fertilizerConsumption: 2,
                                     fertilizerOutput: 2,
                                     levelRequired: 1,
                                     daysTilBlooming: 10,
                                     daysTilFruiting: 12,
                                     nominalYield: 3,
                                     fruitingDuration: 7)
    
    static let strawberry = PlantSpecies(id: 2,
                                         title: PlantName.strawberry,
                                         description: "",
                                         buyCostGold: 4,
                                         buyCostDonation: 0,
                                         sellCost: 1,
                                         growthType: .bush,
                                         waterConsumption: 1,
                                         fertilizerConsumption: 1,
                                         fertilizerOutput: 1,
                                         levelRequired: 2,
                                         daysTilBlooming: 6,
                                         daysTilFruiting: 8,
                                         nominalYield: 2,
                                         fruitingDuration: 7)
    
    static let apple = PlantSpecies(id: 3,
                                        title: PlantName.apple,
                                        description: "",
                                        buyCostGold: 5,
                                        buyCostDonation: 1,
                                        sellCost: 1,
                                        growthType: .tree,
                                        waterConsumption: 3,
                                        fertilizerConsumption: 3,
                                        firewoodOutput: 20,
                                        levelRequired: 3,
                                        daysTilBlooming: 36,
                                        daysTilFruiting: 40,
                                        nominalYield: 10,
                                        fruitingDuration: 10)
    
    static let walnut = PlantSpecies(id: 5,
                                     title: PlantName.walnut,
                                     description: "",
                                     buyCostGold: 6,
                                     buyCostDonation: 1,
                                     sellCost: 1,
                                     growthType: .tree,
                                     waterConsumption: 4,
                                     fertilizerConsumption: 4,
                                     firewoodOutput: 24,
                                     levelRequired: 5,
                                     daysTilBlooming: 40,
                                     daysTilFruiting: 45,
                                     nominalYield: 7,
                                     fruitingDuration: 24)
    
    static let watermelon = PlantSpecies(id: 6,
                                         title: PlantName.watermelon,
                                         description: "",
                                         buyCostGold: 6,
                                         buyCostDonation: 1,
                                         sellCost: 1,
                                         growthType: .bush,
                                         waterConsumption: 3,
                                         fertilizerConsumption: 3,
                                         fertilizerOutput: 2,
                                         levelRequired: 6,
                                         daysTilBlooming: 16,
                                         daysTilFruiting: 18,
                                         nominalYield: 1,
                                         fruitingDuration: 3)
    
    static let cherry = PlantSpecies(id: 7,
                                     title: PlantName.cherry,
                                     description: "",
                                     buyCostGold: 6,
                                     buyCostDonation: 1,
                                     sellCost: 1,
                                     growthType: .tree,
                                     waterConsumption: 4,
                                     fertilizerConsumption: 4,
                                     firewoodOutput: 18,
                                     levelRequired: 7,
                                     daysTilBlooming: 30,
                                     daysTilFruiting: 34,
                                     nominalYield: 25,
                                     fruitingDuration: 7)
    
    static let avocado = PlantSpecies(id: 9,
                                      title: PlantName.avocado,
                                      description: "",
                                      buyCostGold: 8,
                                      buyCostDonation: 1,
                                      sellCost: 2,
                                      growthType: .tree,
                                      waterConsumption: 4,
                                      fertilizerConsumption: 4,
                                      firewoodOutput: 22,
                                      levelRequired: 8,
                                      daysTilBlooming: 37,
                                      daysTilFruiting: 42,
                                      nominalYield: 6,
                                      fruitingDuration: 9)
    
    static let coconut = PlantSpecies(id: 10,
                                      title: PlantName.coconut,
                                      description: "",
                                      buyCostGold: 8,
                                      buyCostDonation: 2,
                                      sellCost: 2,
                                      growthType: .tree,
                                      waterConsumption: 5,
                                      fertilizerConsumption: 5,
                                      firewoodOutput: 26,
                                      levelRequired: 9,
                                      daysTilBlooming: 42,
                                      daysTilFruiting: 46,
                                      nominalYield: 7,
                                      fruitingDuration: 8)
    
    static let chiliPepper = PlantSpecies(id: 11,
                                          title: PlantName.chiliPepper,
                                          description: "",
                                          buyCostGold: 7,
                                          buyCostDonation: 2,
                                          sellCost: 1,
                                          growthType: .bush,
                                          waterConsumption: 2,
                                          fertilizerConsumption: 2,
                                          fertilizerOutput: 2,
                                          levelRequired: 9,
                                          daysTilBlooming: 14,
                                          daysTilFruiting: 17,
                                          nominalYield: 3,
                                          fruitingDuration: 5)
    
    static let plants: [PlantSpecies] = [.tomato, .strawberry, .apple, .walnut, .watermelon, .cherry, .avocado, .coconut, .chiliPepper]
}

enum PlantName: String, CaseIterable, Item {
    case tomato
    case strawberry
    case apple
    case walnut
    case watermelon
    case cherry
    case avocado
    case coconut
    case chiliPepper
}

enum PlantGrowthType: Int {
    case bush
    case tree
}

