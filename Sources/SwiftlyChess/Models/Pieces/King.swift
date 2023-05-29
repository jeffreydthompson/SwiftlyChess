//
//  King.swift
//  TestingDataStructures
//
//  Created by Jeffrey Thompson on 1/16/23.
//

import Foundation

public struct King: Piece {
    
    public var isInInitialPosition: Bool

    public var rules: [MovementRule] {
        [.diagonal(range: 1), .straight(range: 1), .castleable]
    }
    
    public var team: Team
    public var position: Position { didSet { isInInitialPosition = false } }
    public var description: String { team == .faceYPositive ? "♚" : "♔"}
    
    public var pieceValue: Int? { nil } // invaluable
    
    public init(team: Team, position: Position) {
        self.team = team
        self.position = position
        
        // setup for test cases
        if (position.y == 0 || position.y == 7) && (position.x == 4) {
            self.isInInitialPosition = true
        } else {
            self.isInInitialPosition = false
        }
    }
}
