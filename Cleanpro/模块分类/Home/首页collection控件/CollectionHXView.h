//
//  CollectionHXView.h
//  Cleanpro
//
//  Created by mac on 2020/4/20.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol CollectionHXViewDelegate <NSObject>
@optional

- (void)CellTouch:(UITableViewCell*)Cell;
@end
@interface CollectionHXView : UIView
@property (nonatomic,strong) UICollectionView * collectionView;
@property (nonatomic, strong) NSMutableArray * collectionArray;

@property (nonatomic, weak) id<CollectionHXViewDelegate> delegate;

//- (instancetype)initFrame:(CGRect)Frame Array:(NSMutableArray *)arr;
- (instancetype)initFrame:(CGRect)Frame Array:(NSMutableArray *)arr imageArr:(NSMutableArray *)imageArr;
@end

NS_ASSUME_NONNULL_END
