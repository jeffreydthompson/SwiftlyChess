//
//  Knight.swift
//  TestingDataStructures
//
//  Created by Jeffrey Thompson on 1/17/23.
//

import Foundation

struct Knight: Piece {
    
    var isInInitialPosition: Bool

    var rules: [MovementRule] {
        [.knight]
    }

    var team: Team
    var position: Position { didSet { isInInitialPosition = false } }
    var description: String { team == .faceYPositive ? "♞" : "♘" }
    
    init(team: Team, position: Position) {
        self.team = team
        self.position = position
        if (position.x == 1 || position.x == 6) && (position.y == 0 || position.y == 7) {
            self.isInInitialPosition = true
        } else {
            self.isInInitialPosition = false
        }
    }
}

extension Knight: Graduateable {
    static func graduate(pawn: Pawn) -> Knight {
        Knight(team: pawn.team, position: pawn.position)
    }
}

