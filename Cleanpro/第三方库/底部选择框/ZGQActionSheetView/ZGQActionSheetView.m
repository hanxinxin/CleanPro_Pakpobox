//
//  ZGQActionSheetView.m
//  BBLive
//
//  Created by 小丁 on 2017/7/5.
//  Copyright © 2017年 车互帮. All rights reserved.
//

#import "ZGQActionSheetView.h"
#import "ZGQTableViewCell.h"

#define ZGQ_SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define ZGQ_SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define ZGQ_BACKGROUND_COLOR [UIColor colorWithWhite:0.001 alpha:0.6]
#define ZGQ_OPTION_COLOR [UIColor colorWithWhite:0.2 alpha:1.000]

static NSString *const sheetViewCell = @"ZGQSheetViewCell";

typedef void(^selectBlock)(NSInteger index);
typedef void(^cancelBlock)(void);

@interface ZGQActionSheetView ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>

//半透明背景图
@property (nonatomic, strong) UIView *sheetBackView;
//选项列表和取消按钮父视图
@property (nonatomic, strong) UIView *sheetView;
//选项列表
@property (nonatomic, strong) UITableView *sheetTableView;
//示例图片父视图
@property (nonatomic, strong) UIView *sampleBackView;
//示例图片
@property (nonatomic, strong) UIImageView *sampleImageView;
//示例图片说明标题
@property (nonatomic, strong) UILabel *sampleLabel;
//取消按钮
@property (nonatomic, strong) UIButton *sheetCancelBtn;
//父视图高度
@property (nonatomic, assign) CGFloat sheetViewHeight;
//选中回调
@property (nonatomic, copy) selectBlock selectBlock;
//取消回调
@property (nonatomic, copy) cancelBlock cancelBlock;


@end

@implementation ZGQActionSheetView


- (instancetype)initWithOptions:(NSArray<NSString *>*)options
{
    self = [super init];
    if (self) {
        [self initializeInformation];
        self.options = [NSArray arrayWithArray:options];
    }
    
    return self;
}

- (instancetype)initWithOptions:(NSArray<NSString *> *)options completion:(void (^)(NSInteger))completion cancel:(void (^)(void))cancelBlock {
    self = [super init];
    if (self) {
        [self initializeInformation];
        self.options = [NSArray arrayWithArray:options];
        self.selectBlock = completion;
        self.cancelBlock = cancelBlock;
    }
    
    return self;
}

- (void)initializeInformation
{
    self.maxShowCount = 5;
    self.fontSize = 16.0f;
    self.optionHeight = 56.0f;
    self.optionColor = [UIColor colorWithWhite:0.2 alpha:1.000];
    self.gap = 5.0f;
    self.needCancelButton = YES;
    self.cancelTitle = @"Cancel";

}


- (void)show
{
    if (self.options.count < 1) {
        NSLog(@"###### ZGQActrionSheetViewError");
        return;
    }

    self.sheetBackView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.sheetBackView.backgroundColor = ZGQ_BACKGROUND_COLOR;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [[UIApplication sharedApplication].keyWindow addSubview:self.sheetBackView];
    
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sheetCancelAction)];
    backTap.delegate = self;
    [self.sheetBackView addGestureRecognizer:backTap];
    
    self.sheetView = [[UIView alloc]init];
    self.sheetView.backgroundColor = [UIColor colorWithWhite:0.875 alpha:1.000];
    [self.sheetBackView addSubview:self.sheetView];
    
    NSInteger optionCount = self.options.count;
    NSInteger showCount = optionCount < self.maxShowCount ? optionCount : self.maxShowCount;
    NSInteger isHaveCancelBtn = self.needCancelButton ? 1 : 0;
    
    self.sheetViewHeight = self.optionHeight * (showCount + isHaveCancelBtn) + (self.gap * isHaveCancelBtn);
    
    if (self.showSampleView) {
        self.sampleBackView = [[UIView alloc] init];
        self.sampleBackView.frame = CGRectMake(0, 0, ZGQ_SCREEN_WIDTH, 190);
        self.sampleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.sampleImageFileName]];
        self.sampleImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.sampleBackView addSubview:self.sampleImageView];
        self.sampleImageView.frame = CGRectMake(30, 30, ZGQ_SCREEN_WIDTH - 60, 100);
        self.sampleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 160, ZGQ_SCREEN_WIDTH - 60, 24)];
        [self.sampleBackView addSubview:self.sampleLabel];
        self.sampleLabel.text = self.sampleTitleName;
        self.sampleLabel.textColor = [UIColor redColor];
        self.sampleLabel.font = [UIFont systemFontOfSize:12];
        self.sampleLabel.textAlignment = NSTextAlignmentCenter;
        
        self.sheetViewHeight = self.sheetViewHeight + 190;
    }

    self.sheetView.frame = CGRectMake(0, ZGQ_SCREEN_HEIGHT, ZGQ_SCREEN_WIDTH, self.sheetViewHeight);
    
    self.sheetTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ZGQ_SCREEN_WIDTH, self.optionHeight * showCount)];
    self.sheetTableView.backgroundColor = [UIColor whiteColor];
    [self.sheetView addSubview:self.sheetTableView];
    self.sheetTableView.showsVerticalScrollIndicator = NO;
    self.sheetTableView.bounces = NO;
    self.sheetTableView.separatorStyle = NO;
    self.sheetTableView.rowHeight = self.optionHeight;
    self.sheetTableView.delegate = self;
    self.sheetTableView.dataSource = self;
    [self.sheetTableView registerClass:[ZGQTableViewCell class] forCellReuseIdentifier:sheetViewCell];
    
    if (self.showSampleView) {
        self.sheetTableView.tableHeaderView = self.sampleBackView;
    }
    
    if (self.needCancelButton) {
        self.sheetCancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.sheetCancelBtn.frame = CGRectMake(0, CGRectGetMaxY(self.sheetView.bounds) - self.optionHeight, CGRectGetWidth(self.sheetView.bounds), self.optionHeight);
        self.sheetCancelBtn.backgroundColor = [UIColor whiteColor];
        [self.sheetCancelBtn setTitle:self.cancelTitle forState:UIControlStateNormal];
        self.sheetCancelBtn.titleLabel.font = [UIFont systemFontOfSize:self.fontSize];
        [self.sheetCancelBtn setTitleColor:ZGQ_OPTION_COLOR forState:UIControlStateNormal];
        [self.sheetCancelBtn addTarget:self action:@selector(sheetCancelAction) forControlEvents:UIControlEventTouchUpInside];
        [self.sheetView addSubview:self.sheetCancelBtn];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.sheetView.frame = CGRectMake(0, ZGQ_SCREEN_HEIGHT - self.sheetViewHeight, ZGQ_SCREEN_WIDTH, self.sheetViewHeight);
        
    }];


}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.options.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZGQTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sheetViewCell];
    cell.titleLabel.text = self.options[indexPath.row];
    cell.titleLabel.textColor = ZGQ_OPTION_COLOR;
    cell.titleLabel.font = [UIFont systemFontOfSize:self.fontSize];
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectBlock) {
        self.selectBlock(indexPath.row);
    }
    
    
    if ([self.delegate respondsToSelector:@selector(ZGQActionSheetView:didSelectRowAtIndex:text:)]) {
        [self.delegate ZGQActionSheetView:self didSelectRowAtIndex:indexPath.row text:self.options[indexPath.row]];
    }
    
    
    [UIView animateWithDuration:0.3 animations:^{
        self.sheetBackView.alpha = 0;
        self.sheetView.frame = CGRectMake(0, ZGQ_SCREEN_HEIGHT, ZGQ_SCREEN_WIDTH, self.sheetViewHeight);
    } completion:^(BOOL finished) {
        [self.sheetBackView removeFromSuperview];
        [self removeFromSuperview];
    }];
}


- (void)sheetCancelAction
{
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    if ([self.delegate respondsToSelector:@selector(ZGQActionSheetViewdidCancelSelectFrom:)]) {
        [self.delegate ZGQActionSheetViewdidCancelSelectFrom:self];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.sheetBackView.alpha = 0;
        self.sheetView.frame = CGRectMake(0, ZGQ_SCREEN_HEIGHT, ZGQ_SCREEN_WIDTH, self.sheetViewHeight);
    } completion:^(BOOL finished) {
        [self.sheetBackView removeFromSuperview];
        [self removeFromSuperview];
    }];
    
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch
{
    if([NSStringFromClass([touch.view class])isEqual:@"UITableViewCellContentView"]){
        return NO;
    }
    return YES;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
