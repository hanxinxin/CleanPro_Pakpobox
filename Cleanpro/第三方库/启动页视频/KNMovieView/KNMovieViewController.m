//
//  KNMovieViewController.m
//  KNStartMovie
//
//  Created by 刘凡 on 2017/10/9.
//  Copyright © 2017年 KrystalName. All rights reserved.
//

#import "KNMovieViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>



@interface KNMovieViewController ()


//播放器ViewController
@property(nonatomic, strong)AVPlayerViewController *AVPlayer;
@property(nonatomic, strong)UIButton *top_leftButton;
@property(nonatomic, strong)UILabel *centerLabel;
@property(nonatomic, strong)SMDelayedBlockHandle delayedBlockHandle;
@end

@implementation KNMovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    if(self.movieURL==nil)
    {
            NSString *path =  [[NSBundle mainBundle] pathForResource:@"LaundryHome.mp4" ofType:nil];
            self.movieURL = [NSURL fileURLWithPath:path];
    }
    //初始化AVPlayer
    [self setMoviePlayer];
    [self Top_leftButton_add];
    [self centerLabel_add];
}
-(void)Top_leftButton_add
{
    self.top_leftButton=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-108-18, 22, 108, 37)];
    [self.top_leftButton setImage:[UIImage imageNamed:@"title_image"] forState:UIControlStateNormal];
    [self.view addSubview:self.top_leftButton];
}

-(void)centerLabel_add
{
    self.centerLabel=[[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-260)/2,(SCREEN_HEIGHT-76)/2, 260, 76)];
    self.centerLabel.numberOfLines=0;
//    [self.centerLabel setText:@"Easy Clening \nEasy Life"];
//    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"Easy Clening\nEasy Life" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"SF Pro Text" size: 30], NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0], NSShadowAttributeName: shadow}];
    // 富文本用法3 - 图文混排
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
    // 第一段：placeholder
    NSMutableAttributedString * SubStr1=[[NSMutableAttributedString alloc] init];
    NSAttributedString *substring1 = [[NSAttributedString alloc] initWithString:@"Your Ideal Laundry Partner"];
    
    //    NSLog(@"%@",substring1.string);
    [SubStr1 appendAttributedString:substring1];
    NSRange rang =[SubStr1.string rangeOfString:SubStr1.string];
    //设置文字颜色
    [SubStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:rang];
    //设置文字大小
    [SubStr1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30.f] range:rang];
    [string appendAttributedString:SubStr1];
    self.centerLabel.attributedText = string;
    self.centerLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.centerLabel.textAlignment=NSTextAlignmentCenter;
    self.centerLabel.alpha = 1.0;
    [self.view addSubview:self.centerLabel];
}
-(void)setMoviePlayer{
    
    //初始化AVPlayer
    self.AVPlayer = [[AVPlayerViewController alloc]init];
    //多分屏功能取消
//    if (@available(iOS 9.0, *)) {
//        self.AVPlayer.allowsPictureInPicturePlayback = NO;
//    } else {
//        // Fallback on earlier versions
//        self.AVPlayer.allowsPictureInPicturePlayback = NO;
//    }
    //设置是否显示媒体播放组件
    self.AVPlayer.showsPlaybackControls = false;
    
    //初始化一个播放单位。给AVplayer 使用
    AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:_movieURL];
    
    AVPlayer *player = [AVPlayer playerWithPlayerItem:item];
    player.volume = 0;
    //layer
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:player];
    [layer setFrame:[UIScreen mainScreen].bounds];
    //设置填充模式
    layer.videoGravity = AVLayerVideoGravityResize;
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
       [session setCategory:AVAudioSessionCategoryAmbient
              withOptions:AVAudioSessionCategoryOptionAllowBluetooth
                      error:nil];
    //设置AVPlayerViewController内部的AVPlayer为刚创建的AVPlayer
    self.AVPlayer.player = player;
    //添加到self.view上面去
    [self.view.layer addSublayer:layer];
    //开始播放
    [self.AVPlayer.player play];
    
    
    
    //这里设置的是重复播放。
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playDidEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:item];
    

    //定时器。延迟3秒再出现进入应用按钮
//    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(setupLoginView) userInfo:nil repeats:YES];
    [self setupLoginView];
    //定时器。延迟3秒再出现进入应用按钮
//    [NSTimer scheduledTimerWithTimeInterval:9.0 target:self selector:@selector(enterMainAction:) userInfo:nil repeats:YES];
//    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(9.0/*延迟执行时间*/ * NSEC_PER_SEC));
//    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//        NSLog(@"执行进入home页面");
//
//    });
    //我们使用perform_block_after_delay方法进行延迟处理，_delayedBlockHandle负责控制取消延迟的操作
//    __block SMDelayedBlockHandle blockHandle = _delayedBlockHandle;
    _delayedBlockHandle = perform_block_after_delay(9.0f, ^{
        [self enterMainAction:nil];
    });
    
//    //我们使用这个方法就可以取消perform_block_after_delay放发回调
//    _delayedBlockHandle(YES);
    
}


//播放完成的代理
- (void)playDidEnd:(NSNotification *)Notification{
    //播放完成后。设置播放进度为0 。 重新播放
    [self.AVPlayer.player seekToTime:CMTimeMake(0, 1)];
    //开始播放
    [self.AVPlayer.player play];
}



- (void)setupLoginView
{
    //进入按钮
    UIButton *enterMainButton = [[UIButton alloc] init];
    enterMainButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-80, [UIScreen mainScreen].bounds.size.height - 60, 60, 30);
    enterMainButton.layer.borderWidth = 1;
    enterMainButton.layer.cornerRadius = 4;
    enterMainButton.alpha = 1;
    enterMainButton.layer.borderColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.5].CGColor;
//    enterMainButton.l
//    [enterMainButton setTitle:@"进入应用" forState:UIControlStateNormal];
    [enterMainButton setTitle:@"Skip" forState:UIControlStateNormal];
    [enterMainButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [enterMainButton setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.5] forState:UIControlStateNormal];
    [self.view addSubview:enterMainButton];
    [enterMainButton addTarget:self action:@selector(enterMainAction:) forControlEvents:UIControlEventTouchDown];

    [UIView animateWithDuration:0.5 animations:^{
        enterMainButton.alpha = 1;
    }];
}



- (void)enterMainAction:(UIButton *)btn {
    
    //我们使用这个方法就可以取消perform_block_after_delay放发回调
    _delayedBlockHandle(YES);
    [self.AVPlayer.player pause];
//    self.VC  = [[BarViewController alloc]init];
//    self.view.window.rootViewController = self.VC;
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.VC=[main instantiateViewControllerWithIdentifier:@"BarViewController"];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:self.VC animated:YES];
//    self.view.window.rootViewController = self.VC;
    self.navigationController.view.window.rootViewController=self.VC;
}
@end
