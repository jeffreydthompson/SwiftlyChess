//
//  Graduateable.swift
//  
//
//  Created by Jeffrey Thompson on 1/25/23.
//

import Foundation

protocol Graduateable: Piece {
    static func graduate(pawn: Pawn) -> Self
}
