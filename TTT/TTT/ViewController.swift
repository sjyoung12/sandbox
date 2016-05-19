//
//  ViewController.swift
//  TTT
//
//  Created by Steve Young on 5/17/16.
//  Copyright © 2016 Steve Young. All rights reserved.
//

import UIKit

enum Player {
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
    
    var flip: Player {
        switch self {
            case .x:
                return .o
            case .o:
                return .x
        }
    }
}


class TTTCell: UICollectionViewCell {
    var player: Player? {
        didSet {
            nameLabel.text = player?.name
        }
    }

    @IBOutlet weak var nameLabel: UILabel!

}

class ViewController: UICollectionViewController {
    let dim = 3
    var currentPlayer: Player?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        collectionView?.backgroundColor = UIColor.lightGrayColor()
        
        currentPlayer = .x
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(pow(Double(dim), Double(2)))
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: TTTCell = collectionView.dequeueReusableCellWithReuseIdentifier("TTTCell", forIndexPath: indexPath) as! TTTCell
        cell.backgroundColor = UIColor.whiteColor()
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! TTTCell
        if (cell.player == nil) {
            cell.player = currentPlayer
            currentPlayer = currentPlayer?.flip
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

