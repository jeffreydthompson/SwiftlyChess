//
//  ChessGame.swift
//
//  Created by Jeffrey Thompson on 1/22/23.
//

import Foundation
import Combine

@available(macOS 10.15, *)
public struct ChessGame {
    
    var board = Board.standardSetup()
    private var turn: Team = .faceYPositive
    let playerTeam: Team
    
    public var graduationNotification = PassthroughSubject<Pawn, Never>()
    
    public var gameHistory = Stack<Board>()// consider if (team: Team, board: Board) is needed to track turn at point in time
    
    public init(playerTeam: Team) {
        self.playerTeam = playerTeam
    }
    
    public func isDraw() -> Bool {
        gameHistory.isDraw
    }
    
    public func isStalemate(for team: Team) -> Bool {
        board.isStalemate(for: team)
    }
    
    public func isCheck(for team: Team) throws -> Bool {
        try board.isCheck(for: team)
    }
    
    public func isCheckmate(for team: Team) throws -> Bool {
        try board.isCheckmate(for: team)
    }
    
    public func select(at position: Position) -> Piece? {
        board.piece(at: position)
    }
    
    mutating public func switchTurn() {
        turn = (turn == .faceYPositive) ? .faceYNegative : .faceYPositive
    }
    
    mutating public func move(
        _ selection: Piece,
        to position: Position) throws {
            try board.movePiece(at: selection.position, to: position)
            if selection is Pawn {
                if selection.position.y == 0 || selection.position.y == 7 {
                    graduationNotification.send(selection as! Pawn)
                }
            }
        }
    
    mutating public func graduate<T: Graduateable>(
        _ pawn: Pawn,
        to piece: T.Type) throws {
            let upgradedPiece = T.graduate(pawn: pawn)
            try board.remove(at: pawn.position)
            try board.insert(piece: upgradedPiece)
        }
    
    //MARK: - Internal types for AI play
    func shallowSearchBestAttack(for team: Team) -> (from: Position, to: Position)? {
        
        let teamPieces = board.teamPieces(for: team)
        
        var highScoreFrom: Position?
        var highScoreTo: Position?
        var highScore = 0
        
        for piece in teamPieces {
            guard let positions = try? board.attackPositions(for: piece) else { continue }
            for position in positions {
                var editBoard = board
                
                guard let score = try? editBoard.movePiece(at: piece.position, to: position) else { continue }
                
                guard let check = try? editBoard.isCheck(for: team),
                      check == false else {
                    continue
                }
                
                editBoard.debugPrint()
                
                let counterAttack = findHighestValueAttack(for: team.enemy, on: editBoard)
                let counterScore = counterAttack?.score ?? 0
                
                let calculatedScore = score - counterScore
                
                if calculatedScore > highScore {
                    highScoreFrom = piece.position
                    highScoreTo = position
                    highScore = calculatedScore
                }
            }
        }
        
        if highScore < 0 {
            return nil
        }
        
        if let from = highScoreFrom,
           let to = highScoreTo {
            return (from, to)
        }
        
        return nil
    }
    
    func attemptCheck(forAttackingTeam team: Team, altBoard: Board? = nil) -> (from: Position, to: Position)? {
        
        let thisBoard = altBoard ?? board
        let pieces = thisBoard.teamPieces(for: team)
        var checkPositions = [(Position, Position, Int)]()
        
        for piece in pieces {
            
            guard let positions = try? board.permittedPositions(for: piece) else { continue }
            
            for position in positions {
                var editBoard = thisBoard
                guard let _ = try? editBoard.movePiece(at: piece.position, to: position) else { continue }
                guard let _ = try? !editBoard.isCheck(for: team) else {
                    continue
                }
                guard let check = try? editBoard.isCheck(for: team.enemy) else {
                    continue
                }
                
                if check {
                    let counterAttack = findHighestValueAttack(for: turn.enemy, on: editBoard)
                    let counterScore = counterAttack?.score ?? 0
                    checkPositions.append((piece.position, position, counterScore))
                }
                
                if let checkmate = try? editBoard.isCheckmate(for: team.enemy),
                   checkmate {
                    return (piece.position, position)
                }
            }
        }
        
        //make least dangerous
        if !checkPositions.isEmpty {
            checkPositions.sort { $0.2 < $1.2 }
            guard let from = checkPositions.first?.0,
                  let to = checkPositions.first?.1 else {
                return nil
            }
            return (from, to)
        }
        return nil
    }
    
    // Shallow calculation moves
    func findHighestValueAttack(
        for team: Team,
        on altBoard: Board? = nil) -> (from: Position, to: Position, score: Int?)? {
            
            let thisBoard = altBoard ?? board
            
            let teamPieces = thisBoard.pieces.filter({ $0.team == team })
            var highScoreFrom: Position?
            var highScoreTo: Position?
            var highScore = 0
            
            for piece in teamPieces {
                guard let positions = try? thisBoard.attackPositions(for: piece) else { continue }
                for position in positions {
                    var editBoard = thisBoard
                    guard let score = try? editBoard.movePiece(at: piece.position, to: position) else { continue }
                    if score > highScore {
                        highScoreFrom = piece.position
                        highScoreTo = position
                        highScore = score
                    }
                }
            }
            
            if let from = highScoreFrom,
               let to = highScoreTo {
                return (from, to, highScore)
            }
            
            return nil
        }
    
    mutating func safeRandom() throws {
        
        var teamPieces = board.pieces.filter { $0.team == turn }
        
        while !teamPieces.isEmpty {
            let random = Int.random(in: 0..<teamPieces.count)
            let player = teamPieces.remove(at: random)
            var possiblePositions = player.positionsInRange()
            
            possiblePositions.shuffle()
            
            for position in possiblePositions {
                var editBoard = board
                
                try? editBoard.remove(at: position)
                try editBoard.movePiece(at: player.position, to: position)
                
                let counterAttack = findHighestValueAttack(for: turn.enemy, on: editBoard)
                let counterScore = counterAttack?.score ?? 0
                
                if counterScore == 0 {
                    try? board.remove(at: position)
                    try board.movePiece(at: player.position, to: position)
                    return
                }
            }
        }
    }
    
    // Randomized testing
    @discardableResult
    mutating func moveRandom() throws -> Bool {
        var teamIsTurn = board.pieces.filter { $0.team == turn }
        while !teamIsTurn.isEmpty {
            let random = Int.random(in: 0..<teamIsTurn.count)
            let player = teamIsTurn.remove(at: random)
            
            var xAxis = stride(from: 0, to: 8, by: 1).map { $0 }
            var yAxis = stride(from: 0, to: 8, by: 1).map { $0 }
            xAxis.shuffle()
            yAxis.shuffle()
            for x in xAxis {
                for y in yAxis {
                    let position = Position(x: x, y: y)
                    if try player.moveIsLegal(to: position, on: board) {
                        do {
                            try? board.remove(at: position)
                            try move(player, to: position)
                            
                            if let pawn = board.piece(at: position) as? Pawn {
                                if pawn.isGraduationPosition {
                                    try randomGraduate(pawn)
                                }
                            }
                            
                            return true
                        } catch {
                            print("DEBUG moveRandom error \(error)")
                        }
                    }
                }
            }
        }
        return false
    }
    
    mutating private func randomGraduate(_ pawn: Pawn) throws {
        if Bool.random() { try graduate(pawn, to: Queen.self); return }
        if Bool.random() { try graduate(pawn, to: Rook.self); return }
        if Bool.random() { try graduate(pawn, to: Bishop.self); return }
        try graduate(pawn, to: Knight.self)
    }
}
