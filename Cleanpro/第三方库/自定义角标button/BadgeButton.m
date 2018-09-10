//
//  BadgeButton.m
//  StorHub
//
//  Created by mac on 2018/4/25.
//  Copyright © 2018年 Pakpobox. All rights reserved.
//

#import "BadgeButton.h"

@interface BadgeButton()

@property (nonatomic, strong) UILabel *badgeLab;

@end


@implementation BadgeButton

-(instancetype)init{
    self = [super init];
    if (self) {
        _badgeLab = [[UILabel alloc] init];
        _badgeLab.backgroundColor = SPColor(251, 85, 85, 1);
        _badgeLab.font = [UIFont systemFontOfSize:10];
        _badgeLab.textColor = [UIColor whiteColor];
        _badgeLab.clipsToBounds = YES;
        _badgeLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_badgeLab];
        //        [self bringSubviewToFront:_badgeLab];
    }
    return self;
}
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self setSubFrame];
}

-(void)setIsRedBall:(BOOL)isRedBall{
    _isRedBall = isRedBall;
    [self setSubFrame];
}

-(void)setSubFrame{
    
    CGFloat badgeH;
    CGFloat badgeW;
    
    [self showText];
    
    if (_isRedBall) {
        badgeH = 8;
        badgeW = 8;
    }else{
        badgeH = 15;
        badgeW = [_badgeLab sizeThatFits:CGSizeMake(MAXFLOAT, badgeH)].width + 5;
        if (badgeW > 40) {
            badgeW = 40;
        }
        if (badgeW < badgeH) {
            badgeW = badgeH;
        }
        
        
    }
    
    
    _badgeLab.frame = CGRectMake(0, 0, badgeW, badgeH);
    _badgeLab.layer.cornerRadius = badgeH / 2;
    
    if (self.imageView.image) {
        CGPoint center = CGPointMake(CGRectGetMaxX(self.imageView.frame), self.imageView.frame.origin.y);
        _badgeLab.center = center;
    }else{
        CGPoint center = CGPointMake(self.bounds.size.width, self.bounds.origin.y);
        _badgeLab.center = center;
    }
    
}

-(void)setBadgeValue:(NSInteger)badgeValue{
    _badgeValue = badgeValue;
    [self setSubFrame];
}

-(void)showText{
    if (_badgeValue <= 0) {
        _badgeLab.hidden = YES;
    }else
        _badgeLab.hidden = NO;
    
    if (_isRedBall) {
        _badgeLab.text = @"";
    } else{
        if (_badgeValue > 99) {
            _badgeLab.text = @"99+";
        }else
            _badgeLab.text = [NSString stringWithFormat:@"%ld",(long)_badgeValue];
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
