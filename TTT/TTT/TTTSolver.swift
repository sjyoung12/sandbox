//
//  TTTSolver.swift
//  TTT
//
//  Created by Steve Young on 5/20/16.
//  Copyright © 2016 Steve Young. All rights reserved.
//

import Foundation



struct TTTSolver {

    static func findSolution(board: TTTBoard, lastMoveIndex:TTTBoardIndex?) -> TTTSolution? {
        for potentialSolution: TTTSolution in board.solutions {
            if lastMoveIndex != nil && potentialSolution.containsIndex(lastMoveIndex!) {
                continue
            }
            let counts = board.tabulateMovesByPlayer(potentialSolution.startIndex, direction: potentialSolution.direction)
            for (player, count) in counts {
                if count == board.dim {
                    return TTTSolution(player: player, startIndex: potentialSolution.startIndex, direction: potentialSolution.direction)
                }
            }
        }
        return nil
    }
}

struct TTTMiniMax {
    
    let player: TTTPlayer
    let board: TTTBoard
    
    func chooseNextMove() -> TTTMove? {
        var bestMove: TTTMove?
        var bestMoveScore: Int = 0
        for move: TTTMove in board.getPossibleMoves(player) {
            var newBoard = board
            newBoard.placeMove(move)
            let currentScore: Int = minimax(newBoard, activePlayer: player)
            if currentScore > bestMoveScore {
                bestMove = move
                bestMoveScore = currentScore
            }
        }
        return bestMove
    }

    func minimax(board: TTTBoard, activePlayer: TTTPlayer, depth: Int=0) -> Int {
        if let solution = TTTSolver.findSolution(board, lastMoveIndex: nil) {
            if solution.player == player {
                return 10
            } else {
                return -10
            }
        }
        // Initialize with 0, to represent case where no moves are left
        var scores: [Int] = [0]
        for move: TTTMove in board.getPossibleMoves(activePlayer) {
            var newBoard = board
            newBoard.placeMove(move)
            scores.append(minimax(newBoard, activePlayer: activePlayer.flip, depth: depth + 1))
        }
        return (activePlayer == player ? scores.maxElement() : scores.minElement())!
    }
    

}
