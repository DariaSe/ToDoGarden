//
//  UserDefaults.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 02.03.2022.
//

import Foundation

class Defaults {
    static let defaults = UserDefaults.standard
    
    // MARK: - Values
    static var notificationsAllowanceAsked: Bool {
        get { defaults.bool(forKey: notificationsAllowanceAskedKey) }
        set(newValue) { defaults.set(newValue, forKey: notificationsAllowanceAskedKey)} }
    
    // MARK: - Keys
    
    static let notificationsAllowanceAskedKey = "notificationsAllowanceAsked"
    
    // MARK: - Setting default values
    
    static func setDefault() {
        if defaults.value(forKey: notificationsAllowanceAskedKey) == nil {
            defaults.set(false, forKey: notificationsAllowanceAskedKey)
        }
    }
}
