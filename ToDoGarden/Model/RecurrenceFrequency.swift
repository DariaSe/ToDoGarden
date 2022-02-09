//
//  RecurrenceFrequency.swift
//  ToDoGame
//
//  Created by Дарья Селезнёва on 16.05.2021.
//

import Foundation

enum RecurrenceFrequency: Int, Codable, CaseIterable {
    
    case daily
    case weekly
    case monthly
    case yearly
    
    var string: String {
        switch self {
        case .daily: return Strings.daily
        case .weekly: return Strings.weekly
        case .monthly: return Strings.monthly
        case .yearly: return Strings.yearly
        }
    }
    
    func string(_ count: Int ) -> String {
        switch self {
        case .daily: return Strings.daysCount.localizedForCount(count)
        case .weekly: return Strings.weeksCount.localizedForCount(count)
        case .monthly: return Strings.monthsCount.localizedForCount(count)
        case .yearly: return Strings.yearsCount.localizedForCount(count)
        }
    }
}
