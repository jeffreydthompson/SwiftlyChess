//
//  Pawn.swift
//  TestingDataStructures
//
//  Created by Jeffrey Thompson on 1/17/23.
//

import Foundation

struct Pawn: Piece {
    
    var isInInitialPosition: Bool {
        set { }
        get {
            if (team == .faceYPositive) && (position.y == 1) { return true }
            if (team == .faceYNegative) && (position.y == 6) { return true }
            return false
        }
    }
    
    var rules: [MovementRule] {
        [.pawn]
    }
    
    var team: Team
    var position: Position
    var description: String { team == .faceYPositive ? "♟" : "♙" }
    
    var pieceValue: Int? { 1 }
    
    var isGraduationPosition: Bool {
        position.y == 0 || position.y == 7
    }
  
    func graduate<T: Graduateable>(to piece: T.Type) -> T {
        T.graduate(pawn: self)
    }
}
