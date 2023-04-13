//
//  StalemateCalculator.swift
//  
//
//  Created by Jeffrey Thompson on 4/13/23.
//

import Foundation

struct StalemateCalculator {
    
    func isStalemate(on board: Board, for team: Team) -> Bool {
        let teamPieces = board.pieces.filter({ $0.team == team })
        return false
    }
}
