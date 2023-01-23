//
//  Piece.swift
//  TestingDataStructures
//
//  Created by Jeffrey Thompson on 1/16/23.
//

import Foundation

protocol Piece {
    var description: String { get }
    var rules: [MovementRule] { get }
    var team: Team { get }
    var position: Position { get }
    func moveIsLegal(to space: Position, on board: Board) -> Bool
}

extension Piece {

    func moveIsLegal(to space: Position, on board: Board) -> Bool {
        if space == position { return false }
        if outOfBounds(space: space, on: board) { return false }
        if !rules
            .reduce(false, {
                if let pawn = self as? Pawn {
                    return ($0 || $1.obeysRule(from: position, to: space, board: board, pawnInitial: pawn.isInInitialPosition, pawnTeam: self.team))
                }
                return $0 || $1.obeysRule(from: position, to: space, board: board)
            }) { return false }
        if isSameTeam(on: space, on: board) { return false }
        return true
    }

    func outOfBounds(space: Position, on board: Board) -> Bool {
        if space.x < 0 || space.y < 0 { return true }
        if space.x >= board.xAxis || space.y >= board.yAxis { return true }
        return false
    }

    func isSameTeam(on space: Position, on board: Board) -> Bool {
        if let pieceTeam = board.piece(at: space)?.team,
           pieceTeam == team { return true }
        return false
    }
}


