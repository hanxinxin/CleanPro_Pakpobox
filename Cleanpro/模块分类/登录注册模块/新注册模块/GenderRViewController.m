//
//  GenderRViewController.m
//  Cleanpro
//
//  Created by mac on 2019/1/9.
//  Copyright © 2019 mac. All rights reserved.
//

#import "GenderRViewController.h"
#import "PostcodeRViewController.h"

@interface GenderRViewController ()

@end

@implementation GenderRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.next_btn.layer.cornerRadius=4;
    self.Skip_btn.layer.cornerRadius=4;
    /// 默认选中 男
    [self RightSetImage];
    self.next_btn.backgroundColor=[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
    //添加手势
    UITapGestureRecognizer * tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(event_left:)];
    //选择触发事件的方式（默认单机触发）
    [tapGesture1 setNumberOfTapsRequired:1];
    [self.left_View addGestureRecognizer:tapGesture1];
    UITapGestureRecognizer * tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(event_right:)];
    //选择触发事件的方式（默认单机触发）
    [tapGesture2 setNumberOfTapsRequired:1];
    [self.right_View addGestureRecognizer:tapGesture2];
}



- (void)viewWillAppear:(BOOL)animated {
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
//    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]}; // title颜色
//    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];;
    
    [self.navigationController.navigationBar setHidden:NO];
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    //    [backBtn setImage:[UIImage imageNamed:@"icon_back_black"]];
    self.navigationItem.backBarButtonItem = backBtn;
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    //    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [super viewWillDisappear:animated];
}


-(void)event_left:(UITapGestureRecognizer*)tap
{
    [self LeftSetImage];
}
-(void)LeftSetImage
{
    self.sex_str=@"FEMALE";
    [self.LimageBtn setImage:[UIImage imageNamed:@"Female_on"] forState:UIControlStateNormal];
    [self.LSex_lebel setTextColor:[UIColor colorWithRed:41/255.0 green:209/255.0 blue:255/255.0 alpha:1.0]];
    [self.RimageBtn setImage:[UIImage imageNamed:@"Male_off"] forState:UIControlStateNormal];
    [self.RSex_label setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]];
}
-(void)event_right:(UITapGestureRecognizer*)tap
{
    [self RightSetImage];
}
-(void)RightSetImage
{
    self.sex_str=@"MALE";
    [self.LimageBtn setImage:[UIImage imageNamed:@"Female_off"] forState:UIControlStateNormal];
    [self.LSex_lebel setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]];
    [self.RimageBtn setImage:[UIImage imageNamed:@"Male_on"] forState:UIControlStateNormal];
    [self.RSex_label setTextColor:[UIColor colorWithRed:255/255.0 green:41/255.0 blue:121/255.0 alpha:1.0]];
    
}


- (IBAction)Next_touch:(id)sender {
    if(self.sex_str != nil && ![self.sex_str isEqualToString:@""] )
    {
        self.Nextmode.gender=self.sex_str;
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PostcodeRViewController *vc=[main instantiateViewControllerWithIdentifier:@"PostcodeRViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.Nextmode=self.Nextmode;
    vc.index=1;
    [self.navigationController pushViewController:vc animated:YES];
    }
}
- (IBAction)Skip_touch:(id)sender {
    self.Nextmode.gender=self.sex_str;
    UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PostcodeRViewController *vc=[main instantiateViewControllerWithIdentifier:@"PostcodeRViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.Nextmode=self.Nextmode;
    vc.index=1;
    [self.navigationController pushViewController:vc animated:YES];
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
