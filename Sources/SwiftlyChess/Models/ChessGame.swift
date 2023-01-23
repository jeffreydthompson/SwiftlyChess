//
//  ChessGame.swift
//  TestingDataStructures
//
//  Created by Jeffrey Thompson on 1/22/23.
//

import Foundation

struct ChessGame {
    
    var board = Board.standardSetup()
    var turn: Team = .faceYPositive
    let playerTeam: Team
    
    var undoStack = Stack<Board>()// consider if (team: Team, board: Board) is needed to track turn at point in time
    
    init(playerTeam: Team) {
        self.playerTeam = playerTeam
    }
    
    func isCheck(for team: Team) -> Bool {
        fatalError("Unimplemented")
    }
    
    func isCheckmate(for team: Team) -> Bool {
        fatalError("Unimplemented")
    }

    func select(at position: Position) -> Piece? {
        fatalError("Unimplemented")
    }
    
    @discardableResult
    mutating func move(selection: Piece, to: Position) -> Bool {
        fatalError("Unimplemented")
    }
    
}
