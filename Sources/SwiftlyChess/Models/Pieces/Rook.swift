//
//  Rook.swift
//  TestingDataStructures
//
//  Created by Jeffrey Thompson on 1/16/23.
//

import Foundation

struct Rook: Piece {

    var rules: [MovementRule] {
        [.straight(range: nil)]
    }

    var team: Team
    var position: Position
    var description: String { team == .faceYPositive ? "♜" : "♖" }
}

extension Rook: Graduateable {
    static func graduate(pawn: Pawn) -> Rook {
        Rook(team: pawn.team, position: pawn.position)
    }
}
