//
//  Cartographer.swift
//  
//
//  Created by Jeffrey Thompson on 1/23/23.
//

import Foundation

struct Cartographer {
    
    enum Compass {
        case east, northEast, north, northWest, west, southWest, south, southEast
        
        var isDiagonal: Bool {
            switch self {
            case .north, .south, .east, .west:
                return false
            default:
                return true
            }
        }
    }
    
    func isWithinRange(for rule: MovementRule, from: Position, to: Position) -> Bool {
        
        func isInRange(_ range: Int?) -> Bool {
            guard let limit = range else { return true }
            if abs(from.x - to.x) > limit ||
                abs(from.y - to.y) > limit { return false }
            return true
        }
        
        guard let direction = compass(from: from, to: to) else { return false }
        
        switch rule {
        case .diagonal(let range):
            if !isInRange(range) { return false }
            if !direction.isDiagonal { return false }
            
        case .straight(let range):
            if !isInRange(range) { return false }
            if direction.isDiagonal { return false }
        default:
            break
        }
        return true
    }
    
    func getRange(from: Position, to: Position) -> [Position] {
        
        var xRange = [to.x, from.x].sequentialBetweenMinMax
        var yRange = [to.y, from.y].sequentialBetweenMinMax
        let direction = compass(from: from, to: to)
        
        switch direction {
        case .north, .south:
            xRange = Array(repeating: from.x, count: yRange.count)
        case .east, .west:
            yRange = Array(repeating: from.y, count: xRange.count)
        case .northEast, .southWest:
            break
        case .southEast, .northWest:
            xRange.reverse()
        case .none:
            break
        }
        // assemble positions
        return Array(zip(xRange, yRange))
            .map { Position(x: $0.0, y: $0.1)! }
    }
    
    func compass(from: Position, to: Position) -> Compass? {
        if from.x == to.x && from.y < to.y { return .north }
        if from.x == to.x && from.y > to.y { return .south }
        
        if from.y == to.y && from.x < to.x { return .east }
        if from.y == to.y && from.x > to.x { return .west }
        
        guard abs(from.x - to.x) == abs(from.y - to.y) else { return nil }
        
        if from.x > to.x && from.y > to.y { return .northEast }
        if from.x < to.x && from.y < to.y { return .southWest }
        
        if from.x < to.x && from.y > to.y { return .northWest }
        if from.x > to.x && from.y < to.y { return .southEast }
        return nil
    }
}
