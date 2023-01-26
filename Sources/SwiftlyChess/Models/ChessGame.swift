//
//  ChessGame.swift
//  TestingDataStructures
//
//  Created by Jeffrey Thompson on 1/22/23.
//

import Foundation
import Combine

@available(macOS 10.15, *)
struct ChessGame {
    
    var board = Board.standardSetup()
    private var turn: Team = .faceYPositive
    let playerTeam: Team
    
    var graduationNotification = PassthroughSubject<Pawn, Never>()
    
    var undoStack = Stack<Board>()// consider if (team: Team, board: Board) is needed to track turn at point in time
    
    init(playerTeam: Team) {
        self.playerTeam = playerTeam
    }
    
    func isCheck(for team: Team) -> Bool {
        board.isCheck(for: team)
    }
    
    func isCheckmate(for team: Team) -> Bool {
        board.isCheckmate(for: team)
    }

    func select(at position: Position) -> Piece? {
        fatalError("Unimplemented")
    }
    
    mutating func switchTurn() {
        turn = (turn == .faceYPositive) ? .faceYNegative : .faceYPositive
    }
    
    @discardableResult
    mutating func moveRandom() -> Bool {
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
                    if player.moveIsLegal(to: position, on: board) {
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
    
    mutating func move(_ selection: Piece, to position: Position) throws {
        try board.movePiece(at: selection.position, to: position)
        if selection is Pawn {
            if selection.position.y == 0 || selection.position.y == 7 {
                graduationNotification.send(selection as! Pawn)
            }
        }
    }
    
    mutating func graduate<T: Graduateable>(_ pawn: Pawn, to piece: T.Type) throws {
        let upgradedPiece = T.graduate(pawn: pawn)
        try board.remove(at: pawn.position)
        try board.insert(piece: upgradedPiece)
    }
    
    mutating private func randomGraduate(_ pawn: Pawn) throws {
        if Bool.random() { try graduate(pawn, to: Queen.self); return }
        if Bool.random() { try graduate(pawn, to: Rook.self); return }
        if Bool.random() { try graduate(pawn, to: Bishop.self); return }
        try graduate(pawn, to: Knight.self)
    }
    
}
