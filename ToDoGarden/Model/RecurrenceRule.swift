//
//  RecurrenceRule.swift
//  ToDoGame
//
//  Created by Дарья Селезнёва on 07.05.2021.
//

import Foundation

class RecurrenceRule: Codable, ObservableObject {
    
    enum RecurrenceType: Int, RawRepresentable {
        case regular
        case withIntervals
        case onWeekdays
    }
    
    @Published var recurrenceType: RecurrenceType = .regular
    @Published var recurrenceFrequency: RecurrenceFrequency?
    @Published var interval: Int = 0
    @Published var weekdays: [Int] = []
    
    init() {}
    
    init(recurrenceType: RecurrenceType, recurrenceFrequency: RecurrenceFrequency?, interval: Int, weekdays: [Int]) {
        self.recurrenceType = recurrenceType
        self.recurrenceFrequency = recurrenceFrequency
        self.interval = interval
        self.weekdays = weekdays
    }
    
    static let zero = RecurrenceRule(recurrenceType: .regular, recurrenceFrequency: .daily, interval: 0, weekdays: [])
    
    
    static let sample1 = RecurrenceRule(recurrenceType: .withIntervals, recurrenceFrequency: .daily, interval: 2, weekdays: [])
    static let sample2 = RecurrenceRule(recurrenceType: .regular, recurrenceFrequency: .weekly, interval: 0, weekdays: [])
    static let sample3 = RecurrenceRule(recurrenceType: .onWeekdays, recurrenceFrequency: nil, interval: 0, weekdays: [2, 5])
    
    private enum CodingKeys: String, CodingKey {
        case recurrenceType = "recurrence_type"
        case recurrenceFrequency = "recurrence_frequency"
        case interval
        case weekdays
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let recurrenceTypeInt = try values.decode(Int.self, forKey: .recurrenceType)
        recurrenceType = RecurrenceType(rawValue: recurrenceTypeInt) ?? .regular
        let recurrenceFrequencyInt = try values.decode(Int.self, forKey: .recurrenceFrequency)
        recurrenceFrequency = RecurrenceFrequency(rawValue: recurrenceFrequencyInt)
        interval = try values.decode(Int.self, forKey: .interval)
        weekdays = try values.decode([Int].self, forKey: .weekdays)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(recurrenceType.rawValue, forKey: .recurrenceType)
        try container.encode(recurrenceFrequency?.rawValue, forKey: .recurrenceFrequency)
        try container.encode(interval, forKey: .interval)
        try container.encode(weekdays, forKey: .weekdays)
    }
}

