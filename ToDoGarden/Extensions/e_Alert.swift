//
//  e_Alert.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 12.02.2022.
//

import SwiftUI

extension Alert {
    
    static func taskDeletion(_ handler: @escaping () -> Void) -> Alert {
        return Alert(
            title: Text(Strings.taskDeletionTitle),
            message: Text(Strings.taskDeletionMessage),
            primaryButton: .destructive(Text(Strings.delete), action: handler),
            secondaryButton: .default(Text(Strings.cancel), action: {}))
    }
}
