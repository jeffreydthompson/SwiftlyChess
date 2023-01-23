//
//  Array+differential.swift
//  TestingDataStructures
//
//  Created by Jeffrey Thompson on 1/20/23.
//

import Foundation

extension Array where Element == Int {
    
    var differential: Int {
        (self.max() ?? 0) - (self.min() ?? 0)
    }
    
}
