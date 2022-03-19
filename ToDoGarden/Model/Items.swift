//
//  Items.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 18.03.2022.
//

import Foundation
import SwiftUI

protocol Item {}

struct GameItems {
    var seeds : [PlantName : Int]
    var fruits : [PlantName : Int]
    var crystals : [Crystal : Int]
    var potions : [Potion : Int]
    
    static func makeZero() -> GameItems {
        var seeds = [PlantName : Int]()
        var fruits = [PlantName : Int]()
        for plant in PlantName.allCases {
            seeds[plant] = 0
            fruits[plant] = 0
        }
        var crystals = [Crystal : Int]()
        for crystal in Crystal.allCases {
            crystals[crystal] = 0
        }
        var potions = [Potion : Int]()
        for potion in Potion.allCases {
            potions[potion] = 0
        }
        return GameItems(seeds: seeds, fruits: fruits, crystals: crystals, potions: potions)
    }
}

enum Crystal: String, CaseIterable, Item {
    case garnet
    case tourmaline
    case rhinestone
    case morion
}

enum Potion: String, CaseIterable, Item {
    case fire
    case air
    case water
    case earth
    case defence
    case hibernation
}
