//
//  King.swift
//  TestingDataStructures
//
//  Created by Jeffrey Thompson on 1/16/23.
//

import Foundation

struct King: Piece {
    
    var isInInitialPosition: Bool

    var rules: [MovementRule] {
        [.diagonal(range: 1), .straight(range: 1), .castleable]
    }
    
    var team: Team
    var position: Position { didSet { isInInitialPosition = false } }
    var description: String { team == .faceYPositive ? "♚" : "♔"}
    
    var pieceValue: Int? { nil } // invaluable
    
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
