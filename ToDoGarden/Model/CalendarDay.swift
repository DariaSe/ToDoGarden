//
//  CalendarDay.swift
//  ToDoGame
//
//  Created by Дарья Селезнёва on 17.06.2021.
//

import Foundation

struct CalendarDay: Identifiable {
    var id = Int.random(in: 1...Int.max)
    var date: Date
    var belongsToMonth: Bool
    var isSelected: Bool
}
