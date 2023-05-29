//
//  Knight.swift
//  TestingDataStructures
//
//  Created by Jeffrey Thompson on 1/17/23.
//

import Foundation

public struct Knight: Piece {
    
    public var isInInitialPosition: Bool

    public var rules: [MovementRule] {
        [.knight]
    }

    public var team: Team
    public var position: Position { didSet { isInInitialPosition = false } }
    public var description: String { team == .faceYPositive ? "♞" : "♘" }
    
    public var pieceValue: Int? { 3 }
    
    init(team: Team, position: Position) {
        self.team = team
        self.position = position
        
        //setup for test cases
        if (position.x == 1 || position.x == 6) && (position.y == 0 || position.y == 7) {
            self.isInInitialPosition = true
        } else {
            self.isInInitialPosition = false
        }
    }
}

extension Knight: Graduateable {
    public static func graduate(pawn: Pawn) -> Knight {
        Knight(team: pawn.team, position: pawn.position)
    }
}

