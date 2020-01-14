//
//  ShardHViewController.m
//  Cleanpro
//
//  Created by mac on 2019/11/6.
//  Copyright © 2019 mac. All rights reserved.
//

#import "ShardHViewController.h"

@interface ShardHViewController ()
@property (nonatomic,strong)UIImageView* imageScr;
@end

@implementation ShardHViewController
@synthesize imageScr;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self setImageViewFrame];
    });
    dispatch_time_t delayTime2 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime2, dispatch_get_main_queue(), ^{
        self.navigationController.navigationBar.translucent = YES;
        self.navigationController.navigationBar.subviews[0].alpha = 0.0;
    });
    [super viewWillAppear:animated];
}

-(void)setImageViewFrame
{
    imageScr = [[UIImageView alloc] init];
//    imageScr.image = [UIImage imageNamed:@"banner01-neiye.jpg"];
    imageScr.image = [UIImage imageNamed:@"ShareImage.jpeg"];
    NSDictionary * dict = self.modeA.picture;
    NSString * ImageID = [dict objectForKey:@"id"];
    NSLog(@"imageurl====  %@",[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",FuWuQiUrl,get_huoquPhoto,ImageID]]);
    [imageScr sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",FuWuQiUrl,get_huoquPhoto,ImageID]]];
//    self.imageScr.frame=CGRectMake(0, kNavBarAndStatusBarHeight, SCREEN_WIDTH,SCREEN_HEIGHT-(kNavBarAndStatusBarHeight));
    self.imageScr.frame=self.view.frame;
//    if(self.view.width==375.000000 && self.view.height>=812.000000)
//    {
//        self.imageScr.frame=CGRectMake(0, kNavBarAndStatusBarHeight, SCREEN_WIDTH,SCREEN_HEIGHT-84-10);
//    }else{
//        self.imageScr.frame=CGRectMake(0, kNavBarAndStatusBarHeight, SCREEN_WIDTH,SCREEN_HEIGHT-64);
//    }
    [self.view addSubview:imageScr];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
