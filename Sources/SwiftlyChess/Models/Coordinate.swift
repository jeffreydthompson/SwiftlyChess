//
//  Coordinate.swift
//  
//
//  Created by Jeffrey Thompson on 6/2/23.
//

import Foundation

public enum CoordinateColumn: Int {
    case colA, colB, colC, colD, colE, colF, colG, colH
    
    static var columns: [String] { ["a","b","c","d","e","f","g","h"] }
}

public enum CoordinateRow: Int {
    case row1, row2, row3, row4, row5, row6, row7, row8
}

public struct Coordinate: Equatable {
    public var col: CoordinateColumn
    public var row: CoordinateRow
    
    public init(col: CoordinateColumn, row: CoordinateRow) {
        self.col = col
        self.row = row
    }
    
    public init?(col: Int, row: Int) {
        guard let col = CoordinateColumn(rawValue: col - 1),
              let row = CoordinateRow(rawValue: row - 1) else { return nil }
        self.col = col
        self.row = row
    }
    
    public init?(_ string: String) {
        let components = string.lowercased().characterArray
        guard components.count == 2 else { return nil }
        guard let letter = components.first,
              CoordinateColumn.columns.contains(letter),
              let columnRawValue = CoordinateColumn.columns.firstIndex(of: letter),
              let numberChar = components.last,
              let rowRawValue = Int(numberChar),
              (0..<8).contains(rowRawValue - 1),
              let column = CoordinateColumn(rawValue: columnRawValue),
              let row = CoordinateRow(rawValue: rowRawValue - 1) else { return nil }
        self.col = column
        self.row = row
    }
}
