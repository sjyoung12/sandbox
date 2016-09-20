//
//  CVTableViewCell.h
//  piggy
//
//  Created by Steve Young on 9/19/16.
//  Copyright © 2016 Steve Young. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface CVTableViewCell : UITableViewCell

@property (strong, nonatomic, nonnull) IBOutlet UICollectionView *collectionView;

@end
NS_ASSUME_NONNULL_END
