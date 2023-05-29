//
//  Rook.swift
//  TestingDataStructures
//
//  Created by Jeffrey Thompson on 1/16/23.
//

import Foundation

struct Rook: Piece {
    
    var isInInitialPosition: Bool

    var rules: [MovementRule] {
        [.straight(range: nil), .castleable]
    }

    var team: Team
    var position: Position {
        didSet {
            isInInitialPosition = false
        }
    }
    var description: String { team == .faceYPositive ? "♜" : "♖" }
    
    var pieceValue: Int? { 5 }
    
    init(team: Team, position: Position) {
        self.team = team
        self.position = position
        
        //setup for test cases
        if (position.x == 0 || position.x == 7) && (position.y == 0 || position.y == 7) {
            self.isInInitialPosition = true
        } else {
            self.isInInitialPosition = false
        }
    }
}

extension Rook: Graduateable {
    static func graduate(pawn: Pawn) -> Rook {
        Rook(team: pawn.team, position: pawn.position)
    }
}
