//
//  Resources.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 07.03.2022.
//

import Foundation

struct GameResources: Codable {
    
    var experience : Int
    var gold : Int
    var water : Int
    var waterCapacity : Int
    var donationCurrency : Int
    var fertilizer : Int
    var firewood : Int
    var oil : Int
    
    static let zero = GameResources(experience: 0, gold: 0, water: 0, waterCapacity: 10, donationCurrency: 0, fertilizer: 0, firewood: 0, oil: 0)
    
    //MARK: Decoding and encoding
    
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = documentsDirectory.appendingPathComponent("user").appendingPathExtension("plist")
    
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
