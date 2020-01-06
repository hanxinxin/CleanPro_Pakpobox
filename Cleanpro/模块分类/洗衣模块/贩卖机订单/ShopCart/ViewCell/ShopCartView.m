//
//  ShopCartView.m
//  ZXShopCart
//
//  Created by Xiang on 16/1/27.
//  Copyright © 2016年 周想. All rights reserved.
//

#import "ShopCartView.h"

#define kScreenBounds [[UIScreen mainScreen] bounds]
#define kWindowWidth  ([[UIScreen mainScreen] bounds].size.width)
#define kWindowHeight ([[UIScreen mainScreen] bounds].size.height)

@implementation ShopCartView

- (instancetype) initWithFrame:(CGRect)frame inView:(UIView *)parentView {
    self = [super initWithFrame:frame];
    if (self) {
        self.parentView = parentView;
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI {
    
    self.backgroundColor = [UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
    
    
    self.line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 0.5)];
    self.line.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.line.layer.borderWidth = 0.25;
    [self addSubview:self.line];
    
    //购物金额提示框
//    self.totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, self.bounds.size.width, 30)];//以前是70 暂时修改为20
    self.totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.bounds.size.width, self.frame.size.height)];
//    self.totalPriceLabel.backgroundColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
    [self.totalPriceLabel setTextColor:[UIColor whiteColor]];
//    [self.totalPriceLabel setText:@"Please select goods"];
    [self setprice_labelText:@"Please select goods" LabelText:self.totalPriceLabel];
    [self.totalPriceLabel setFont:[UIFont systemFontOfSize:18.0]];
    [self addSubview:self.totalPriceLabel];
    
    //结算按钮
    self.payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.payButton.frame = CGRectMake(self.bounds.size.width - 100, 0, 100,self.frame.size.height);
    [self.payButton addTarget:self action:@selector(goToCheck) forControlEvents:UIControlEventTouchUpInside];
//    self.payButton.layer.cornerRadius = 5;
    self.payButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    self.payButton.backgroundColor = [UIColor lightGrayColor];
    [self.payButton setTitle:[NSString stringWithFormat:@"Select"] forState:UIControlStateNormal];
    //self.payButton.enabled = NO;
    if (_inTotal == 0) {
        self.payButton.enabled = NO;
    } else {
        self.payButton.enabled = YES;
    }
    
    [self addSubview:self.payButton];
    
    //购物车按钮
    self.shopCartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.shopCartBtn setBackgroundImage:[UIImage imageNamed:@"shoppingCart"] forState:UIControlStateNormal];
    self.shopCartBtn.frame = CGRectMake(10, -10, 50, 50);
//    [self.shopCartBtn addTarget:self action:@selector(shopCartClicked) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:self.shopCartBtn];
    
    // 详情列表
    float initHeight = 50.0;
    self.detailListView = [[OrderDetailListView alloc] initWithFrame:CGRectMake(0, self.parentView.bounds.size.height - initHeight - self.bounds.size.height, self.bounds.size.width, initHeight) withObjects:_detailListView.objects  canReorder:YES];
    
    // 背景视图
    self.popOutView = [[PopOutView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight - 50)];
    self.popOutView.shopCartView = self;
    [self.popOutView addSubview:self];
//    self.parentView.backgroundColor = [UIColor blackColor];
    [self.parentView addSubview:self.popOutView];
    self.popOutView.alpha = 0.0;
    
    // 购物车角标视图
    self.badgeView = [[BadgeView alloc] initWithFrame:CGRectMake(self.shopCartBtn.frame.size.width - 18, 5, 18, 18) withString:nil];
    [self.shopCartBtn addSubview:self.badgeView];
    self.badgeView.hidden = YES;    // 初始状态隐藏
    
    self.is_open = NO;
}

- (void)setBadgeValue:(NSInteger)badgeValue {
    
    _badgeValue = badgeValue;
    self.badgeView.textLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)badgeValue];
    if (badgeValue > 0) {
        self.badgeView.hidden = NO;
    } else {
        self.badgeView.hidden = YES;
    }
    
}

// 点击购物车图标
- (void)shopCartClicked {
    if (self.badgeView.hidden) {
        [self.shopCartBtn setUserInteractionEnabled:NO];
    } else {
        [self.shopCartBtn setUserInteractionEnabled:YES];
        [self updateFrame:self.detailListView];
        [self.popOutView addSubview:self.detailListView];
        
        [UIView animateWithDuration:0.5 animations:^{
            CGPoint point = self.shopCartBtn.center;
            CGPoint labelPoint = self.totalPriceLabel.center;
            
            point.y -= (self.detailListView.frame.size.height + 50);
            labelPoint.x -= 60;
            self.popOutView.alpha = 1.0;
            
            [self.shopCartBtn setCenter:point];
            [self.totalPriceLabel setCenter:labelPoint];
        } completion:^(BOOL finished) {
            
            self.is_open = YES;
        }];
    }
}

// 点击结算按钮
- (void)goToCheck {
    NSLog(@"共计:%ld份，%@ \n %@", (long)_badgeValue, _totalPriceLabel.text, _orderArray);

    // 通知代理（调用代理的方法）
    if ([self.delegate respondsToSelector:@selector(PayButtonTouch:button:)]) {
        [self.delegate PayButtonTouch:_orderArray button:0];
    }
}

- (void)setTotalPrice:(double)inTotal {
    self.inTotal = inTotal;
    //NSLog(@"self.inTotal = %0.2f" ,self.inTotal);

    if(self.inTotal > 0) {
        self.totalPriceLabel.font = [UIFont systemFontOfSize:18.0f];
        self.totalPriceLabel.textColor = [UIColor whiteColor];
//        self.totalPriceLabel.text = [NSString stringWithFormat:@"Total: %0.2f", self.inTotal];
        [self setprice_labelText:[NSString stringWithFormat:@"￥ %0.2f", self.inTotal] LabelText:self.totalPriceLabel];
        
        self.payButton.enabled = YES;
        [self.payButton setTitle:@"Pay" forState:UIControlStateNormal];
//        [self.payButton setBackgroundColor:[UIColor redColor]];
        [self.payButton setBackgroundColor:[UIColor colorWithRed:26/255.0 green:114/255.0 blue:229/255.0 alpha:1.0]];
        [self.shopCartBtn setUserInteractionEnabled:YES];
    } else {
        [self.totalPriceLabel setTextColor:[UIColor whiteColor]];
//        [self.totalPriceLabel setText:@"Please select goods"];
        [self setprice_labelText:@"Please select goods" LabelText:self.totalPriceLabel];
        [self.totalPriceLabel setFont:[UIFont systemFontOfSize:18.0]];
        
        self.payButton.enabled = NO;
        [self.payButton setTitle:[NSString stringWithFormat:@"Select"] forState:UIControlStateNormal];
        [self.payButton setBackgroundColor:[UIColor grayColor]];
        
        [self.shopCartBtn setUserInteractionEnabled:NO];
    }
}
-(void)setprice_labelText:(NSString *)str LabelText:(UILabel*)TextLabel
{
    NSString * stringZ= [NSString stringWithFormat:@"%@",str];
     NSString * string= [NSString stringWithFormat:@"%@",str];
    NSRange rang_3 = [stringZ rangeOfString:string];
    NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc]initWithString:string];
    //设置文字颜色
    [attributStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:rang_3];
    [attributStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,attributStr.length)];
    //设置文字大小
    [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.f] range:rang_3];
    [attributStr addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldMT" size:20] range:rang_3];
    //设置文字背景色
    [attributStr addAttribute:NSBackgroundColorAttributeName value:[UIColor clearColor] range:rang_3];
    //赋值
    TextLabel.attributedText = attributStr;
}

- (void)updateFrame:(UIView *)view {
    OrderDetailListView *orderListView = (OrderDetailListView *)view;
    if (orderListView.objects.count == 0) {
        [self dismissAnimated:YES];
        return;
    }
    float height = 0;
    height = [orderListView.objects count] * 50;
    int maxHeight = self.parentView.frame.size.height - 250;
    if (height >= maxHeight) {
        height = maxHeight;
    }
    //self.detailListView.frame.origin.y = maxHeight - height;
    float orignY = self.detailListView.frame.origin.y;
    
    self.detailListView.frame = CGRectMake(self.detailListView.frame.origin.x, self.parentView.bounds.size.height - height - 50, self.detailListView.frame.size.width, height);
    self.detailListView.listTableView.frame = self.detailListView.bounds;
    
    float currentY = self.detailListView.frame.origin.y;
    
    if (self.is_open) {
        [UIView animateWithDuration:0.5 animations:^{
            CGPoint point = self.shopCartBtn.center;
            point.y -= orignY - currentY;
            [self.shopCartBtn setCenter:point];
            
        } completion:^(BOOL finished) {
            
        }];
    }
}

// dismiss效果
-(void)dismissAnimated:(BOOL)animated {
    [self.shopCartBtn bringSubviewToFront:self.popOutView];
    [UIView animateWithDuration:0.5 animations:^{
        self.popOutView.alpha = 0.0;
        self.shopCartBtn.frame = CGRectMake(10, -10, 50,50);
        self.totalPriceLabel.frame = CGRectMake(70, 10, self.bounds.size.width, 30);
        
    } completion:^(BOOL finished) {
        self.is_open = NO;
    }];
}

@end
