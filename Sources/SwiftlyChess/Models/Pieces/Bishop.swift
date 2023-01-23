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

