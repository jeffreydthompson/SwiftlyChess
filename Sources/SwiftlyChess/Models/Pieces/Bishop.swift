//
//  Bishop.swift
//  TestingDataStructures
//
//  Created by Jeffrey Thompson on 1/16/23.
//

import Foundation

struct Bishop: Piece {

    var isInInitialPosition: Bool

    var rules: [MovementRule] {
        [.diagonal(range: nil)]
    }

    var team: Team
    var position: Position { didSet { isInInitialPosition = false } }
    var description: String { team == .faceYPositive ? "♝" : "♗" }
    
    var pieceValue: Int? { 3 }
    
    init(team: Team, position: Position) {
        self.team = team
        self.position = position
        if (position.x == 2 || position.x == 5) && (position.y == 0 || position.y == 7) {
            self.isInInitialPosition = true
        } else {
            self.isInInitialPosition = false
        }
    }
}

extension Bishop: Graduateable {
    static func graduate(pawn: Pawn) -> Bishop {
        Bishop(team: pawn.team, position: pawn.position)
    }
}

