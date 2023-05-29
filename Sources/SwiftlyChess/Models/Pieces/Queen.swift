//
//  Queen.swift
//  TestingDataStructures
//
//  Created by Jeffrey Thompson on 1/16/23.
//

import Foundation

public struct Queen: Piece {
    
    public var isInInitialPosition: Bool

    public var rules: [MovementRule] {
        [.diagonal(range: nil), .straight(range: nil)]
    }

    public var team: Team
    public var position: Position { didSet { isInInitialPosition = false } }
    public var description: String { team == .faceYPositive ? "♛" : "♕"}
    
    public var pieceValue: Int? { 9 }
    
    init(team: Team, position: Position) {
        self.team = team
        self.position = position
        
        //setup for test cases
        if (position.y == 0 || position.y == 7) && (position.x == 4) {
            self.isInInitialPosition = true
        } else {
            self.isInInitialPosition = false
        }
    }
}

extension Queen: Graduateable {
    public static func graduate(pawn: Pawn) -> Queen {
        Queen(team: pawn.team, position: pawn.position)
    }
}
