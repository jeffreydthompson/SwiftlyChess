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
    
    private enum Compass {
        case east, northEast, north, northWest, west, southWest, south, southEast
        
        var isDiagonal: Bool {
            switch self {
            case .north, .south, .east, .west:
                return false
            default:
                return true
            }
        }
    }

    func obeysRule(
        from: Position,
        to: Position,
        board: Board,
        pawnInitial: Bool = false,
        pawnTeam: Team? = nil) -> Bool {

            if from == to { return false }
            let direction = compass(from: from, to: to)
            switch self {
            case .diagonal(let range), .straight(let range):
                if !isWithinRange(from: from, to: to, range: range, direction: direction) { return false }
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

            func isBlockers(positions: [Position], board: Board) -> Bool {
                let openPath = positions
                    .filter { board.piece(at: $0) != nil }
                    .isEmpty
                return !openPath
            }

            if from == to { return false }
            switch self {
            case .knight:
                return false
            default:
                let positions = getRange(from: from, to: to)
                return isBlockers(positions: positions, board: board)
            }
    }
    
    private func getRange(from: Position, to: Position) -> [Position] {
        
        var xRange = range([to.x, from.x])
        var yRange = range([to.y, from.y])
        let direction = compass(from: from, to: to)
        
        switch direction {
        case .north, .south:
            xRange = Array(repeating: from.x, count: yRange.count)
        case .east, .west:
            yRange = Array(repeating: from.y, count: xRange.count)
        case .northEast, .southWest:
            break
        case .southEast, .northWest:
            xRange.reverse()
        }
        // assemble positions
        return Array(zip(xRange, yRange))
            .map { Position(x: $0.0, y: $0.1) }
    }
    
    private func isWithinRange(from: Position, to: Position, range: Int?, direction: Compass) -> Bool {
        switch self {
        case .diagonal:
            if !direction.isDiagonal { return false }
            if abs(from.x - to.x) != abs(from.y - to.y) { return false }
        case .straight:
            if direction.isDiagonal { return false }
        default: break
        }
        if let limit = range {
            if abs(from.x - to.x) > limit ||
                abs(from.y - to.y) > limit { return false }
        }
        return true
    }
    
    private func range(_ ary: [Int]) -> [Int] {
        guard let min = ary.min(),
              let max = ary.max() else { return [] }
        return stride(from: min + 1, to: max, by: 1).map { $0 }
    }
    
    private func compass(from: Position, to: Position) -> Compass {
        if from.x == to.x && from.y < to.y { return .north }
        if from.x == to.x && from.y > to.y { return .south }
        
        if from.y == to.y && from.x < to.x { return .east }
        if from.y == to.y && from.x > to.x { return .west }
        
        if from.x > to.x && from.y > to.y { return .northEast }
        if from.x < to.x && from.y < to.y { return .southWest }
        
        if from.x < to.x && from.y > to.y { return .northWest }
        if from.x > to.x && from.y < to.y { return .southEast }
        return .southEast
    }
}
