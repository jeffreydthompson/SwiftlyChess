//
//  Knight.swift
//  TestingDataStructures
//
//  Created by Jeffrey Thompson on 1/17/23.
//

import Foundation

struct Knight: Piece {

    var rules: [MovementRule] {
        [.knight]
    }

    var team: Team
    var position: Position
    var description: String { team == .faceYPositive ? "♞" : "♘" }
}

extension Knight: Graduateable {
    static func graduate(pawn: Pawn) -> Knight {
        Knight(team: pawn.team, position: pawn.position)
    }
}

