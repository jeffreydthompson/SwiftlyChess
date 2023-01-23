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

