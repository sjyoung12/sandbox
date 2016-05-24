//
//  TTTSolver.swift
//  TTT
//
//  Created by Steve Young on 5/20/16.
//  Copyright © 2016 Steve Young. All rights reserved.
//

import Foundation

struct TTTSolver {

    func findSolution(board: TTTBoard) -> TTTSolution? {
        for potentialSolution: TTTSolution in board.possibleSolutions() {
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
