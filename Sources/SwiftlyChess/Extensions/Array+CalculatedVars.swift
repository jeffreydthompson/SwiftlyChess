//
//  Array+differential.swift
//
//  Created by Jeffrey Thompson on 1/20/23.
//

import Foundation

extension Array where Element: Hashable {
    
    func intersection(of other: Array<Element>) -> [Element] {
        
        var elements = [Element: Int]()
        
        for element in self {
            elements[element, default: 0] += 1
        }
        
        for element in other {
            elements[element, default: 0] += 1
        }
        
        var intersection = elements.compactMap({
            $0.value > 1 ? $0.key : nil
        })
        
        return intersection
    }
}

extension Array where Element == Position {
    
    func removeDoubles() -> [Position] {
        var set = Set(self)
        let removed = Array(set)
        return removed
    }
    
}

extension Array where Element == Int {
    
    var differential: Int {
        (self.max() ?? 0) - (self.min() ?? 0)
    }
    
    var sequentialOverRange: [Int] {
        guard let min = self.min(),
              let max = self.max() else { return [] }
        return stride(from: min, through: max, by: 1).map { $0 }
    }
    
    var sequentialBetweenMinMax: [Int] {
        guard let min = self.min(),
              let max = self.max(),
              (min + 1) <= max else { return [] }
        return stride(from: min + 1, to: max, by: 1).map { $0 }
    }
}

extension Array where Element == Bool {
    
    var allTrue: Bool {
        !self.contains(false)
    }
    
    var hasTrue: Bool {
        self.contains(true)
    }
    
    var allFalse: Bool {
        !self.contains(true)
    }
    
    var hasFalse: Bool {
        self.contains(false)
    }
}
