//
//  Team.swift
//
//  Created by Jeffrey Thompson on 1/16/23.
//

import Foundation

public enum Team {
    case faceYPositive, faceYNegative
    
    var enemy: Team {
        switch self {
        case .faceYPositive:
            return .faceYNegative
        case .faceYNegative:
            return .faceYPositive
        }
    }
}
