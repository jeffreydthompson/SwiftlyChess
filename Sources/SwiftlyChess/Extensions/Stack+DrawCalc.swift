//
//  File.swift
//  
//
//  Created by Jeffrey Thompson on 4/14/23.
//

import Foundation

extension Stack where Element == Board {
    
    //FIXME: - this isn't a real definition for 'draw'
    var isDraw: Bool {
        if count < 50 { return false }
        let records = suffix(maxLength: 50)
        let pieceCount = records.first?.pieces.count ?? -1
        for record in records {
            if pieceCount != record.pieces.count { return false }
        }
        return true
    }
    
}
