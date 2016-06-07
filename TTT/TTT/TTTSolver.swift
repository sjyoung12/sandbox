//
//  TTTSolver.swift
//  TTT
//
//  Created by Steve Young on 5/20/16.
//  Copyright © 2016 Steve Young. All rights reserved.
//

import Foundation



struct TTTSolver {

    static func findSolution(board: TTTBoard) -> TTTSolution? {
        for potentialSolution: TTTSolution in board.solutions {
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
        var bestMoveScore: Int = -99
        
        let nextPlayer = player.flip
        for move: TTTMove in board.getPossibleMoves(player) {
            var newBoard = board
            newBoard.placeMove(move)
            let currentScore: Int = minimax(newBoard, activePlayer: nextPlayer)
            print("FINAL RESULT: If \(player.name) places at (\(move.index.row), \(move.index.col)), the outcome will be \(currentScore)\n\n")
            if currentScore > bestMoveScore {
                bestMove = move
                bestMoveScore = currentScore
            }
        }
        return bestMove
    }

    func minimax(board: TTTBoard, activePlayer: TTTPlayer) -> Int {
        if let solution = TTTSolver.findSolution(board) {
            // Base case: game has been won
            return solution.player == player ? 10 : -10
        }
        // Initialize with 0 to represent case where no moves are left
        let moves = board.getPossibleMoves(activePlayer)
        if moves.count == 0 {
            return 0
        }
        var scores: [Int] = [Int]()
        let nextPlayer = activePlayer.flip
        for move: TTTMove in moves {
            var newBoard = board
            newBoard.placeMove(move)
            let score = minimax(newBoard, activePlayer: nextPlayer)
            //print("If \(activePlayer.name) places at (\(move.index.row), \(move.index.col)), the outcome will be \(score)")
            scores.append(score)
        }
        return (activePlayer == player ? scores.maxElement() : scores.minElement())!
    }
    

}
