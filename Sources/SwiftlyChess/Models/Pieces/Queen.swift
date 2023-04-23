//
//  Queen.swift
//  TestingDataStructures
//
//  Created by Jeffrey Thompson on 1/16/23.
//

import Foundation

struct Queen: Piece {
    
    var isInInitialPosition: Bool

    var rules: [MovementRule] {
        [.diagonal(range: nil), .straight(range: nil)]
    }

    var team: Team
    var position: Position { didSet { isInInitialPosition = false } }
    var description: String { team == .faceYPositive ? "♛" : "♕"}
    
    var pieceValue: Int? { 9 }
    
    init(team: Team, position: Position) {
        self.team = team
        self.position = position
        if (position.y == 0 || position.y == 7) && (position.x == 4) {
            self.isInInitialPosition = true
        } else {
            self.isInInitialPosition = false
        }
    }
}

extension Queen: Graduateable {
    static func graduate(pawn: Pawn) -> Queen {
        Queen(team: pawn.team, position: pawn.position)
    }
}
