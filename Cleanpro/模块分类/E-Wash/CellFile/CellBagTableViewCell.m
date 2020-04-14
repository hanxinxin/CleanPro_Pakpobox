//
//  CellBagTableViewCell.m
//  Cleanpro
//
//  Created by mac on 2020/3/26.
//  Copyright © 2020 mac. All rights reserved.
//

#import "CellBagTableViewCell.h"
#import "VPKCUIViewExt.h"
#import "LMJDropdownMenu.h"
@interface CellBagTableViewCell ()<LMJDropdownMenuDelegate>
{
    // 控件的创建
    LMJDropdownMenu * dropdownMenu;
}

@end

@implementation CellBagTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _ColdBtn.layer.cornerRadius=_ColdBtn.height/2;
    _ColdBtn.layer.borderWidth=1;
    _ColdBtn.layer.borderColor  = rgba(87, 203, 244, 1.0).CGColor;
    [_ColdBtn setTitleColor:rgba(87, 203, 244, 1.0) forState:(UIControlStateNormal)];
    _WarmBtn.layer.cornerRadius=_WarmBtn.height/2;
    _WarmBtn.layer.borderWidth=1;
    _WarmBtn.layer.borderColor  = rgba(158, 174, 183, 1.0).CGColor;
    [_WarmBtn setTitleColor:rgba(158, 174, 183, 1.0) forState:(UIControlStateNormal)];
    _hotBtn.layer.cornerRadius=_hotBtn.height/2;
    _hotBtn.layer.borderWidth=1;
    _hotBtn.layer.borderColor  = rgba(158, 174, 183, 1.0).CGColor;
    [_hotBtn setTitleColor:rgba(158, 174, 183, 1.0) forState:(UIControlStateNormal)];
//    self.SelectTemperature=3;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self set_select];
        
    });
    
    dispatch_time_t delayTime1 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01/*延迟执行时间*/ * NSEC_PER_SEC));

    dispatch_after(delayTime1, dispatch_get_main_queue(), ^{
       if(self.styleLeft==1)
        {
            self.RMBAyout.constant=(self.DeleteBtn.width+16);
            self.DeleteBtn.hidden=NO;
//        [self setleftFrame];
        }
    });
    
}

-(void)setleftFrame
{
//    dispatch_time_t delayTime1 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05/*延迟执行时间*/ * NSEC_PER_SEC));
//
//    dispatch_after(delayTime1, dispatch_get_main_queue(), ^{

            self.RMBLabel.frame=CGRectMake(self.DeleteBtn.left-70, self.DeleteBtn.top, 70, 21);
            self.PriceLabel.frame=CGRectMake(self.RMBLabel.left-56, self.DeleteBtn.top, 56, 21);
    self.DeleteBtn.hidden=NO;
    
//    self.RMBAyout.constant=(self.RMBAyout.constant+(self.DeleteBtn.width+16));
        
//    });
    
}

- (IBAction)Hot_Touch:(id)sender {
    self.SelectTemperature=3;
    if ([self.delegate respondsToSelector:@selector(SelectTouch:index:)]) {
        [self.delegate SelectTouch:self index:self.SelectTemperature];
    }
    
    [self setUI:self.ModeS.Mode];
    
    [self HotborderColor];
}

-(void)HotborderColor
{
    _ColdBtn.layer.borderColor  = rgba(158, 174, 183, 1.0).CGColor;
    [_ColdBtn setTitleColor:rgba(158, 174, 183, 1.0) forState:(UIControlStateNormal)];
    _WarmBtn.layer.borderColor  = rgba(158, 174, 183, 1.0).CGColor;
    [_WarmBtn setTitleColor:rgba(158, 174, 183, 1.0) forState:(UIControlStateNormal)];
    _hotBtn.layer.borderColor  = rgba(87, 203, 244, 1.0).CGColor;
    [_hotBtn setTitleColor:rgba(87, 203, 244, 1.0) forState:(UIControlStateNormal)];
}
- (IBAction)Warm_touch:(id)sender {
    self.SelectTemperature=2;
    if ([self.delegate respondsToSelector:@selector(SelectTouch:index:)]) {
        [self.delegate SelectTouch:self index:self.SelectTemperature];
    }
    
    [self setUI:self.ModeS.Mode];
    [self WarmborderColor];
}
-(void)WarmborderColor
{
    _ColdBtn.layer.borderColor  = rgba(158, 174, 183, 1.0).CGColor;
    [_ColdBtn setTitleColor:rgba(158, 174, 183, 1.0) forState:(UIControlStateNormal)];
    _WarmBtn.layer.borderColor  = rgba(87, 203, 244, 1.0).CGColor;
    [_WarmBtn setTitleColor:rgba(87, 203, 244, 1.0) forState:(UIControlStateNormal)];
    _hotBtn.layer.borderColor  = rgba(158, 174, 183, 1.0).CGColor;
    [_hotBtn setTitleColor:rgba(158, 174, 183, 1.0) forState:(UIControlStateNormal)];
}
- (IBAction)Cold_touch:(id)sender {
    self.SelectTemperature=1;
    if ([self.delegate respondsToSelector:@selector(SelectTouch:index:)]) {
        [self.delegate SelectTouch:self index:self.SelectTemperature];
    }
    
    [self setUI:self.ModeS.Mode];
    [self ColdborderColor];
}
-(void)ColdborderColor
{
    _ColdBtn.layer.borderColor  = rgba(87, 203, 244, 1.0).CGColor;
    [_ColdBtn setTitleColor:rgba(87, 203, 244, 1.0) forState:(UIControlStateNormal)];
    _WarmBtn.layer.borderColor  = rgba(158, 174, 183, 1.0).CGColor;
    [_WarmBtn setTitleColor:rgba(158, 174, 183, 1.0) forState:(UIControlStateNormal)];
    _hotBtn.layer.borderColor  = rgba(158, 174, 183, 1.0).CGColor;
    [_hotBtn setTitleColor:rgba(158, 174, 183, 1.0) forState:(UIControlStateNormal)];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)DeleteTouch:(id)sender {
    if ([self.delegate respondsToSelector:@selector(DeleteTouch:index:)]) {
        [self.delegate DeleteTouch:self index:self.tag];
    }
}

-(void)setUI:(productsMode*)mode
{
//    [self.];
//    NSArray * arr = mode.attributeList;
    for (int i = 0; i<mode.attributeList.count; i++) {
        attributeListsMode * attmode= mode.attributeList[i];
        for (int j=0; j<attmode.valueList.count; j++) {
            valueListMode * modeValue =attmode.valueList[j];
            NSString * productAttributeValueIdStr = modeValue.productAttributeValueId;
            if([modeValue.productAttributeValue isEqualToString:@"Cold"])
            {
                [_ColdBtn setTitle:modeValue.productAttributeValue forState:(UIControlStateNormal)];
                for (int k=0; k<mode.productVariantList.count; k++) {
                    productVariantListMode * modePro = mode.productVariantList[k];
                    for (int M=0; M<modePro.productAttributeValueIds.count; M++) {
                        NSString * ValueId= modePro.productAttributeValueIds[M];
                        if([ValueId isEqualToString:productAttributeValueIdStr])
                        {
                            if(self.SelectTemperature==1)
                            {
                                [self.RMBLabel setText:[NSString stringWithFormat:@"RM:%.2f",[modePro.priceValue floatValue]]];
                                [self ColdborderColor];
                            }
                        }
                    }
                    
                }
            }else if([modeValue.productAttributeValue isEqualToString:@"Warm"])
            {
                [_WarmBtn setTitle:modeValue.productAttributeValue forState:(UIControlStateNormal)];
                for (int k=0; k<mode.productVariantList.count; k++) {
                    productVariantListMode * modePro = mode.productVariantList[k];
                    for (int M=0; M<modePro.productAttributeValueIds.count; M++) {
                        NSString * ValueId= modePro.productAttributeValueIds[M];
                        if([ValueId isEqualToString:productAttributeValueIdStr])
                        {
                            if(self.SelectTemperature==2)
                            {
                                [self.RMBLabel setText:[NSString stringWithFormat:@"RM:%.2f",[modePro.priceValue floatValue]]];
                                [self WarmborderColor];
                            }
                        }
                    }
                    
                }
            }else if([modeValue.productAttributeValue isEqualToString:@"Hot"])
            {
                [_hotBtn setTitle:modeValue.productAttributeValue forState:(UIControlStateNormal)];
                for (int k=0; k<mode.productVariantList.count; k++) {
                    productVariantListMode * modePro = mode.productVariantList[k];
                    for (int M=0; M<modePro.productAttributeValueIds.count; M++) {
                        NSString * ValueId= modePro.productAttributeValueIds[M];
                        if([ValueId isEqualToString:productAttributeValueIdStr])
                        {
                            if(self.SelectTemperature==3)
                            {
                                [self.RMBLabel setText:[NSString stringWithFormat:@"RM:%.2f",[modePro.priceValue floatValue]]];
                                [self HotborderColor];
                            }
                        }
                    }
                    
                }
            }
        }
        
    }
    
    if(self.styleLeft==1)
    {
    [self setleftFrame];
    }
}



-(void)set_select
{
//    self.DQNumber=@[@"5 Poubd",@"10 Poubd"];
//    self.DQNumber=@[@"+60"];
    NSMutableArray * arr=[NSMutableArray arrayWithCapacity:0];
    
    for (int i=0; i<self.DQNumber.count; i++) {
        productsMode*mode=self.DQNumber[i];
        [arr addObject:mode.productName];
    }
    if(self.DQNumber.count==0)
    {
        [arr addObject:@"5 Poubd"];
        [arr addObject:@"10 Poubd"];
    }
    
     // 控件的创建
//     LMJDropdownMenu * dropdownMenu= [[LMJDropdownMenu alloc] init];
    if(dropdownMenu==nil)
    {
    dropdownMenu= [[LMJDropdownMenu alloc] init];
    dropdownMenu.Style=2;
    
    [dropdownMenu setFrame:self.PoubdBtn.frame];
        [dropdownMenu setMenuTitles:arr rowHeight:40 Selectindex:self.SelectMenuPound];
    [UIBezierPathView setCornerOnLeft:4 view_b:dropdownMenu.mainBtn];
    dropdownMenu.delegate = self;
    
    [self addSubview:dropdownMenu];
    }else
    {
        dropdownMenu.Style=2;
        [dropdownMenu setMenuTitles:arr rowHeight:40 Selectindex:self.SelectMenuPound];
    }
    
}

-(void)updateMenu:(NSInteger)index
{
    [dropdownMenu setmenuTitleText:index];
}

#pragma mark - LMJDropdownMenu Delegate

- (void)dropdownMenu:(LMJDropdownMenu *)menu selectedCellNumber:(NSInteger)number{
    NSLog(@"你选择了：%ld",(long)number);
    self.SelectMenuPound=number;
    if ([self.delegate respondsToSelector:@selector(SelectPoubd:index:SelectTemperature:)]) {
        [self.delegate SelectPoubd:self index:self.SelectMenuPound SelectTemperature:self.SelectTemperature];
    }
}

- (void)dropdownMenuWillShow:(LMJDropdownMenu *)menu{
    //    NSLog(@"--将要显示--");
}
- (void)dropdownMenuDidShow:(LMJDropdownMenu *)menu{
    //    NSLog(@"--已经显示--");
//    [self.verification_textfield setUserInteractionEnabled:NO];
}

- (void)dropdownMenuWillHidden:(LMJDropdownMenu *)menu{
    //    NSLog(@"--将要隐藏--");
}
- (void)dropdownMenuDidHidden:(LMJDropdownMenu *)menu{
    //    NSLog(@"--已经隐藏--");
//    [self.verification_textfield setUserInteractionEnabled:YES];
}
@end
