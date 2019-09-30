//
//  ViewOrder.m
//  Cleanpro
//
//  Created by mac on 2019/3/28.
//  Copyright © 2019 mac. All rights reserved.
//

#import "ViewOrder.h"

@implementation ViewOrder

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setLabelText_OrderNo:(NSString*)str
{
    self.OrderNo.text = [NSString stringWithFormat:@"%@: %@",FGGetStringWithKeyFromTable(@"Order No", @"Language"),str];
}
-(void)setLabelText_Location:(NSString*)str
{
    self.Location.text = [NSString stringWithFormat:@"%@: %@",FGGetStringWithKeyFromTable(@"Location", @"Language"),str];
}
-(void)setLabelText_MachineNo:(NSString*)str
{
//    self.MachineNo.text = [NSString stringWithFormat:@"Machine No: %@",str];
    // 富文本用法3 - 图文混排
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
    // 第二段：placeholder
    NSMutableAttributedString * SubStr1=[[NSMutableAttributedString alloc] init];
    NSAttributedString *substring1 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@: ",FGGetStringWithKeyFromTable(@"Machine No", @"Language")]];
    [SubStr1 appendAttributedString:substring1];
    NSRange rang =[SubStr1.string rangeOfString:SubStr1.string];
    //设置文字颜色
    [SubStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] range:rang];
    //设置文字大小
//    [SubStr1 addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldMT" size:18] range:rang];
    [SubStr1 addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:16] range:rang];
    [string appendAttributedString:SubStr1];
    // 第二段：placeholder
    NSMutableAttributedString * SubStr2=[[NSMutableAttributedString alloc] init];
    NSAttributedString *substring2 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",str]];
    [SubStr2 appendAttributedString:substring2];
    NSRange rang2 =[SubStr2.string rangeOfString:SubStr2.string];
    //设置文字颜色
    [SubStr2 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rang2];
    //设置文字大小
    [SubStr2 addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldMT" size:18] range:rang2];
    [string appendAttributedString:SubStr2];
    self.MachineNo.attributedText = string;
}


@end
