//
//  Rook.swift
//  TestingDataStructures
//
//  Created by Jeffrey Thompson on 1/16/23.
//

import Foundation

public struct Rook: Piece {
    
    public var isInInitialPosition: Bool

    public var rules: [MovementRule] {
        [.straight(range: nil), .castleable]
    }

    public var team: Team
    public var position: Position {
        didSet {
            isInInitialPosition = false
        }
    }
    public var description: String { team == .faceYPositive ? "♜" : "♖" }
    
    public var pieceValue: Int? { 5 }
    
    public init(team: Team, position: Position) {
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
    public static func graduate(pawn: Pawn) -> Rook {
        Rook(team: pawn.team, position: pawn.position)
    }
}
