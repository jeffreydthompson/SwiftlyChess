//
//  GameTestsSetups.swift
//  TestingDataStructuresTests
//
//  Created by Jeffrey Thompson on 1/23/23.
//

import Foundation

let attackSetup = """
    -♘♗♕♔♗♘♖
    ♙♙♙♙♙♙♙♙
    ---♖----
    --------
    --------
    ---♛----
    ♟♟♟♟♟♟♟♟
    ♜♞♝-♚♝♞♜
    """

let pawnAttackTest = """
    -♘♗♕♔♗♘♖
    ♙♙♙♙♙♙♙♙
    ---♛----
    --------
    --------
    --------
    ♟♟♟♟♟♟♟♟
    ♜♞♝-♚♝♞♜
    """

let checkFindTestSetup = """
    ♖♘♗♕♔♗♘♖
    ♙♙♙♙♙-♙♙
    -----♟--
    --------
    --------
    --------
    ♟♟♟♟♟♟♟♟
    ♜♞♝♛♚♝♞♜
    """

let checkFindTestSetupTwo = """
    ♖♘♗♕♔♗♘♖
    ♙♙♙♙--♙♙
    -----♟--
    --------
    -♛------
    ♝-------
    ♟♟♟♟♟♟♟♟
    ♜♞--♚♝♞♜
    """
