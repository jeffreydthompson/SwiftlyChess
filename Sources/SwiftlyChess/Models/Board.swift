//
//  Board.swift
//
//  Created by Jeffrey Thompson on 1/16/23.
//

import Foundation

public struct Board {
    
    enum Error: Swift.Error {
        case sameTeamPieceExistsAtThisPosition
        case pieceExistsAtThisPosition
        case noPieceExistsAtThisPosition
        case inputOutOfBounds
        case moveInterference
        case noKing
    }
    
    var xAxis = 8
    var yAxis = 8

    var pieces: [Piece] = []
    
    func king(for team: Team) -> King? {
        pieces.first(where: {
            $0 is King && $0.team == team
        }) as? King
    }

    func piece(at space: Position) -> Piece? {
        pieces.filter { space == $0.position }.first
    }
    
    func teamPieces(for team: Team) -> [Piece] {
        pieces.filter { $0.team == team }
    }
    
    func castlingSet(for team: Team, rookXisLessThanKingX: Bool) -> (king: King, rook: Rook)? {
        
        let rookX = rookXisLessThanKingX ? 0 : 7
        let rookY = (team == .faceYPositive) ? 0 : 7
        
        if let king = king(for: team),
           king.isInInitialPosition,
           let rook = piece(at: Position(x: rookX, y: rookY)!) as? Rook,
           rook.isInInitialPosition {
            return (king: king, rook: rook)
        } else {
            return nil
        }
    }
    
    func isStalemate(for team: Team) -> Bool {
        StalemateCalculator.isStalemate(on: self, for: team)
    }
    
    func isCheck(for team: Team) throws -> Bool {
        var calc = try CheckmateCalculator(team: team, board: self)
        return calc.isCheck()
    }
    
    func isCheckmate(for team: Team) throws -> Bool {
        var calc = try CheckmateCalculator(team: team, board: self)
        return try calc.isCheckmate()
    }
    
    func attackPositions(for piece: Piece) throws -> [Position] {
        
        var attackPositions = [Position]()
        let permitted = try permittedPositions(for: piece)
        for position in permitted {
            if let searchPiece = self.piece(at: position),
               searchPiece.team == piece.team.enemy {
                attackPositions.append(position)
            }
        }
        return attackPositions
    }

    func permittedPositions(for piece: Piece) throws -> [Position] {
        
        return try piece
            .positionsInRange()
            .compactMap {
                try piece.moveIsLegal(to: $0, on: self) ? $0 : nil
        }
    }
    
    mutating func insert(piece: Piece) throws {
        guard self.piece(at: piece.position) == nil else {
            throw Error.pieceExistsAtThisPosition
        }
        
        pieces.append(piece)
    }
    
    mutating func remove(at position: Position) throws {
        guard self.piece(at: position) != nil else {
            throw Error.noPieceExistsAtThisPosition
        }
        
        pieces.removeAll { $0.position == position }
    }
    
    /**
     returns score
     */
    @discardableResult
    mutating func movePiece(
        at position: Position,
        to: Position) throws -> Int {
            
            guard var movePiece = piece(at: position) else {
                throw Error.noPieceExistsAtThisPosition
            }
            
            var points = 0
            if let occupyingPiece = piece(at: to) {
                if occupyingPiece.team != movePiece.team {
                    points = occupyingPiece.pieceValue ?? 1000 // king value nil - artificially high number.
                    try self.remove(at: to)
                } else {
                    throw Error.sameTeamPieceExistsAtThisPosition
                }
            }
            
            movePiece.position = to
            try remove(at: position)
            try insert(piece: movePiece)
            return points
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
                let position = Position(x: xPos, y: yPos)!
                if let piece = PieceMaker.piece(from: str, at: position) {
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
    
    func debugPrint() {
        print(toString())
    }
    
    func toString() -> String {
        toStringAry().joined(separator: "\n")
    }

    func toStringAry() -> [String] {
        let strings = (0..<8).map { yPos in
            let invertedY = 7-yPos

            return (0..<8).map { xPos in
                piece(at: Position(x: xPos, y: invertedY)!)?.description ?? " "
            }.joined()
        }
        return strings
    }
    
}

extension Board: Equatable {
    
    public static func == (lhs: Board, rhs: Board) -> Bool {
        lhs.toString() == rhs.toString()
    }
    
}
