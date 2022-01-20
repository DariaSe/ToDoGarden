//
//  RecurrenceRule.swift
//  ToDoGame
//
//  Created by Дарья Селезнёва on 07.05.2021.
//

import Foundation

struct RecurrenceRule: Codable {
    
    var recurrenceFrequency: RecurrenceFrequency?
    var interval: Int?
    var weekdays: [Int]?
    
    static let sample1 = RecurrenceRule(recurrenceFrequency: .daily, interval: 2, weekdays: nil)
    static let sample2 = RecurrenceRule(recurrenceFrequency: .weekly, interval: 1, weekdays: nil)
    static let sample3 = RecurrenceRule(recurrenceFrequency: nil, interval: nil, weekdays: [2, 5])
}

