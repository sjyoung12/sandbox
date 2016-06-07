//
//  TTTModel.swift
//  TTT
//
//  Created by Steve Young on 5/20/16.
//  Copyright © 2016 Steve Young. All rights reserved.
//

import Foundation

enum TTTPlayer {
    case x
    case o

    var name: String {
        switch self {
        case .x:
            return "X"
        case .o:
            return "O"
        }
    }

    var flip: TTTPlayer {
        switch self {
        case .x:
            return .o
        case .o:
            return .x
        }
    }
}

struct TTTMove {
    let player: TTTPlayer
    let index: TTTBoardIndex
}

struct TTTSolution {
    var player: TTTPlayer?
    let startIndex: TTTBoardIndex
    let direction: TTTBoardDirection
    let dim: Int

    var counts = [TTTPlayer: Int]()
    
    init(startIndex: TTTBoardIndex, direction: TTTBoardDirection, dim: Int) {
        counts = [TTTPlayer: Int]()
        player = nil
        self.direction = direction
        self.startIndex = startIndex
        self.dim = dim
    }

    func containsIndex(index: TTTBoardIndex) -> Bool {
        let totalRowDelta = index.row - startIndex.row
        let totalColDelta = index.col - startIndex.col
        switch direction {
        case TTTBoardDirection.HORIZONTAL:
            return index.row == startIndex.row
        case TTTBoardDirection.VERTICAL:
            return index.col == startIndex.col
        case TTTBoardDirection.DIAGONAL:
            return totalRowDelta == totalColDelta
        case TTTBoardDirection.REVERSE_DIAGONAL:
            return totalRowDelta == -totalColDelta
        }
    }
    
    mutating func recordMoveByPlayer(player: TTTPlayer) -> Bool {
        let newCount:Int = (counts[player] ?? 0) + 1
        counts[player] = newCount
        if (newCount == dim) {
            self.player = player
            return true
        } else {
            return false
        }
    }
}

struct TTTBoardIndex {
    let row: Int
    let col: Int

    init(row: Int, col: Int) { self.row = row; self.col = col; }
    init(indexPath: NSIndexPath) {
        self.init(row: indexPath.section, col: indexPath.row)
    }
    func toIndexPath() -> NSIndexPath {
        return NSIndexPath.init(forRow: col, inSection: row)
    }
}

enum TTTBoardDirection {
    case HORIZONTAL
    case VERTICAL
    case DIAGONAL
    case REVERSE_DIAGONAL

    func traversalDeltas() -> (Int, Int) {
        switch self {
        case .HORIZONTAL:
            return (0, 1)
        case .VERTICAL:
            return (1, 0)
        case .DIAGONAL:
            return (1, 1)
        case .REVERSE_DIAGONAL:
            return (-1, 1)
        }
    }
}

struct TTTBoard {
    let dim: Int
    var moves: [[TTTMove?]]
    var rowCandidates: [TTTSolution]
    var colCandidates: [TTTSolution]
    var diagCandidate: TTTSolution
    var reverseDiagCandidate: TTTSolution
    var solutions: [TTTSolution]

    init (withDimension dim: Int) {
        self.dim = dim
        moves = Array(count: dim, repeatedValue: [TTTMove?](count: dim, repeatedValue: nil))
        solutions = [TTTSolution]()

        // Enumerate all possible solutions for a board of this dimension
        diagCandidate = TTTSolution(
            startIndex: TTTBoardIndex(row: 0, col: 0),
            direction: TTTBoardDirection.DIAGONAL,
            dim: dim
        )
        reverseDiagCandidate = TTTSolution(
            startIndex: TTTBoardIndex(row: dim - 1, col: 0),
            direction: TTTBoardDirection.REVERSE_DIAGONAL,
            dim: dim
        )
        rowCandidates = [TTTSolution]()
        colCandidates = [TTTSolution]()

        for i in 0..<dim {
            rowCandidates.append(
                TTTSolution(
                    startIndex: TTTBoardIndex(row: i, col: 0),
                    direction: TTTBoardDirection.HORIZONTAL,
                    dim: self.dim
                )
            )
            colCandidates.append(
                TTTSolution(
                    startIndex: TTTBoardIndex(row: 0, col: i),
                    direction: TTTBoardDirection.VERTICAL,
                    dim: self.dim
                )
            )
        }
    }

    mutating func placeMove(move: TTTMove) {
        assert(getMove(atIndex: move.index) == nil)
        self.moves[move.index.row][move.index.col] = move
        if (rowCandidates[move.index.row].recordMoveByPlayer(move.player)) {
            solutions.append(rowCandidates[move.index.row])
        }
        if (colCandidates[move.index.col].recordMoveByPlayer(move.player)) {
            solutions.append(colCandidates[move.index.col])
        }
        if (diagCandidate.containsIndex(move.index) && diagCandidate.recordMoveByPlayer(move.player)) {
            solutions.append(diagCandidate)
        }
        if (reverseDiagCandidate.containsIndex(move.index) && reverseDiagCandidate.recordMoveByPlayer(move.player)) {
            solutions.append(reverseDiagCandidate)
        }
    }

    func getMove(atIndex index: TTTBoardIndex) -> TTTMove? {
        return moves[index.row][index.col]
    }

    func getPossibleMoves(player: TTTPlayer) -> [TTTMove] {
        var possibleMoves = [TTTMove]()
        for i in 0..<dim {
            for j in 0..<dim {
                if moves[i][j] == nil {
                    possibleMoves.append(TTTMove(player: player, index: TTTBoardIndex(row: i, col: j)))
                }
            }
        }
        return possibleMoves
    }
}