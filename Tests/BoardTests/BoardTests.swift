//
//  BoardTests.swift
//  
//
//  Created by Jeffrey Thompson on 1/23/23.
//

import XCTest
@testable import SwiftlyChess

final class BoardTests: XCTestCase {

    var sut = Board()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCheck() throws {
        sut = try .board(from: checkSetup)
        XCTAssertFalse(sut.isCheck(for: .faceYPositive))
        XCTAssertTrue(sut.isCheck(for: .faceYNegative))
//        XCTAssertFalse(sut.isCheckmate(for: .faceYPositive))
//        XCTAssertFalse(sut.isCheckmate(for: .faceYNegative))
    }
    
    func testCheckmate() throws {
        sut = try .board(from: checkMateSetup)
        XCTAssertTrue(sut.isCheck(for: .faceYNegative))
        XCTAssertFalse(sut.isCheck(for: .faceYPositive))
//        XCTAssertFalse(sut.isCheckmate(for: .faceYPositive))
//        XCTAssertTrue(sut.isCheckmate(for: .faceYNegative))
    }
}
