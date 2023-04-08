//
//  CheckmateCalculator.swift
//  
//
//  Created by Jeffrey Thompson on 1/23/23.
//

import Foundation

struct CheckmateCalculator {
    
    enum Error: Swift.Error {
        case noKing
    }
    
    private let team: Team
    private var board: Board
    private let king: King
    private lazy var potentialAttackers: [Piece] = {
        board.pieces
            .filter({ $0.team == team.enemy })
            .filter({ (try? $0.moveIsLegal(to: king.position, on: board)) ?? false })
    }()
    private lazy var teamPieces: [Piece] = {
        board.pieces.filter { $0.team == team }
    }()
    
    init(team: Team, board: Board) throws {
        self.team = team
        self.board = board
        guard let king = board.king(for: team) else {
            throw Error.noKing
        }
        self.king = king
    }
    
    mutating func isCheck() -> Bool {
        !potentialAttackers.isEmpty
    }
    
    mutating func isCheckmate() throws -> Bool {
        if !isCheck() { return false }
        if try canEscapeCheck() { return false }
        if try canNeutralizeAttackers() { return false }
        if try teamCanBlock() { return false }
        return true
    }
    
    mutating func canEscapeCheck() throws -> Bool {

        let escapePositions = try board.permittedPositions(for: king)
        var canEscape = [Bool]()
        for position in escapePositions {
            do {
                var newBoard = board
                try newBoard.movePiece(at: king.position, to: position)
                var newCalculator = try CheckmateCalculator(team: team, board: newBoard)
                if newCalculator.isCheck() {
                    canEscape.append(false)
                } else {
                    canEscape.append(true)
                }
            } catch {
                print("DEBUG ERROR Board.isCheckmate escape: \(error)")
            }
        }
        if canEscape.isEmpty { return false }
        return canEscape.hasTrue
    }
    
    mutating func teamCanBlock() throws -> Bool {
        
        var potentialBlockPositions = [Bool]()
        var removeKnights = potentialAttackers
        removeKnights.removeAll(where: { $0 is Knight })
        for attacker in removeKnights {
            let range = Cartographer().getRange(from: attacker.position, to: king.position)
            for position in range {
                for piece in teamPieces {
                    if try piece.moveIsLegal(to: position, on: board) {
                        do {
                            var newBoard = board
                            try newBoard.movePiece(at: piece.position, to: position)
                            var newCalculator = try CheckmateCalculator(team: team, board: newBoard)
                            if newCalculator.isCheck() {
                                potentialBlockPositions.append(false)
                            } else {
                                potentialBlockPositions.append(true)
                            }
                        } catch {
                            print("DEBUG ERROR Board.isCheckmate escape: \(error)")
                        }
                    }
                }
            }
        }
        if potentialBlockPositions.isEmpty { return false }
        return potentialBlockPositions.hasTrue
    }
    
    mutating func canNeutralizeAttackers() throws -> Bool {

        var attackersNeutralized = [Bool]()
        for attacker in potentialAttackers {
            // let's see if we can take them out
            let threatCancellers = try getPotentialAttackers(for: attacker)
            for canceller in threatCancellers {
                // let's make a hypothetical and see if the king is safe
                do {
                    var newBoard = board
                    try newBoard.remove(at: attacker.position)
                    try newBoard.movePiece(at: canceller.position, to: attacker.position)
                    var newCalculator = try CheckmateCalculator(team: team, board: newBoard)
                    if newCalculator.isCheck() {
                        attackersNeutralized.append(false)
                    } else {
                        attackersNeutralized.append(true)
                    }
                } catch {
                    print("DEBUG ERROR Board.isCheckmate neutralize: \(error)")
                }
            }
        }
        if attackersNeutralized.isEmpty { return false }
        return !attackersNeutralized.hasFalse
    }
    
    private func getPotentialAttackers(for piece: Piece) throws -> [Piece] {
        try board.pieces
            .filter({ $0.team == piece.team.enemy })
            .filter({ try $0.moveIsLegal(to: piece.position, on: board) })
    }
}
