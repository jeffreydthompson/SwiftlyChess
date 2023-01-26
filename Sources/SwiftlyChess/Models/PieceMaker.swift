//
//  PieceMaker.swift
//  
//
//  Created by Jeffrey Thompson on 1/24/23.
//

import Foundation

struct PieceMaker {
    
    static func piece(
        from string: String,
        at position: Position,
        whiteTeam: Team = .faceYPositive) -> Piece? {
        
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
    
}
