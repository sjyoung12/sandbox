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
}

class ViewController: UICollectionViewController {
    let dim: Int = 3
    var currentPlayer: TTTPlayer!
    var board: TTTBoard!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        collectionView?.backgroundColor = UIColor.lightGrayColor()
        
        currentPlayer = .x
        board = TTTBoard(withDimension:dim)
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
        cell.backgroundColor = UIColor.whiteColor()
        if let move: TTTMove = board.moves[indexPath.section][indexPath.row] {
            cell.nameLabel.text = move.player.name
        }
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if board.moves[indexPath.section][indexPath.row] == nil {
            board.moves[indexPath.section][indexPath.row] = TTTMove(withPlayer: currentPlayer)
            currentPlayer = currentPlayer?.flip
            collectionView.reloadItemsAtIndexPaths([indexPath])
        }
    }

}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let cellWidth = (collectionView.frame.width - (CGFloat(dim) - 1)) / CGFloat(dim)
        return CGSizeMake(cellWidth, cellWidth)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1.0
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1.0
    }
}

