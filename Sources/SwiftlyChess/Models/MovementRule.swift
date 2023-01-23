//
//  MovementRule.swift
//  TestingDataStructures
//
//  Created by Jeffrey Thompson on 1/16/23.
//

import Foundation

public enum MovementRule {
    case diagonal(range: Int?)
    case straight(range: Int?)
    case knight
    case pawn
    
    private var cartographer: Cartographer { Cartographer() }
    
    func obeysRule(
        from: Position,
        to: Position,
        board: Board,
        pawnInitial: Bool = false,
        pawnTeam: Team? = nil) -> Bool {
            
            if from == to { return false }
            switch self {
            case .diagonal, .straight:
                if !cartographer.isWithinRange(for: self, from: from, to: to) { return false }
                return !doesExistBlockingPieces(from: from, to: to, board: board)
            case .knight:
                let xDiff = abs(from.x - to.x)
                let yDiff = abs(from.y - to.y)
                guard xDiff == 2 || yDiff == 2 else { return false }
                guard xDiff == 1 || yDiff == 1 else { return false }
                if (xDiff + yDiff == 3) { return true }
            case .pawn:
                guard let team = pawnTeam else { return false }
                // pawns can never move backwards
                if team == .faceYPositive && to.y < from.y { return false }
                if team == .faceYNegative && to.y > from.y { return false }
                
                // attack?
                if from.x != to.x {
                    guard abs(to.x - from.x) == 1 && abs(to.y - from.y) == 1 else { return false }
                    // nothing there, illegal move
                    guard let piece = board.piece(at: to) else { return false }
                    // ensure enemy piece
                    return piece.team == team ? false : true
                }
                
                // no attack
                if let _ = board.piece(at: to) { return false }
                if pawnInitial {
                    if abs(to.y - from.y) > 2 { return false }
                    return !doesExistBlockingPieces(from: from, to: to, board: board)
                } else {
                    if abs(to.y - from.y) == 1 { return true }
                }
            }
            return false
        }
    
    private func doesExistBlockingPieces(
        from: Position,
        to: Position,
        board: Board) -> Bool {
            
            if from == to { return false }
            switch self {
            case .knight:
                return false
            default:
                return !cartographer
                    .getRange(from: from, to: to)
                    .filter { board.piece(at: $0) != nil }
                    .isEmpty
            }
        }
}
