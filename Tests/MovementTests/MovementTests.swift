//
//  MovementTests.swift
//  
//
//  Created by Jeffrey Thompson on 1/23/23.
//

import XCTest
@testable import SwiftlyChess

final class MovementTests: XCTestCase {

    var sut = Board()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSetup() throws {
        sut = Board.standardSetup()
        XCTAssertEqual(sut.pieces.count, 32)
    }
    
    func testInitialPositionCheck() throws {
        sut = Board.standardSetup()
        let rookPremove = sut.piece(at: Position(x: 0, y: 0)!)
        XCTAssertTrue(rookPremove!.isInInitialPosition)
        try sut.movePiece(at: Position(x: 0, y: 0)!, to: Position(x: 0, y: 3)!)
        let rookPostmove = sut.piece(at: Position(x: 0, y: 3)!)
        XCTAssertFalse(rookPostmove!.isInInitialPosition)
        
        sut = try Board.board(from: testPawnOne)
        let pawn = sut.piece(at: Position(x: 1, y: 3)!)
        XCTAssertFalse(pawn!.isInInitialPosition)
    }
    
    func testPieceStringLookup() throws {
        let pawnString = "♟"
        let pawn = PieceMaker.piece(from: pawnString, at: Position(x: 0, y: 0)!)
        XCTAssertNotNil(pawn)
        
        let charAry = standardSetup.multiLineCharArray
        
        for yPos in (0..<8) {
            for xPos in (0..<8) {
                let str = charAry[7-yPos][xPos]
                let position = Position(x: xPos, y: yPos)!
                if let piece = PieceMaker.piece(from: str, at: position) {
                    try sut.insert(piece: piece)
                }
            }
        }
        
        XCTAssertEqual(sut, Board.standardSetup())
        try sut.remove(at: Position(x: 0, y: 0)!)
        XCTAssertNotEqual(sut, Board.standardSetup())
    }
    
    func testPawnMoveDoesNotCauseCheck() throws {
        
        sut = try Board.board(from: checkTest)
        let check = try sut.isCheck(for: .faceYPositive)
        let noCheck = try sut.isCheck(for: .faceYNegative)
        
        XCTAssertTrue(check)
        XCTAssertFalse(noCheck)
        
        sut = try Board.board(from: checkTestPtTwo)
        let pawn = sut.piece(at: Position(x: 5, y: 1)!)!
        let pPositions = try sut.permittedPositions(for: pawn)

        XCTAssertEqual(pPositions.count, 0)
    }
    
    func testDiscretePawnMovement() throws {
        
        sut = try Board.board(from: testPawnThree)
        let pawn = sut.piece(at: Position(x: 1, y: 1)!)!
        let pPositions = try sut.permittedPositions(for: pawn)

        XCTAssertEqual(pPositions.count, 1)
        XCTAssertTrue(pPositions.contains(where: { position in
            position == Position(x: 2, y: 2)
        }))
    }
    
    func testPawnMovement() throws {
        sut = Board.standardSetup()
        let pawn = sut.piece(at: Position(x: 1, y: 1)!)!
        var pPositions = try sut.permittedPositions(for: pawn)

        XCTAssertEqual(pPositions.count, 2)
        XCTAssertTrue(pPositions.contains(where: { position in
            position == Position(x: 1, y: 2)!
        }))
        XCTAssertTrue(pPositions.contains(where: { position in
            position == Position(x: 1, y: 3)!
        }))
        
        sut = try Board.board(from: testPawnOne)
        pPositions = try sut.permittedPositions(for: pawn)

        XCTAssertEqual(pPositions.count, 1)
        XCTAssertTrue(pPositions.contains(where: { position in
            position == Position(x: 1, y: 2)!
        }))
        
        sut = try Board.board(from: testPawnTwo)
        pPositions = try sut.permittedPositions(for: pawn)
        
        XCTAssertEqual(pPositions.count, 0)
        
        sut = try Board.board(from: testPawnThree)
        pPositions = try sut.permittedPositions(for: pawn)

        XCTAssertEqual(pPositions.count, 1)
        XCTAssertTrue(pPositions.contains(where: { position in
            position == Position(x: 2, y: 2)
        }))
        
        let randoPawn = sut.piece(at: Position(x: 4, y: 3)!)!
        pPositions = try sut.permittedPositions(for: randoPawn)
        
        XCTAssertEqual(pPositions.count, 1)
        XCTAssertTrue(pPositions.contains(where: { position in
            position == Position(x: 4, y: 4)
        }))
        
        let randoPawnTwo = sut.piece(at: Position(x: 6, y: 5)!)!
        
        pPositions = try sut.permittedPositions(for: randoPawnTwo)
        
        XCTAssertEqual(pPositions.count, 2)
        XCTAssertTrue(pPositions.contains(where: { position in
            position == Position(x: 6, y: 4)!
        }))
        XCTAssertTrue(pPositions.contains(where: { position in
            position == Position(x: 7, y: 4)!
        }))
        
        
    }
    
    func testPawnAttack() throws {
        sut = try Board.board(from: testPawnFour)
        
        var testPawn = sut.piece(at: Position(x: 2, y: 1)!)!
        var pPositions = try sut.permittedPositions(for: testPawn)
        print("TESTINGDEBUG: \(pPositions)")
        XCTAssertTrue(pPositions.contains(where: { position in
            position == Position(x: 3, y: 2)!
        }))
        
        sut = try Board.board(from: testPawnFive)
        
        testPawn = sut.piece(at: Position(x: 2, y: 6)!)!
        pPositions = try sut.permittedPositions(for: testPawn)
        print("TESTINGDEBUG: \(pPositions)")
        XCTAssertTrue(pPositions.contains(where: { position in
            position == Position(x: 3, y: 5)!
        }))
    }

    func testKnightMovement() throws {
        sut = try Board.board(from: testKnightOne)

        let bKnightL = try sut.piece(at: Position(x: 1, y: 7)!)!
        let bKnightR = try sut.piece(at: Position(x: 6, y: 7)!)!
        let wKnightL = try sut.piece(at: Position(x: 1, y: 0)!)!
        let wKnightR = try sut.piece(at: Position(x: 6, y: 0)!)!
        let randoKnight = try sut.piece(at: Position(x: 3, y: 3)!)!
        
        var positions = try sut.permittedPositions(for: bKnightL)
        XCTAssertEqual(positions.count, 1)
        XCTAssertTrue(positions.contains(where: { position in
            position == Position(x: 0, y: 5)!
        }))
        
        positions = try sut.permittedPositions(for: bKnightR)
        XCTAssertEqual(positions.count, 2)
        XCTAssertTrue(positions.contains(where: { position in
            position == Position(x: 5, y: 5)!
        }))
        XCTAssertTrue(positions.contains(where: { position in
            position == Position(x: 7, y: 5)!
        }))
        
        positions = try sut.permittedPositions(for: wKnightL)
        XCTAssertEqual(positions.count, 2)
        XCTAssertTrue(positions.contains(where: { position in
            position == Position(x: 0, y: 2)!
        }))
        XCTAssertTrue(positions.contains(where: { position in
            position == Position(x: 2, y: 2)!
        }))
        
        positions = try sut.permittedPositions(for: wKnightR)
        XCTAssertEqual(positions.count, 2)
        XCTAssertTrue(positions.contains(where: { position in
            position == Position(x: 5, y: 2)!
        }))
        XCTAssertTrue(positions.contains(where: { position in
            position == Position(x: 7, y: 2)!
        }))
        
        positions = try sut.permittedPositions(for: randoKnight)
        XCTAssertEqual(positions.count, 5)
        XCTAssertTrue(positions.contains(where: { position in
            position == Position(x: 2, y: 5)!
        }))
        XCTAssertTrue(positions.contains(where: { position in
            position == Position(x: 1, y: 4)!
        }))
        XCTAssertTrue(positions.contains(where: { position in
            position == Position(x: 1, y: 2)!
        }))
        XCTAssertTrue(positions.contains(where: { position in
            position == Position(x: 5, y: 2)!
        }))
        XCTAssertTrue(positions.contains(where: { position in
            position == Position(x: 5, y: 4)!
        }))
    }
    
    func testRookMovement() throws {
        sut = try Board.board(from: testRook)
        let bRookL = sut.piece(at: Position(x: 0, y: 7)!)!
        let bRookR = sut.piece(at: Position(x: 7, y: 7)!)!
        let wRookL = sut.piece(at: Position(x: 0, y: 0)!)!
        let wRookR = sut.piece(at: Position(x: 0, y: 7)!)!
        
        var positions = try sut.permittedPositions(for: bRookL)
        XCTAssertEqual(positions.count, 0)
        positions = try sut.permittedPositions(for: bRookR)
        XCTAssertEqual(positions.count, 0)
        positions = try sut.permittedPositions(for: wRookL)
        XCTAssertEqual(positions.count, 0)
        positions = try sut.permittedPositions(for: wRookR)
        XCTAssertEqual(positions.count, 0)
        
        let bRook = try sut.piece(at: Position(x: 0, y: 5)!)!
        let wRook = try sut.piece(at: Position(x: 4, y: 4)!)!
        
        positions = try sut.permittedPositions(for: bRook)
        XCTAssertEqual(positions.count, 9)
        XCTAssertTrue(positions.contains(where: { position in
            position == Position(x: 0, y: 1)!
        }))
        positions = try sut.permittedPositions(for: wRook)
        XCTAssertEqual(positions.count, 11)
        XCTAssertTrue(positions.contains(where: { position in
            position == Position(x: 4, y: 6)!
        }))
    }
    
    func testBishopMovement() throws {
        sut = try Board.board(from: testBishop)
        let bBishopL = sut.piece(at: Position(x: 2, y: 7)!)!
        let bBishopR = sut.piece(at: Position(x: 5, y: 7)!)!
        let wBishopL = sut.piece(at: Position(x: 2, y: 0)!)!
        let wBishopR = sut.piece(at: Position(x: 5, y: 0)!)!
        
        var positions = try sut.permittedPositions(for: bBishopL)
        XCTAssertEqual(positions.count, 0)
        positions = try sut.permittedPositions(for: bBishopR)
        XCTAssertEqual(positions.count, 0)
        positions = try sut.permittedPositions(for: wBishopL)
        XCTAssertEqual(positions.count, 0)
        positions = try sut.permittedPositions(for: wBishopR)
        XCTAssertEqual(positions.count, 0)
        
        let bBishop = sut.piece(at: Position(x: 5, y: 4)!)!
        positions = try sut.permittedPositions(for: bBishop)
        XCTAssertEqual(positions.count, 6)
        XCTAssertTrue(positions.contains(where: { position in
            position == Position(x: 6, y: 3)!
        }))
        
        let wBishop = sut.piece(at: Position(x: 2, y: 3)!)!
        positions = try sut.permittedPositions(for: wBishop)
        XCTAssertEqual(positions.count, 4)
    }
    
    func testQueenMovement() throws {
        sut = try Board.board(from: testQueen)
        var wQueenStuck = sut.piece(at: Position(x: 3, y: 0)!)!
        let bQueenStuck = sut.piece(at: Position(x: 3, y: 7)!)!

        var positions = try sut.permittedPositions(for: wQueenStuck)
        XCTAssertEqual(positions.count, 0)
        positions = try sut.permittedPositions(for: bQueenStuck)
        XCTAssertEqual(positions.count, 0)
        
        let wQueen = sut.piece(at: Position(x: 3, y: 3)!)!
        let bQueen = sut.piece(at: Position(x: 5, y: 5)!)!
        
        positions = try sut.permittedPositions(for: wQueen)
        print(positions)
        XCTAssertEqual(positions.count, 13)
        positions = try sut.permittedPositions(for: bQueen)
        XCTAssertEqual(positions.count, 9)
        
        sut = try .board(from: standardSetup)
        wQueenStuck = sut.piece(at: Position(x: 3, y: 0)!)!
        positions = try sut.permittedPositions(for: wQueenStuck)
        XCTAssertEqual(positions.count, 0)
    }
    
    func testKingIsolated() throws {
        sut = try Board.board(from: testKing)
        var sutKing = sut.piece(at: Position(x: 4, y: 0)!)!
        var positions = try sut.permittedPositions(for: sutKing)
        XCTAssertEqual(positions.count, 0)
    }
    
    func testKingMovement() throws {
        sut = try Board.board(from: testKing)
        var sutKing = sut.piece(at: Position(x: 4, y: 0)!)!
        var positions = try sut.permittedPositions(for: sutKing)
        XCTAssertEqual(positions.count, 0)
        
        sutKing = sut.piece(at: Position(x: 4, y: 7)!)!
        positions = try sut.permittedPositions(for: sutKing)
        XCTAssertEqual(positions.count, 0)
        
        // white top left corner
        sut = try Board.board(from: testKingTwo)
        sutKing = sut.piece(at: Position(x: 0, y: 7)!)!
        positions = try sut.permittedPositions(for: sutKing)
        XCTAssertEqual(positions.count, 2)
        XCTAssertTrue(positions.contains(where: { position in
            position == Position(x: 0, y: 6)
        }))
        
        // black center upper
        sut = try Board.board(from: testKingThree)
        sutKing = sut.piece(at: Position(x: 2, y: 5)!)!
        positions = try sut.permittedPositions(for: sutKing)
        XCTAssertEqual(positions.count, 5)
        
        // black in front of white pawns
        sut = try Board.board(from: testKingFour)
        sutKing = sut.piece(at: Position(x: 5, y: 2)!)!
        positions = try sut.permittedPositions(for: sutKing)
        XCTAssertEqual(positions.count, 2)
        
        // black lower right corner
        sut = try Board.board(from: testKingFive)
        sutKing = sut.piece(at: Position(x: 6, y: 0)!)!
        positions = try sut.permittedPositions(for: sutKing)
        XCTAssertEqual(positions.count, 1)
    }
    
    func testCastling() throws {
        sut = try Board.board(from: castlingOne)
        guard var whiteKing = sut.king(for: .faceYPositive) else {
            return
        } // white
        guard var blackKing = sut.king(for: .faceYNegative) else {
            return
        } // black
        var whtPos = try sut.permittedPositions(for: whiteKing)
        var blkPos = try sut.permittedPositions(for: blackKing)
        
        XCTAssertEqual(whtPos.count, 2)
        XCTAssertEqual(blkPos.count, 2)
    }
    
    func testKingNotLeftInCheck() throws {
        sut = try Board.board(from: leftInCheck)
        
        var check = try sut.isCheck(for: .faceYNegative)
        XCTAssertTrue(check)
        
        let blockingPawn = sut.piece(at: Position(x: 2, y: 6)!)
        let blockingQueen = sut.piece(at: Position(x: 3, y: 7)!)
        let nonBlockingPawn = sut.piece(at: Position(x: 7, y: 6)!)
        let blockingKnight = sut.piece(at: Position(x: 1, y: 7)!)
        
        XCTAssertNotNil(blockingKnight)
        XCTAssertNotNil(blockingPawn)
        XCTAssertNotNil(blockingQueen)
        XCTAssertNotNil(nonBlockingPawn)
        XCTAssertTrue(blockingKnight is Knight)
        XCTAssertTrue(nonBlockingPawn is Pawn)
        XCTAssertTrue(blockingPawn is Pawn)
        XCTAssertTrue(blockingQueen is Queen)
        
        let blockingPawnMoves = try sut.permittedPositions(for: blockingPawn!)
        let nonBlockingPawnMoves = try sut.permittedPositions(for: nonBlockingPawn!)
        let blockingQueenMoves = try sut.permittedPositions(for: blockingQueen!)
        let blockingKnightMoves = try sut.permittedPositions(for: blockingKnight!)
        
        XCTAssertEqual(blockingPawnMoves.count, 1)
        XCTAssertEqual(nonBlockingPawnMoves.count, 0)
        print(blockingQueenMoves)
        XCTAssertEqual(blockingQueenMoves.count, 1)
        XCTAssertEqual(blockingKnightMoves.count, 2)
        
    }
    
    func testIsolatedQueen() throws {
        sut = try Board.board(from: leftInCheck)

        let check = try sut.isCheck(for: .faceYNegative)
        XCTAssertTrue(check)
        
        let blockingQueen = sut.piece(at: Position(x: 3, y: 7)!)
        XCTAssertNotNil(blockingQueen)
        XCTAssertTrue(blockingQueen is Queen)
        let blockingQueenMoves = try sut.permittedPositions(for: blockingQueen!)

        print(blockingQueenMoves)
        XCTAssertEqual(blockingQueenMoves.count, 1)
    }
    
    func testKnightPositionsRange() throws {
        sut = try Board.board(from: knightMovementRange)
        
        var knight = sut.piece(at: Position(x: 1, y: 0)!)
        XCTAssertNotNil(knight)
        XCTAssertTrue(knight is Knight)
        var posRange = knight!.positionsInRange()
        XCTAssertEqual(posRange.count, 3)
        
        knight = sut.piece(at: Position(x: 4, y: 4)!)
        XCTAssertNotNil(knight)
        XCTAssertTrue(knight is Knight)
        posRange = knight!.positionsInRange()
        XCTAssertEqual(posRange.count, 8)
    }
    
    @available(macOS 13.0, *)
    func testRookPositionsRange() throws {
        sut = try Board.board(from: rookMovementRange)
        
        var rook = sut.piece(at: Position(x: 1, y: 0)!)
        XCTAssertNotNil(rook)
        XCTAssertTrue(rook is Rook)
        var posRange = rook!.positionsInRange()
        XCTAssertEqual(posRange.count, 14)
        XCTAssertTrue(posRange.contains([Position(x: 1, y: 1)!]))
        
        rook = sut.piece(at: Position(x: 4, y: 4)!)
        XCTAssertNotNil(rook)
        XCTAssertTrue(rook is Rook)
        posRange = rook!.positionsInRange()
        XCTAssertEqual(posRange.count, 14)
    }
    
    @available(macOS 13.0, *)
    func testBishopPositionsRange() throws {
        sut = try Board.board(from: bishopMovementRange)
        
        var bishop = sut.piece(at: Position(x: 1, y: 0)!)
        XCTAssertNotNil(bishop)
        XCTAssertTrue(bishop is Bishop)
        var posRange = bishop!.positionsInRange()
        XCTAssertEqual(posRange.count, 7)
        XCTAssertTrue(posRange.contains([Position(x: 2, y: 1)!]))
        
        bishop = sut.piece(at: Position(x: 4, y: 4)!)
        XCTAssertNotNil(bishop)
        XCTAssertTrue(bishop is Bishop)
        posRange = bishop!.positionsInRange()
        XCTAssertEqual(posRange.count, 13)
    }
    
    @available(macOS 13.0, *)
    func testKingPositionsRange() throws {
        sut = try Board.board(from: kingMovementRange)
        
        // extra + 5 for the castling
        var king = sut.piece(at: Position(x: 1, y: 0)!)
        XCTAssertNotNil(king)
        XCTAssertTrue(king is King)
        var posRange = king!.positionsInRange()
        XCTAssertEqual(posRange.count, 5 + 5)
        XCTAssertTrue(posRange.contains([Position(x: 2, y: 1)!]))
        
        king = sut.piece(at: Position(x: 4, y: 4)!)
        XCTAssertNotNil(king)
        XCTAssertTrue(king is King)
        posRange = king!.positionsInRange()
        XCTAssertEqual(posRange.count, 8 + 5)
    }
    
    @available(macOS 13.0, *)
    func testQueenPositionsRange() throws {
        sut = try Board.board(from: queenMovementRange)
        
        var queen = sut.piece(at: Position(x: 1, y: 0)!)
        XCTAssertNotNil(queen)
        XCTAssertTrue(queen is Queen)
        var posRange = queen!.positionsInRange()
        XCTAssertEqual(posRange.count, 7 + 14)
        XCTAssertTrue(posRange.contains([Position(x: 2, y: 1)!]))
        
        queen = sut.piece(at: Position(x: 4, y: 4)!)
        XCTAssertNotNil(queen)
        XCTAssertTrue(queen is Queen)
        posRange = queen!.positionsInRange()
        XCTAssertEqual(posRange.count, 13 + 14)
    }
    
    @available(macOS 13.0, *)
    func testPawnPositionsRange() throws {
        sut = try Board.board(from: pawnMovementRange)

        var pawn = sut.piece(at: Position(x: 1, y: 0)!)
        XCTAssertNotNil(pawn)
        XCTAssertTrue(pawn is Pawn)
        var posRange = pawn!.positionsInRange()
        XCTAssertEqual(posRange.count, 4)
        XCTAssertTrue(posRange.contains([Position(x: 2, y: 1)!]))

        pawn = sut.piece(at: Position(x: 4, y: 4)!)
        XCTAssertNotNil(pawn)
        XCTAssertTrue(pawn is Pawn)
        posRange = pawn!.positionsInRange()
        XCTAssertEqual(posRange.count, 4)
    }
}
