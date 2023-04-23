//
//  StalemateCalculator.swift
//  
//
//  Created by Jeffrey Thompson on 4/13/23.
//

import Foundation

struct StalemateCalculator {
    
    static func isStalemate(on board: Board, for team: Team) -> Bool {
        let teamPieces = board.pieces.filter({ $0.team == team })
        for piece in teamPieces {
            if let positions = try? board.permittedPositions(for: piece) {
                if positions.count > 0 { return false }
            }
        }
        return true
    }
}
