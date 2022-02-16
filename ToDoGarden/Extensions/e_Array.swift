//
//  e_Array.swift
//  ToDoGame
//
//  Created by Дарья Селезнёва on 25.05.2021.
//

import Foundation

#warning("Test it")

extension Array where Element: Equatable {
    
    func index(of element: Element) -> Int? {
        var index: Int?
        for (arrayIndex, arrayElement) in self.enumerated() {
            if element == arrayElement {
                index = arrayIndex
            }
        }
        return index
    }
    
    func containsOneOrMoreOf(array: [Element]) -> Bool {
        guard !array.isEmpty else { return true }
        for item in array {
            if self.contains(item) { return true }
        }
        return false
    }
    
    func without(_ element: Element) -> Self {
        return self.filter { $0 != element }
    }
    
    mutating func replace(_ sourceElement: Element, with newElement: Element) {
        guard let index = self.index(of: sourceElement) else { return }
        var newArray = self
        newArray.remove(at: index)
        newArray.insert(newElement, at: index)
        self = newArray
    }
    
    mutating func updateExisting(with updatedElement: Element) {
        guard let index = self.index(of: updatedElement) else { return }
        var newArray = self
        newArray.remove(at: index)
        newArray.insert(updatedElement, at: index)
        self = newArray
    }
}

