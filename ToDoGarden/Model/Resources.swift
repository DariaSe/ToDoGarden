//
//  Resources.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 07.03.2022.
//

import Foundation

struct GameResources: Codable {
    
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
    
    static let zero = GameResources()
    
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
