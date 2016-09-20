//
//  SummaryViewController.m
//  piggy
//
//  Created by Steve Young on 9/9/16.
//  Copyright © 2016 Steve Young. All rights reserved.
//

#import "SummaryViewController.h"

#import "CVTableViewCell.h"

@interface LetterCVCell : UICollectionViewCell
@property (strong, nonatomic) UILabel *letterLabel;
@end

@implementation LetterCVCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _letterLabel = [[UILabel alloc] initWithFrame:frame];
        [self.contentView addSubview:_letterLabel];
    }
    return self;
}


@end


@interface LetterCVController : NSObject <UICollectionViewDataSource>

@property (copy, nonatomic) NSString *word;

@end

@implementation LetterCVController

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _word.length;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    LetterCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[LetterCVCell description] forIndexPath:indexPath];
    cell.letterLabel.text = [_word substringWithRange:NSMakeRange(indexPath.row, 1)];
    return cell;
}

@end

@interface SummaryViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) NSMutableArray<LetterCVController *> *cvControllers;

@end

@implementation SummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _data = @[
              @"fdsafdsafdsafdsafdsafdsa",
              @"hjklhjklhjklhjklhjklhjklh",
              @"vguvguvgyuvgyuvgyuvgyvugyuv",
              ];
    _cvControllers = [NSMutableArray new];
    [_tableView registerClass:[CVTableViewCell class] forCellReuseIdentifier:[CVTableViewCell description]];
    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CVTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[CVTableViewCell description]];
    [cell.collectionView registerClass:[LetterCVCell class] forCellWithReuseIdentifier:[LetterCVCell description]];
    @synchronized (_cvControllers) {
        NSUInteger index = [_cvControllers indexOfObjectPassingTest:^BOOL(LetterCVController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            return obj.word == nil;
        }];
        if (index == NSNotFound) {
            [_cvControllers addObject:[LetterCVController new]];
            index = _cvControllers.count - 1;
        }
        LetterCVController *ctrlr = _cvControllers[index];
        ctrlr.word = _data[indexPath.row];
        cell.collectionView.dataSource = ctrlr;
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell.collectionView reloadData];
        });
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    CVTableViewCell *cvCell = (CVTableViewCell *)cell;
    LetterCVController *ctrlr = cvCell.collectionView.dataSource;
    ctrlr.word = nil;
    cvCell.collectionView.dataSource = nil;
}

@end
