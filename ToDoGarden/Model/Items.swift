//
//  Items.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 18.03.2022.
//

import Foundation
import SwiftUI

struct GameItems {
    var seeds : [PlantName : Int]
    var fruits : [PlantName : Int]
    var crystals : [Crystal : Int]
    var potions : [Potion : Int]
}

enum Crystal: String {
    case garnet
    case tourmaline
    case rhinestone
    case morion
}

enum Potion: String {
    case fire
    case air
    case water
    case earth
    case defence
    case hibernation
}
