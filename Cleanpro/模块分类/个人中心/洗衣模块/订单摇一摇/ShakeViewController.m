//
//  ShakeViewController.m
//  Cleanpro
//
//  Created by mac on 2019/3/12.
//  Copyright © 2019 mac. All rights reserved.
//

#import "ShakeViewController.h"
#import "LZAudioTool.h"
#import "UIView+LZ.h"


@interface ShakeViewController ()
@property (nonatomic, weak) UIImageView *bg;
@property (nonatomic, weak) UIImageView *up;
@property (nonatomic, weak) UIImageView *down;
@end

@implementation ShakeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *bg = [[UIImageView alloc] init];
    bg.image = [UIImage imageNamed:@"bg_shaking"];
    bg.frame = self.view.bounds;
    [self.view addSubview:bg];
    self.bg = bg;
    
    
    UIImageView *up = [[UIImageView alloc] init];
    up.image = [UIImage imageNamed:@"bg_yaoyao_above"];
    up.frame = CGRectMake(0, 0, self.view.width, self.view.height * 0.5);
    [bg addSubview:up];
    self.up = up;
    
    
    UIImageView *down = [[UIImageView alloc] init];
    down.image = [UIImage imageNamed:@"bg_yaoyao_under"];
    down.frame = CGRectMake(0, self.view.height * 0.5, self.view.width, self.view.height * 0.5);
    [bg addSubview:down];
    self.down = down;
    
    UIButton * Blackbtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-65, 25, 40, 40)];
    [Blackbtn setImage:[UIImage imageNamed:@"nav_close"] forState:(UIControlStateNormal)];
    [Blackbtn addTarget:self action:@selector(blackTouch:) forControlEvents:(UIControlEventTouchDown)];
    [self.view addSubview:Blackbtn];
    
}
-(void)blackTouch:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(BOOL)canBecomeFirstResponder
{
    return YES;
}


-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self becomeFirstResponder];
    
}


-(void)viewWillDisappear:(BOOL)animated {
    
    [self resignFirstResponder];
    
    [super viewWillDisappear:animated];
    
}

#pragma mark - 实现相应的响应者方法
/** 开始摇一摇 */
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"motionBegan");
    
    CGFloat offset = self.bg.height/2;
    CGFloat duration = 0.4;
    
    [UIView animateWithDuration:duration animations:^{
        self.up.y -= offset;
        self.down.y += offset;
    }];
    
    
    [LZAudioTool playMusic:@"dance.mp3"];
}

/** 摇一摇结束（需要在这里处理结束后的代码） */
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    // 不是摇一摇运动事件
    if (motion != UIEventSubtypeMotionShake) return;
    
    NSLog(@"motionEnded");
    CGFloat offset = self.bg.height / 2;
    CGFloat duration = 0.4;
    [UIView animateWithDuration:duration animations:^{
        self.up.y += offset;
        self.down.y -= offset;
    }];
    
}

/** 摇一摇取消（被中断，比如突然来电） */
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"motionCancelled");
}

@end
