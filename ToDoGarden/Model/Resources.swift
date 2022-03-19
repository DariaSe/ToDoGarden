//
//  Resources.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 07.03.2022.
//

import Foundation

class GameResources: NSObject, Codable {
    
    var experience : Int = 0
    var gold : Int = 0
    var water : Int = 0
    var waterCapacity : Int = 10
    var donationCurrency : Int = 0
    var fertilizer : Int = 0
    var firewood : Int = 0
    var oil : Int = 0
    var fabric : Int = 0
    var metal : Int = 0
    
    var hasOilPress : Bool = false
    var hasCauldron : Bool = false
    
    static let zero = GameResources()
    
    var currentLevel: Int { LevelManager.currentLevel(experience: experience) }
    
    
    
    func addResource(resourceType: ResourceType, amount: Int) {
        let totalAmount = self.value(forKeyPath: resourceType.rawValue) as! Int + amount
        self.setValue(totalAmount, forKeyPath: resourceType.rawValue)
//        switch resourceType {
//        case .gold: gold += amount
//        case .water: water += amount
//        case .fertilizer: fertilizer += amount
//        case .firewood: firewood += amount
//        case .oil: oil += amount
//        case .fabric: fabric += amount
//        case .metal: metal += amount
//        }
    }
    
    func subtractResource(resourceType: ResourceType, amount: Int) {
        var totalAmount = self.value(forKeyPath: resourceType.rawValue) as! Int - amount
        if totalAmount < 0 {
            totalAmount = 0
        }
        self.setValue(totalAmount, forKeyPath: resourceType.rawValue)
    }
    
    //MARK: Decoding and encoding
    
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = documentsDirectory.appendingPathComponent("resources").appendingPathExtension("plist")
    
    static func saveToFile(gameResources: GameResources) {
        let propertyListEncoder = PropertyListEncoder()
        let encodedResources = try? propertyListEncoder.encode(gameResources)
        try? encodedResources?.write(to: archiveURL, options: .noFileProtection)
    }
    
    static func loadFromFile() -> GameResources? {
        let propertyListDecoder = PropertyListDecoder()
        guard let retrievedData = try? Data(contentsOf: archiveURL) else { return nil }
        return try? propertyListDecoder.decode(GameResources.self, from: retrievedData)
    }
}

enum ResourceType: String, CaseIterable {
    case gold
    case water
    case fertilizer
    case firewood
    case oil
    case fabric
    case metal
}
