//
//  Board.swift
//  TestingDataStructures
//
//  Created by Jeffrey Thompson on 1/16/23.
//

import Foundation

struct Board {
    
    enum Error: Swift.Error {
        case pieceExistsAtThisPosition
        case noPieceExistsAtThisPosition
        case inputOutOfBounds
    }
    
    var xAxis = 8
    var yAxis = 8

    var pieces: [Piece] = []

    func piece(at space: Position) -> Piece? {
        pieces.filter { space == $0.position }.first
    }
    
    func isCheck(for team: Team) -> Bool {
        guard let king = pieces.first(where: {
            $0 is King && $0.team == team
        }) else { fatalError("A kingdom without a king.") }
        return hasPotentialAttackers(for: king)
    }
    
    private func hasPotentialAttackers(for piece: Piece) -> Bool {
        let position = piece.position
        let enemyTeam = piece.team.enemy
        let enemies = pieces.filter { $0.team == enemyTeam }
        return enemies
            .reduce(false, { $0 || $1.moveIsLegal(to: position, on: self) })
    }
    
    func permittedPositions(for piece: Piece) -> [Position] {
        var permittedPositions: [Position] = []
        for xPos in (0..<xAxis) {
            for yPos in (0..<yAxis) {
                let thisPosition = Position(x: xPos, y: yPos)
                if piece.moveIsLegal(to: thisPosition, on: self) {
                    permittedPositions.append(thisPosition)
                }
            }
        }
        return permittedPositions
    }
    
    mutating func insert(piece: Piece) throws {
        guard self.piece(at: piece.position) == nil else {
            throw Error.pieceExistsAtThisPosition
        }
        
        pieces.append(piece)
    }
    
    mutating func delete(at position: Position) throws {
        guard self.piece(at: position) != nil else {
            throw Error.noPieceExistsAtThisPosition
        }
        
        pieces.removeAll { $0.position == position }
    }
    
    static func piece(from string: String, position: Position, whiteTeam: Team = .faceYPositive) -> Piece? {
        
        let blackTeam = whiteTeam.enemy
        
        let lookupTable: [String: Piece] = [
            "♚": King(team: whiteTeam, position: position),
            "♔": King(team: blackTeam, position: position),
            "♛": Queen(team: whiteTeam, position: position),
            "♕": Queen(team: blackTeam, position: position),
            "♝": Bishop(team: whiteTeam, position: position),
            "♗": Bishop(team: blackTeam, position: position),
            "♞": Knight(team: whiteTeam, position: position),
            "♘": Knight(team: blackTeam, position: position),
            "♜": Rook(team: whiteTeam, position: position),
            "♖": Rook(team: blackTeam, position: position),
            "♟": Pawn(team: whiteTeam, position: position),
            "♙": Pawn(team: blackTeam, position: position)
        ]
        
        return lookupTable[string]
    }
    
    static func board(from string: String) throws -> Board {
        let ary = string.multiLineCharArray
        guard ary.count <= 8 else { throw Error.inputOutOfBounds }
        try ary.forEach { subArry in
            guard subArry.count <= 8 else { throw Error.inputOutOfBounds }
        }
        
        var board = Board()
        for yPos in (0..<8) {
            for xPos in (0..<8) {
                let str = ary[7-yPos][xPos]
                let position = Position(x: xPos, y: yPos)
                if let piece = Board.piece(from: str, position: position) {
                    try board.insert(piece: piece)
                }
            }
        }
        return board
    }

    static func standardSetup() -> Board {
        
        let setupString = """
            ♖♘♗♕♔♗♘♖
            ♙♙♙♙♙♙♙♙
                    
                    
                    
                    
            ♟♟♟♟♟♟♟♟
            ♜♞♝♛♚♝♞♜
            """
        
        return try! Board.board(from: setupString)
    }
    
    func toString() -> String {
        toStringAry().joined(separator: "\n")
    }

    func toStringAry() -> [String] {
        let strings = (0..<8).map { yPos in
            let invertedY = 7-yPos

            return (0..<8).map { xPos in
                piece(at: Position(x: xPos, y: invertedY))?.description ?? " "
            }.joined()
        }
        return strings
    }
    
}

extension Board: Equatable {
    
    static func == (lhs: Board, rhs: Board) -> Bool {
        lhs.toString() == rhs.toString()
    }
    
}
