//
//  Piece.swift
//
//  Created by Jeffrey Thompson on 1/16/23.
//

import Foundation

public protocol Piece {
    var isInInitialPosition: Bool { get set }
    var description: String { get }
    var rules: [MovementRule] { get }
    var team: Team { get }
    var position: Position { get set }
    var pieceValue: Int? { get }
    func positionsInRange() -> [Position]
    func moveIsLegal(to space: Position, on board: Board) throws -> Bool
}

extension Piece {
    
    public func positionsInRange() -> [Position] {
        rules.reduce([Position]()) { ps, rule in
            ps + rule.positionsInRange(of: position, team: team)
        }.removeDoubles()
    }

    public func moveIsLegal(to space: Position, on board: Board) throws -> Bool {
        if space == position { return false }
        if outOfBounds(space: space, on: board) { return false }
        if isSameTeam(on: space, on: board) { return false }
        if try !rules
            .reduce(false, {
                return try $0 || $1.obeysRule(from: position, to: space, board: board)
            }) { return false }
        return true
    }

    public func outOfBounds(space: Position, on board: Board) -> Bool {
        if space.x < 0 || space.y < 0 { return true }
        if space.x >= board.xAxis || space.y >= board.yAxis { return true }
        return false
    }

    public func isSameTeam(on space: Position, on board: Board) -> Bool {
        if let pieceTeam = board.piece(at: space)?.team,
           pieceTeam == team { return true }
        return false
    }
}


