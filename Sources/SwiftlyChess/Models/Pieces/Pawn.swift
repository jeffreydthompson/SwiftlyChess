//
//  Pawn.swift
//  TestingDataStructures
//
//  Created by Jeffrey Thompson on 1/17/23.
//

import Foundation

struct Pawn: Piece {

    var rules: [MovementRule] {
        [.pawn]
    }

    var team: Team
    var position: Position
    var description: String { team == .faceYPositive ? "♟" : "♙" }

    var isInInitialPosition: Bool {
        if (team == .faceYPositive) && (position.y == 1) { return true }
        if (team == .faceYNegative) && (position.y == 6) { return true }
        return false
    }

}
