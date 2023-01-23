//
//  Queen.swift
//  TestingDataStructures
//
//  Created by Jeffrey Thompson on 1/16/23.
//

import Foundation

struct Queen: Piece {

    var rules: [MovementRule] {
        [.diagonal(range: nil), .straight(range: nil)]
    }

    var team: Team
    var position: Position
    var description: String { team == .faceYPositive ? "♛" : "♕"}
}