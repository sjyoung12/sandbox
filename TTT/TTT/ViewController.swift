//
//  ViewController.swift
//  TTT
//
//  Created by Steve Young on 5/17/16.
//  Copyright © 2016 Steve Young. All rights reserved.
//

import UIKit

class TTTCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        backgroundColor = nil
    }
}

class ViewController: UICollectionViewController {
    let dim: Int = 3
    var currentPlayer: TTTPlayer!
    var currentSolution: TTTSolution?
    var board: TTTBoard!
    let solver: TTTSolver = TTTSolver()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        collectionView?.backgroundColor = UIColor.lightGrayColor()

        currentPlayer = .x
        board = TTTBoard(withDimension: dim)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return dim
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dim
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: TTTCell = collectionView.dequeueReusableCellWithReuseIdentifier("TTTCell", forIndexPath: indexPath) as! TTTCell
        if let move: TTTMove = board.moves[indexPath.section][indexPath.row] {
            cell.nameLabel.text = move.player.name
        }
        cell.backgroundColor = currentSolution?.containsIndex(TTTBoardIndex(indexPath: indexPath)) == true ? UIColor.redColor() : UIColor.whiteColor()
        return cell
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let index = TTTBoardIndex(indexPath: indexPath)
        if currentPlayer != nil && board.getMove(atIndex: index) == nil {
            board.placeMove(TTTMove(player: currentPlayer, index: index))
            currentSolution = TTTSolver.findSolution(board, lastMoveIndex: index)
            if currentSolution != nil {
                currentPlayer = nil
                collectionView.reloadData()
            } else {
                currentPlayer = currentPlayer?.flip
                collectionView.reloadItemsAtIndexPaths([indexPath])
            }
        }
    }

}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        let cellWidth = (collectionView.frame.width - (CGFloat(dim) - 1)) / CGFloat(dim)
        return CGSizeMake(cellWidth, cellWidth)
    }

    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAtIndex
        section: Int) -> CGFloat
    {
        return 1.0
    }

    func collectionView(
        collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAtIndex
        section: Int) -> CGFloat
    {
        return 1.0
    }

    func collectionView(
        collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex
        section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsetsMake(0.0, 0.0, 1.0, 0.0)
    }
}

