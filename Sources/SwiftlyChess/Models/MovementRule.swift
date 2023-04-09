//
//  MovementRule.swift
//
//  Created by Jeffrey Thompson on 1/16/23.
//

import Foundation

public enum MovementRule {
    case diagonal(range: Int?)
    case straight(range: Int?)
    case knight
    case pawn
    case castleable

    private var id: String {
        switch self {
        case .diagonal, .straight:
            return "straightDiagonal"
        case .knight:
            return "knight"
        case .pawn:
            return "pawn"
        case .castleable:
            return "castle"
        }
    }
    private var cartographer: Cartographer { Cartographer() }

    private var functionMap: [String: ((Position, Position, Board) throws -> Bool)] {
        [
            "straightDiagonal": canMoveStraightDiagonal,
            Self.pawn.id: pawnCanMove,
            Self.castleable.id: canCastle,
            Self.knight.id: knightCanMove
        ]
    }
    
    func obeysRule(
        from: Position,
        to: Position,
        board: Board) throws -> Bool {
            
            if from == to { return false }

            guard try functionMap[self.id]!(from, to, board) else { return false }
            
            guard try proposedMoveSafeFromCheck(from: from, to: to, board: board) else { return false }
            return true
        }
    
    private func proposedPathAllSquaresSafeFromCheck(
        from: Position,
        to: Position,
        board: Board) throws -> Bool {
            try cartographer.getRange(from: from, to: to)
                .reduce(true) { partialResult, position in
                    try partialResult && proposedMoveSafeFromCheck(from: from, to: position, board: board)
                }
        }
    
    private func proposedMoveSafeFromCheck(
        from: Position,
        to: Position,
        board: Board) throws -> Bool {
            var newBoard = board
            guard let piece = newBoard.piece(at: from) else { return false }

            try? newBoard.movePiece(at: from, to: to)

            do {
                return try !newBoard.isCheck(for: piece.team)
            } catch {
                throw error
            }
        }
    
    /// ignores game rules allowing piece to attack or skip.  simply returns if there are no pieces in the range
    private func isEmpty(
        from: Position,
        to: Position,
        board: Board) -> Bool {
            cartographer
                .getRange(from: from, to: to)
                .filter { board.piece(at: $0) != nil }
                .isEmpty
        }
    
    private func isFreeOfBlockingPieces(
        from: Position,
        to: Position,
        board: Board) -> Bool {
            
            if from == to { return true }
            switch self {
            case .knight:
                return true
            default:
                let range = cartographer.getRange(from: from, to: to)
                for position in range {
                    if let _ = board.piece(at: position) {
                        return false
                    }
                }
                return true
            }
        }

    private func knightCanMove(
        from: Position,
        to: Position,
        board: Board) throws -> Bool {
            let xDiff = abs(from.x - to.x)
            let yDiff = abs(from.y - to.y)
            guard xDiff == 2 || yDiff == 2,
                  xDiff == 1 || yDiff == 1,
                  xDiff + yDiff == 3 else { return false }
            guard try proposedMoveSafeFromCheck(from: from, to: to, board: board) else { return false }
            return true
        }


    private func pawnCanMove(
        from: Position,
        to: Position,
        board: Board) throws -> Bool {
            guard let pawn = board.piece(at: from),
                pawn is Pawn else { return false }
            let team = pawn.team
            // pawns can never move backwards
            if team == .faceYPositive && to.y < from.y { return false }
            if team == .faceYNegative && to.y > from.y { return false }

            let xDiff = abs(to.x - from.x)
            let yDiff = abs(to.y - from.y)

            guard xDiff <= 1 else { return false } // speed optimized redundant check
            if pawn.isInInitialPosition {
                guard yDiff <= 2 else { return false }
                guard yDiff + xDiff < 3 else { return false }
            } else {
                guard yDiff == 1 else { return false }
            }

            // attack?
            if from.x != to.x {
                guard abs(to.x - from.x) == 1 && abs(to.y - from.y) == 1 else { return false }
                // nothing there, illegal move
                guard let enemyPiece = board.piece(at: to),
                      enemyPiece.team != team else { return false }
                // ensure move does not cause check
                guard try proposedMoveSafeFromCheck(from: from, to: to, board: board) else {
                    return false
                }
                return true
            }

            // no attack
            if let _ = board.piece(at: to) { return false }
            guard isFreeOfBlockingPieces(
                    from: from,
                    to: to,
                    board: board) else { return false }
            return true
        }

    private func canMoveStraightDiagonal(
        from: Position,
        to: Position,
        board: Board) throws -> Bool {

            guard cartographer.isWithinRange(for: self, from: from, to: to),
                  isFreeOfBlockingPieces(from: from, to: to, board: board) else { return false }

            if let piece = board.piece(at: from),
               let occupyingPiece = board.piece(at: to) {

                if occupyingPiece.team == piece.team { return false }

                if piece is Queen {

                }
            }

            return true
        }

    private func canCastle(
        from: Position,
        to: Position,
        board: Board) throws -> Bool {

            // am I King or am I Rook?
            guard from.y == to.y else { return false }
            guard let piece = board.piece(at: from) else { return false }
            print("CASTLING DEBUG found piece")
            guard piece.isInInitialPosition else { return false }
            print("CASTLING DEBUG found piece is in initial position")

            var rookXLessThanKingX: Bool = false
            var kingToX: Int = -1

            if piece is King {
                print("CASTLING DEBUG found piece is king")
                guard (to.x == 2 || to.x == 6) else { return false }

                kingToX = to.x
                rookXLessThanKingX = to.x < from.x
            }

            if piece is Rook {
                print("CASTLING DEBUG found piece is rook")

                if(from.x == 0) {
                    guard to.x == 3 else { return false }
                }

                if(from.x == 7) {
                    guard to.x == 5 else { return false }
                }

                rookXLessThanKingX = to.x > from.x
                kingToX = (rookXLessThanKingX) ? 2 : 6
            }

            // Castling Rule 1. The king and the rook may not have moved from their starting squares.  checked in get function
            guard let (king, rook) = board.castlingSet(for: piece.team, rookXisLessThanKingX: rookXLessThanKingX) else { return false }
            print("CASTLING DEBUG found set Rule 1 - in initial position")

            // Castling Rule 2 The king cannot be in Check.
            guard try !board.isCheck(for: piece.team) else { return false }
            print("CASTLING DEBUG check Rule 2")

            // Castling Rule 3. All spaces between the king and rook must be empty.
            let range = cartographer
                .getRange(from: king.position, to: rook.position)
            for position in range {
                if board.piece(at: position) != nil {
                    print("CASTLING DEBUG FOUND BLOCKING PIECE")
                    return false
                }
            }
            print("CASTLING DEBUG check Rule 3. Checked range \(range)")

            // Casting Rule 4. The squares the king will pass over may not be under attack, nor can the square on which the king will land.
            guard try proposedPathAllSquaresSafeFromCheck(
                from: king.position,
                to: Position(x: kingToX, y: to.y),
                board: board) else { return false }

            print("CASTLING DEBUG check Rule 4. All passed. from: \(from) to: \(to)")

            return true
        }
}
