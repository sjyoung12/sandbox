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
    
    var name: String  {
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
    init (withPlayer player:TTTPlayer) {
        self.player = player
    }
}

struct TTTBoard {
    let dim: Int
    var moves: [[TTTMove?]]
    init (withDimension dim:Int) {
        self.dim = dim
        moves = Array(count:dim, repeatedValue:[TTTMove?](count:dim, repeatedValue: nil))
    }
}