//
//  VendingMachineView.m
//  Cleanpro
//
//  Created by mac on 2020/1/2.
//  Copyright © 2020 mac. All rights reserved.
//

#import "VendingMachineView.h"
#import "GoodsModel.h"
@interface VendingMachineView()

@property (strong, nonatomic)  UILabel * donwXian;

@end
@implementation VendingMachineView

- (instancetype) initWithFrame:(CGRect)frame inView:(UIView *)parentView listArray:(NSArray *)array {
    self = [super initWithFrame:frame];
    if (self) {
        self.ListArray= array;
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI {
    self.backgroundColor = [UIColor whiteColor];
    self.RetailMachineLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 1, self.width-16, 49)];
//    self.RetailMachineLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    self.RetailMachineLabel.layer.borderWidth = 0.25;
//    self.RetailMachineLabel.text=@"Retail Machine";
    [self setRetailMachineLabelText:@"Retail Machine"];
    [self addSubview:self.RetailMachineLabel];
    _CommodityView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    _CommodityView.frame = CGRectMake(0, self.RetailMachineLabel.bottom, self.width, self.ListArray.count*100);
    _CommodityView.bounces = NO;
    _CommodityView.showsHorizontalScrollIndicator = NO;
    _CommodityView.showsVerticalScrollIndicator = NO;
    _CommodityView.backgroundColor = [UIColor clearColor];
    //    [_listTableView registerNib:[UINib nibWithNibName:NSStringFromClass([DetailListCell class]) bundle:nil] forCellReuseIdentifier:@"DetailListCell"];
    [self addSubview:_CommodityView];
    self.donwXian = [[UILabel alloc] initWithFrame:CGRectMake(0, _CommodityView.bottom, self.width, 0.5)];
//    self.donwXian.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.donwXian.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0];
//    [self addSubview:self.donwXian];
    self.PriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, self.donwXian.bottom, self.width-16, 50)];
    self.PriceLabel.textColor=[UIColor colorWithRed:142/255.0 green:142/255.0 blue:142/255.0 alpha:1.0];
//    self.PriceLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    self.PriceLabel.layer.borderWidth = 0.25;
    [self setLableTextPriceLabel:@"0"];
    [self addSubview:self.PriceLabel];
}

-(void)setLableTextPriceLabel:(NSString *)str
{
    
    
    NSString * string1= [NSString stringWithFormat:@"%@",@"Price："];
    NSString * string2= [NSString stringWithFormat:@"%@",str];
    NSString * string= [NSString stringWithFormat:@"%@%@",string1,string2];
    NSRange rang_3 = [string rangeOfString:string2];
    NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc]initWithString:string];
    //设置文字颜色
    [attributStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rang_3];
    //设置文字大小
    [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.f] range:rang_3];
    [attributStr addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldMT" size:18] range:rang_3];
    //设置文字背景色
    [attributStr addAttribute:NSBackgroundColorAttributeName value:[UIColor clearColor] range:rang_3];
    
    NSRange rang_4 = [string rangeOfString:string1];
    //设置文字颜色
    [attributStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:142/255.0 green:142/255.0 blue:142/255.0 alpha:1.0] range:rang_4];
    //设置文字大小
    [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.f] range:rang_4];
    //设置文字背景色
    [attributStr addAttribute:NSBackgroundColorAttributeName value:[UIColor clearColor] range:rang_4];
//    [attributStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:142/255.0 green:142/255.0 blue:142/255.0 alpha:1.0] range:NSMakeRange(0,attributStr.length)];
    //赋值
    self.PriceLabel.attributedText = attributStr;
}

-(void)setRetailMachineLabelText:(NSString *)str
{
    NSString * string= [NSString stringWithFormat:@"%@",str];
    NSRange rang_3 = [string rangeOfString:string];
    NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc]initWithString:string];
    //设置文字颜色
    [attributStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,attributStr.length)];
    [attributStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rang_3];
    
    //设置文字大小
    [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.f] range:rang_3];
    [attributStr addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldMT" size:17] range:rang_3];
    //设置文字背景色
    [attributStr addAttribute:NSBackgroundColorAttributeName value:[UIColor clearColor] range:rang_3];
    //赋值
    self.RetailMachineLabel.attributedText = attributStr;
}



@end
