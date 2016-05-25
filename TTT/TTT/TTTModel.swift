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
    let player: TTTPlayer?
    let startIndex: TTTBoardIndex
    let direction: TTTBoardDirection
    
    func containsIndex(index: TTTBoardIndex) -> Bool {
        let (rowDelta, colDelta) = direction.traversalDeltas()
        let totalRowDelta = index.row - startIndex.row
        let totalColDelta = index.col - startIndex.col
        if (totalRowDelta != 0) {
            return totalColDelta == totalRowDelta * colDelta
        } else if (totalColDelta != 0) {
            return totalRowDelta == totalColDelta * rowDelta
        } else {
            return true
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
    let solutions: [TTTSolution]

    init (withDimension dim: Int) {
        self.dim = dim
        moves = Array(count: dim, repeatedValue: [TTTMove?](count: dim, repeatedValue: nil))
        
        // Enumerate all possible solutions for a board of this dimension
        var solutions: [TTTSolution] = [
            TTTSolution(
                player: nil,
                startIndex: TTTBoardIndex(row: 0, col: 0),
                direction: TTTBoardDirection.DIAGONAL
            ),
            TTTSolution(
                player: nil,
                startIndex: TTTBoardIndex(row: dim - 1, col: 0),
                direction: TTTBoardDirection.REVERSE_DIAGONAL
            )
        ]
        for i in 0..<dim {
            solutions.append(
                TTTSolution(
                    player: nil,
                    startIndex: TTTBoardIndex(row: i, col: 0),
                    direction: TTTBoardDirection.HORIZONTAL
                )
            )
            solutions.append(
                TTTSolution(
                    player: nil,
                    startIndex: TTTBoardIndex(row: 0, col: i),
                    direction: TTTBoardDirection.VERTICAL
                )
            )
        }
        self.solutions = solutions
    }
    
    mutating func placeMove(move: TTTMove) {
        assert(getMove(atIndex:move.index) == nil)
        self.moves[move.index.row][move.index.col] = move
    }

    func getMove(atIndex index: TTTBoardIndex) -> TTTMove? {
        return moves[index.row][index.col]
    }

    func tabulateMovesByPlayer(startIndex: TTTBoardIndex, direction: TTTBoardDirection) -> [TTTPlayer: Int] {
        var counts: [TTTPlayer: Int] = [TTTPlayer: Int]()
        let (rowDelta, colDelta) = direction.traversalDeltas()
        var i: Int = startIndex.row
        var j: Int = startIndex.col
        while (i < dim && j < dim && i >= 0 && j >= 0) {
            if let move: TTTMove = moves[i][j] {
                counts[move.player] = (counts[move.player] ?? 0) + 1
            }
            i += rowDelta
            j += colDelta
        }
        return counts
    }
    
    func getPossibleMoves(player: TTTPlayer) -> [TTTMove] {
        var possibleMoves = [TTTMove]()
        for i in 0..<dim {
            for j in 0..<dim {
                if moves[i][j] == nil {
                    possibleMoves.append(TTTMove(player:player, index:TTTBoardIndex(row:i, col:j)))
                }
            }
        }
        return possibleMoves
    }
}