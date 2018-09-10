//
//  ForgetSetPasswordViewController.m
//  Cleanpro
//
//  Created by mac on 2018/6/7.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ForgetSetPasswordViewController.h"
#import "HomeViewController.h"
#import "MyAccountViewController.h"

@interface ForgetSetPasswordViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate>
{
    
}

@end

@implementation ForgetSetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.Complete.layer.cornerRadius=25;
    self.setPassword_textField.keyboardType = UIKeyboardTypeASCIICapable;
    self.setPassword_textField.delegate=self;
    self.setPassword_textField.secureTextEntry=YES;
    self.Complete.backgroundColor=[UIColor colorWithRed:176/255.0 green:221/255.0 blue:231/255.0 alpha:1];
    [self.Complete setUserInteractionEnabled:NO];
    //    设置点击任何其他位置 键盘回收
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBG:)];
    tapGesture.delegate=self;
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
    
}
////点击别的区域收起键盘
- (void)tapBG:(UITapGestureRecognizer *)gesture {
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    //    [self.view endEditing:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    //    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1]];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}


- (IBAction)back_touch:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)Complete_touch:(id)sender {
    
    
    [HudViewFZ labelExample:self.view];
    NSDictionary * dict=@{@"token":self.TokenString,
                          @"password":self.setPassword_textField.text};
    //        NSLog(@"url=== %@",[NSString stringWithFormat:@"%@%@",FuWuQiUrl,P_sendVerifyCode]);
    [[AFNetWrokingAssistant shareAssistant] PostURL_Code:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,P_zhaohuiPasswordCZ] parameters:dict progress:^(id progress) {
        NSLog(@"请求成功 = %@",progress);
    }Success:^(NSInteger statusCode,id responseObject) {
        [HudViewFZ HiddenHud];
        if(statusCode==200)
        {
            for (UIViewController *temp in self.navigationController.viewControllers) {
                if ([temp isKindOfClass:[HomeViewController class]]) {
                    [self.navigationController popToViewController:temp animated:YES];
                    
                }
            }
            for (UIViewController *temp in self.navigationController.viewControllers) {
                if ([temp isKindOfClass:[MyAccountViewController class]]) {
                    [self.navigationController popToViewController:temp animated:YES];
                    ////            return NO;//这里要设为NO，不是会返回两次。返回到主界面。
                }
            }
        }else
        {
            [HudViewFZ showMessageTitle:@"statusCode error" andDelay:2.0];
        }
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error);
        [HudViewFZ showMessageTitle:@"Get error" andDelay:2.0];
        [HudViewFZ HiddenHud];
    }];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)GB_backgroundColor
{
    self.Complete.backgroundColor=[UIColor colorWithRed:176/255.0 green:221/255.0 blue:231/255.0 alpha:1];
    [self.Complete setUserInteractionEnabled:NO];
}
-(void)GB_backgroundColor_YES
{
    [self.Complete setUserInteractionEnabled:YES];
    self.Complete.backgroundColor=[UIColor colorWithRed:48/255.0 green:209/255.0 blue:250/255.0 alpha:1];
}

#define UITextFieldDelete  -------- - -------
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.setPassword_textField) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [self GB_backgroundColor];
            });
            return YES;
        }else if (self.setPassword_textField.text.length >=5)
        {
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [self GB_backgroundColor_YES];
            });
        }else if (self.setPassword_textField.text.length >= 15) {
            self.setPassword_textField.text = [[textField.text stringByAppendingString:string] substringToIndex:16];
            [self GB_backgroundColor_YES];
            return NO;
        }else{
            
        }
    }
    return YES;
}

@end
