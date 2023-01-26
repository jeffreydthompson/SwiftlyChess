//
//  Bishop.swift
//  TestingDataStructures
//
//  Created by Jeffrey Thompson on 1/16/23.
//

import Foundation

struct Bishop: Piece {

    var rules: [MovementRule] {
        [.diagonal(range: nil)]
    }

    var team: Team
    var position: Position
    var description: String { team == .faceYPositive ? "♝" : "♗" }
}

extension Bishop: Graduateable {
    static func graduate(pawn: Pawn) -> Bishop {
        Bishop(team: pawn.team, position: pawn.position)
    }
}

