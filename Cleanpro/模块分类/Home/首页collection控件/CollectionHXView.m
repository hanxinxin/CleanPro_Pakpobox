//
//  CollectionHXView.m
//  Cleanpro
//
//  Created by mac on 2020/4/20.
//  Copyright © 2020 mac. All rights reserved.
//

#import "CollectionHXView.h"
#import "CollectionHXViewCell.h"

#define CollectionViewCellID @"TopCollectionViewCell"
@interface CollectionHXView ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    
}
@property (nonatomic,strong)NSMutableArray * Imagearray;
@end
@implementation CollectionHXView
//@synthesize collectionArray;
- (instancetype)init {
    if (self = [super init]) {
       
    }
    return self;
}
- (instancetype)initFrame:(CGRect)Frame Array:(NSMutableArray *)arr imageArr:(NSMutableArray *)imageArr{
    if (self = [super init]) {
        self.collectionArray = arr;
        self.Imagearray=imageArr;
        self.frame=Frame;
        self.backgroundColor=[UIColor whiteColor];
        [self addCollectionView:CGRectMake(0, 20, self.frame.size.width,self.frame.size.height-20)];
//        [self addArrayImage];
    }
    return self;
}
-(void)awakeFromNib
{
    //说明文档里说必须调用父类的awakeFromNib，以防出现意外，详细说明见文档
    [super awakeFromNib];
    
}

- (NSMutableArray *)collectionArray {
    if (!_collectionArray) {
        _collectionArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _collectionArray;
}
- (NSMutableArray *)Imagearray {
    if (!_Imagearray) {
        _Imagearray = [NSMutableArray arrayWithCapacity:0];
        [_Imagearray addObject:@"icon_laundry1"];
        [_Imagearray addObject:@"icon_ewash"];
        [_Imagearray addObject:@"icon_ironing"];
        [_Imagearray addObject:@"icon_powerbank"];
        [_Imagearray addObject:@"icon_vending"];
        [_Imagearray addObject:@"icon_gifts"];
        [_Imagearray addObject:@"icon_locker"];
        [_Imagearray addObject:@"icon_coming"];
    }
    return _Imagearray;
}

-(void)addArrayImage
{
    [_Imagearray addObject:@"icon_laundry1"];
    [_Imagearray addObject:@"icon_ewash"];
    [_Imagearray addObject:@"icon_ironing"];
    [_Imagearray addObject:@"icon_powerbank"];
    [_Imagearray addObject:@"icon_vending"];
    [_Imagearray addObject:@"icon_gifts"];
    [_Imagearray addObject:@"icon_locker"];
    [_Imagearray addObject:@"icon_coming"];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
}



-(void)addCollectionView:(CGRect)frmae
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    // 设置UICollectionView为横向滚动
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    // 每一行cell之间的间距
    flowLayout.minimumLineSpacing = 10*autoSizeScaleX;
    // 每一列cell之间的间距
     flowLayout.minimumInteritemSpacing = 8*autoSizeScaleX;
    // 设置第一个cell和最后一个cell,与父控件之间的间距
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 12*autoSizeScaleX, 0, 12*autoSizeScaleX);
//    collectionArray.count
    self.collectionView = [[UICollectionView alloc] initWithFrame:frmae collectionViewLayout:flowLayout];
//    self.collectionView.frame=frmae;
//    self.collectionView.collectionViewLayout=flowLayout;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    //    NSLog(@"self.ListCollectionView= %@",self.ListCollectionView);
    //水平滚动条隐藏
    self.collectionView.showsHorizontalScrollIndicator = NO;
    //    self.topCollection.allowsMultipleSelection = NO;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionHXViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:CollectionViewCellID];
    [self addSubview:self.collectionView];
}


#pragma mark  设置CollectionView的组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _collectionArray.count;
}

#pragma mark  设置CollectionView每组所包含的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return ((NSArray*)_collectionArray[section]).count;
    
}

#pragma mark  设置CollectionCell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionHXViewCell* cell_coll =  [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellID forIndexPath:indexPath];
    if (!cell_coll ) {
        NSLog(@"cell为空,创建cell");
        cell_coll = [[CollectionHXViewCell alloc] init];
        
    }
//    NSLog(@"%@",self.Imagearray[indexPath.row]);
    NSArray * array= self.collectionArray[indexPath.section];
    cell_coll.titleDown.text=array[indexPath.row];
    [cell_coll.imageBtn setImage:[UIImage imageNamed:self.Imagearray[indexPath.row]] forState:(UIControlStateNormal)];
    cell_coll.tag=indexPath.row;
    return cell_coll;
}

#pragma mark 设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80,80);
}

#pragma mark  设置CollectionViewCell是否可以被点击
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}




#pragma mark  点击CollectionView触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionHXViewCell * cell = (CollectionHXViewCell *)[collectionView cellForItemAtIndexPath:indexPath]; //即为要得到的cell
    if ([self.delegate respondsToSelector:@selector(CellTouch:)]) {
        [self.delegate CellTouch:cell];
    }
}


@end
