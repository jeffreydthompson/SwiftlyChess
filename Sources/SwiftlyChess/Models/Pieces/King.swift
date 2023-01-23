//
//  King.swift
//  TestingDataStructures
//
//  Created by Jeffrey Thompson on 1/16/23.
//

import Foundation

struct King: Piece {

    var rules: [MovementRule] {
        [.diagonal(range: 1), .straight(range: 1)]
    }
    
    var team: Team
    var position: Position
    var description: String { team == .faceYPositive ? "♚" : "♔"}
}
