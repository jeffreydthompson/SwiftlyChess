//
//  Pawn.swift
//  TestingDataStructures
//
//  Created by Jeffrey Thompson on 1/17/23.
//

import Foundation

public struct Pawn: Piece {
    
    public var isInInitialPosition: Bool {
        set { }
        get {
            if (team == .faceYPositive) && (position.y == 1) { return true }
            if (team == .faceYNegative) && (position.y == 6) { return true }
            return false
        }
    }
    
    public var rules: [MovementRule] {
        [.pawn]
    }
    
    public var team: Team
    public var position: Position
    public var description: String { team == .faceYPositive ? "♟" : "♙" }
    
    public var pieceValue: Int? { 1 }
    
    public var isGraduationPosition: Bool {
        position.y == 0 || position.y == 7
    }
  
    public func graduate<T: Graduateable>(to piece: T.Type) -> T {
        T.graduate(pawn: self)
    }
}
