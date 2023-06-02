//
//  Position.swift
//
//  Created by Jeffrey Thompson on 1/16/23.
//

import Foundation

public struct Position: Equatable, Hashable {
    public var x: Int
    public var y: Int
    
    public var coordinateString: String {
        (["a","b","c","d","e","f","g","h"][x])+"\(y)"
    }
    
    public var coordinate: Coordinate {
        Coordinate(col: x + 1, row: y + 1)!
    }
    
    public init?(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    public init(coordinate: Coordinate) {
        self.x = coordinate.col.rawValue
        self.y = coordinate.col.rawValue
    }
}
