//
//  Bishop.swift
//  TestingDataStructures
//
//  Created by Jeffrey Thompson on 1/16/23.
//

import Foundation

public struct Bishop: Piece {

    public var isInInitialPosition: Bool

    public var rules: [MovementRule] {
        [.diagonal(range: nil)]
    }

    public var team: Team
    public var position: Position { didSet { isInInitialPosition = false } }
    public var description: String { team == .faceYPositive ? "♝" : "♗" }
    
    public var pieceValue: Int? { 3 }
    
    public init(team: Team, position: Position) {
        self.team = team
        self.position = position
        
        //setup for test cases
        if (position.x == 2 || position.x == 5) && (position.y == 0 || position.y == 7) {
            self.isInInitialPosition = true
        } else {
            self.isInInitialPosition = false
        }
    }
}

extension Bishop: Graduateable {
    public static func graduate(pawn: Pawn) -> Bishop {
        Bishop(team: pawn.team, position: pawn.position)
    }
}

