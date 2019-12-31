//
//  InformationViewController.m
//  Cleanpro
//
//  Created by mac on 2019/1/15.
//  Copyright © 2019 mac. All rights reserved.
//

#import "InformationViewController.h"
#import "ZGQActionSheetView.h"
#import "TZImagePickerController.h"
#import "nameRViewController.h"
#import "PostcodeRViewController.h"
#import "EmailStrViewController.h"
#import "HQImageEditViewController.h"
#import <AVFoundation/AVFoundation.h>

#define ZGQ_BACKGROUND_COLOR [UIColor colorWithWhite:0.001 alpha:0.6]

@interface InformationViewController ()<UITableViewDelegate,UITableViewDataSource,ZGQActionSheetViewDelegate,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate,HQImageEditViewControllerDelegate>
{
    UITapGestureRecognizer * tapSuperGesture22;
}
@property (nonatomic,strong)NSMutableArray * arrtitle;
@property (nonatomic,strong)SaveUserIDMode * ModeUser;
@property (nonatomic,strong)NSString * DateStr;
@end

@implementation InformationViewController
@synthesize arrtitle;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    arrtitle=[NSMutableArray arrayWithCapacity:0];
    [arrtitle addObject:[NSArray arrayWithObjects:FGGetStringWithKeyFromTable(@"Profile Picture", @"Language"),FGGetStringWithKeyFromTable(@"Name", @"Language"),FGGetStringWithKeyFromTable(@"Phone number", @"Language"),FGGetStringWithKeyFromTable(@"Gender", @"Language"),FGGetStringWithKeyFromTable(@"Birthday", @"Language"),FGGetStringWithKeyFromTable(@"Email", @"Language"), nil]];
    [arrtitle addObject:[NSArray arrayWithObjects:FGGetStringWithKeyFromTable(@"Address", @"Language"), nil]];
    
    
    self.view.backgroundColor=[UIColor colorWithRed:240/255.0 green:241/255.0 blue:242/255.0 alpha:1];;
    if (@available(iOS 11.0, *)) {//解决iOS 10 版本scrollView下滑问题。
        
        self.topTableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    } else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }
    [self.navigationController.navigationBar setTranslucent:NO];
    self.topTableview.hidden=YES;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{

        [self setTableView];
        
    });
}
- (void)viewWillAppear:(BOOL)animated {
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //    self.title=@"Cleapro";
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.title=FGGetStringWithKeyFromTable(@"Personal Infomation", @"Language");
//    [self.navigationController setNavigationBarHidden:NO animated:NO];//隐藏导航栏
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    NSData * data =[[NSUserDefaults standardUserDefaults] objectForKey:@"SaveUserMode"];
    self.ModeUser  = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    self.DateStr=self.ModeUser.birthday;
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//        [self getImage_touxiang];
//        [self.topTableview reloadData];
        [self.topTableview reloadData];
    });
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    backBtn.title = FGGetStringWithKeyFromTable(@"", @"Language");
    self.navigationItem.backBarButtonItem = backBtn;
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

-(void)setTableView
{
    NSLog(@"height = %f",self.navigationController.navigationBar.height);
    self.topTableview.hidden=NO;
    self.topTableview.frame=CGRectMake(0, 0, SCREEN_WIDTH, 7*60+8+10);
    self.topTableview.delegate=self;
    self.topTableview.dataSource=self;
//    [self.topTableview s]=UITableViewStylePlain;
    //     self.Set_tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //    self.Set_tableView.separatorInset=UIEdgeInsetsMake(0,10, 0, 10);           //top left bottom right 左右边距相同
    self.topTableview.scrollEnabled = NO;  ////设置tableview不上下滑动
    self.topTableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    //    self.Set_tableView.separatorColor = [UIColor blackColor];
    //    [self.view addSubview:self.Down_tableView];
    [self.view addSubview:self.topTableview];
    
//    self.imageView_down = [[UIImageView alloc] initWithFrame:CGRectMake(15, self.Down_tableView.bottom+8, SCREEN_WIDTH-15*2, 95)];
//    [self.imageView_down setImage:[UIImage imageNamed:@"promos_1"]];
//    [self.view addSubview:self.topTableview];
}

#pragma mark -------- Tableview -------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray * arr = arrtitle[section];
    return arr.count;
}
//4、设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return arrtitle.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
        
        //            cell.contentView.backgroundColor = [UIColor blueColor];
        
    }
    UIView *lbl = [[UIView alloc] init]; //定义一个label用于显示cell之间的分割线（未使用系统自带的分割线），也可以用view来画分割线
    lbl.frame = CGRectMake(cell.frame.origin.x + 10, 0, self.view.width-1, 1);
    lbl.backgroundColor =  [UIColor colorWithRed:240/255.0 green:241/255.0 blue:242/255.0 alpha:1];
    [cell.contentView addSubview:lbl];
    //cell选中效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray  * titleT=arrtitle[indexPath.section];
    cell.textLabel.text = [titleT objectAtIndex:indexPath.row];
    
    //    NSLog(@"%ld",(long)indexPath.row);
    if(indexPath.section==0)
    {
        if(indexPath.row==0)
        {
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05/*延迟执行时间*/ * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//                UIButton * imageView_btn = [[UIButton alloc] initWithFrame:CGRectMake(cell.width-80, 15, 40, 40)];
                UIImageView * imageView_btn = [[UIImageView alloc] initWithFrame:CGRectMake(cell.width-80, 15, 40, 40)];
//                [imageView_btn setBackgroundImage:[UIImage imageNamed:@"icon_Avatar"] forState:UIControlStateNormal];
//                [imageView_btn setBackgroundImage:[self getImage_touxiang]forState:UIControlStateNormal];
                if(self.ModeUser!=nil)
                {
                    if(self.ModeUser.headImageUrl!=nil)
                    {
                        [imageView_btn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",FuWuQiUrl,get_downImage,self.ModeUser.headImageUrl]] placeholderImage:[UIImage imageNamed:@"icon_Avatar"]];
                        
//                        return result;
                    }else
                    {
//                        return [UIImage imageNamed:@"icon_Avatar"];
//                       [imageView_btn setBackgroundImage:[UIImage imageNamed:@"icon_Avatar"] forState:UIControlStateNormal];
                        [imageView_btn setImage:[UIImage imageNamed:@"icon_Avatar"]];
                    }
                }else
                {
                    [imageView_btn setImage:[UIImage imageNamed:@"icon_Avatar"]];
                }
                [imageView_btn setUserInteractionEnabled:NO];
                UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:imageView_btn.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:imageView_btn.bounds.size];
                
                CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
                //设置大小
                maskLayer.frame = imageView_btn.bounds;
                //设置图形样子
                maskLayer.path = maskPath.CGPath;
                imageView_btn.layer.mask = maskLayer;
                [cell.contentView addSubview:imageView_btn];
            });
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
        }else if (indexPath.row==1)
        {
            cell.detailTextLabel.text=[NSString stringWithFormat:@"%@%@",self.ModeUser.firstName,self.ModeUser.lastName];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
        }
        else if (indexPath.row==2)
        {
            cell.detailTextLabel.text=self.ModeUser.phoneNumber;
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if(indexPath.row==3)
        {
            cell.detailTextLabel.text=self.ModeUser.gender;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
        }else if(indexPath.row==4)
        {
            cell.detailTextLabel.text=[self strDate:self.ModeUser.birthday];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
        }else if(indexPath.row==5)
        {
            cell.detailTextLabel.text=self.ModeUser.EmailStr;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
        }
    }else if (indexPath.section==1)
    {
//        if(indexPath.row==0)
//        {
//        cell.detailTextLabel.text=self.ModeUser.postCode;
//        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    }
    
    //    }
    cell.textLabel.textColor = [UIColor darkGrayColor];
    //    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //    cell.layer.cornerRadius=4;
    return cell;
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0 && indexPath.row==0)
    {
        return 70;
    }
    return 60;
}
//设置间隔高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==0)
    {
        return 0;
    }
    return 8.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return CGFLOAT_MIN;//最小数，相当于0
    }
    else if(section == 1){
        return CGFLOAT_MIN;//最小数，相当于0
    }
    return 0;//机器不可识别，然后自动返回默认高度
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //自定义间隔view，可以不写默认用系统的
    UIView * view_c= [[UIView alloc] init];
    view_c.frame=CGRectMake(0, 0, 0, 0);
    view_c.backgroundColor=[UIColor colorWithRed:241/255.0 green:242/255.0 blue:240/255.0 alpha:1];
    return view_c;
}
//选中时 调用的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 && indexPath.row==0)
    {
        [self ShowProfilePhoto];
    }else if(indexPath.section == 0 && indexPath.row==1)
    {
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        nameRViewController *vc=[main instantiateViewControllerWithIdentifier:@"nameRViewController"];
        vc.index=2;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if(indexPath.section == 0 && indexPath.row==2)
    {
        
    }else if(indexPath.section == 0 && indexPath.row==3)
    {
        [self ShowGender];
    }else if(indexPath.section == 0 && indexPath.row==4)
    {
        [self setdatePicker];
    }else if(indexPath.section == 0 && indexPath.row==5)
    {
        [self setEmailstr];
    }else if(indexPath.section == 1 && indexPath.row==0)
    {
        UIStoryboard *main=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PostcodeRViewController *vc=[main instantiateViewControllerWithIdentifier:@"PostcodeRViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        vc.index=2;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
-(void)setEmailstr
{
    UIStoryboard *Seting=[UIStoryboard storyboardWithName:@"Seting" bundle:nil];
    PostcodeRViewController *vc=[Seting instantiateViewControllerWithIdentifier:@"EmailStrViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)ShowGender
{
    
//    optionArray = [NSArray array];
    NSArray *optionArray = @[FGGetStringWithKeyFromTable(@"MALE", @"Language"),FGGetStringWithKeyFromTable(@"FEMALE", @"Language")];
    ZGQActionSheetView *sheetView = [[ZGQActionSheetView alloc] initWithOptions:optionArray];
    sheetView.tag=102;
    sheetView.delegate = self;
    [sheetView show];
}

-(void)ShowProfilePhoto
{
    
    //    optionArray = [NSArray array];
    NSArray *optionArray = @[FGGetStringWithKeyFromTable(@"Take New Profile Picture", @"Language"),FGGetStringWithKeyFromTable(@"Select Profile Picture", @"Language")];
    ZGQActionSheetView *sheetView = [[ZGQActionSheetView alloc] initWithOptions:optionArray];
    sheetView.tag=101;
    sheetView.delegate = self;
    [sheetView show];
}


- (void)ZGQActionSheetView:(ZGQActionSheetView *)sheetView didSelectRowAtIndex:(NSInteger)index text:(NSString *)text {
    NSLog(@"%zd,%@",index,text);
    if(sheetView.tag==101)
    {
        if (index==0) {
            [self openCamera];
        }else if (index==1)
        {
            [self openAlbum];
        }
    }else if(sheetView.tag==102)
    {
        if (index==0) {
            [self postUpdateINFO:@"MALE"];
        }else if (index==1)
        {
            [self postUpdateINFO:@"FEMALE"];
        }
    }
}

///// 更新用户的性别
//-(void)postUpdateINFO:(NSString *)firstName lastName:(NSString*)lastName
-(void)postUpdateINFO:(NSString *)gender
{
    
    [HudViewFZ labelExample:self.view];
    NSDictionary * dict=@{@"gender":gender,};
    NSLog(@"dict=== %@",dict);
    
    [[AFNetWrokingAssistant shareAssistant] PostURL_Token:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,post_UpdateInfo] parameters:dict progress:^(id progress) {
        NSLog(@"请求成功 = %@",progress);
    }Success:^(NSInteger statusCode,id responseObject) {
        [HudViewFZ HiddenHud];
        NSLog(@"responseObject = %@",responseObject);
        if(statusCode==200)
        {
            NSDictionary * dictObject=(NSDictionary *)responseObject;
            //            用来储存用户信息
            
            SaveUserIDMode * mode = [[SaveUserIDMode alloc] init];
            
            mode.phoneNumber = [dictObject objectForKey:@"phoneNumber"];//   手机号码
            mode.loginName = [dictObject objectForKey:@"loginName"];//   与手机号码相同
            mode.yonghuID = [dictObject objectForKey:@"id"]; ////用户ID
            //            mode.randomPassword = [dictObject objectForKey:@"randomPassword"];//  验证码
            //            mode.password = [dictObject objectForKey:@"password"];//  登录密码
            //            mode.payPassword = [dictObject objectForKey:@"payPassword"];//    支付密码
            mode.firstName = [dictObject objectForKey:@"firstName"];//   first name
            mode.lastName = [dictObject objectForKey:@"lastName"];//   last name
            NSNumber * birthdayNum = [dictObject objectForKey:@"birthday"];//   生日 8位纯数字，格式:yyyyMMdd 例如：19911012
            mode.birthday = [birthdayNum stringValue];
            mode.gender = [dictObject objectForKey:@"gender"];//       MALE:男，FEMALE:女
            mode.postCode = [dictObject objectForKey:@"postCode"];//   Post Code inviteCode
            mode.EmailStr = [dictObject objectForKey:@"email"];//   email
            mode.inviteCode = [dictObject objectForKey:@"inviteCode"];//       我填写的邀请码
            mode.myInviteCode = [dictObject objectForKey:@"myInviteCode"];//       我的邀请码
            mode.headImageUrl = [dictObject objectForKey:@"headImageUrl"];
            mode.payPassword = [dictObject objectForKey:@"payPassword"];
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            //存储到NSUserDefaults（转NSData存）
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject: mode];
            
            [defaults setObject:data forKey:@"SaveUserMode"];
            [defaults synchronize];
            [jiamiStr base64Data_encrypt:mode.yonghuID];
            [self updateUserMode];
            
        }else
        {
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"statusCode error", @"Language") andDelay:2.0];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"error = %@",error);
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Post error", @"Language") andDelay:2.0];
        [HudViewFZ HiddenHud];
    }];
}

-(void)postUpdateINFO_Birthday:(NSString *)Birthday
{
    
    [HudViewFZ labelExample:self.view];
    NSDictionary * dict=@{@"birthday":Birthday,};
    NSLog(@"dict=== %@",dict);
    
    [[AFNetWrokingAssistant shareAssistant] PostURL_Token:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,post_UpdateInfo] parameters:dict progress:^(id progress) {
        NSLog(@"请求成功 = %@",progress);
    }Success:^(NSInteger statusCode,id responseObject) {
        [HudViewFZ HiddenHud];
        NSLog(@"responseObject = %@",responseObject);
        if(statusCode==200)
        {
            NSDictionary * dictObject=(NSDictionary *)responseObject;
            //            用来储存用户信息
            
            SaveUserIDMode * mode = [[SaveUserIDMode alloc] init];
            
            mode.phoneNumber = [dictObject objectForKey:@"phoneNumber"];//   手机号码
            mode.loginName = [dictObject objectForKey:@"loginName"];//   与手机号码相同
            mode.yonghuID = [dictObject objectForKey:@"id"]; ////用户ID
            //            mode.randomPassword = [dictObject objectForKey:@"randomPassword"];//  验证码
            //            mode.password = [dictObject objectForKey:@"password"];//  登录密码
            //            mode.payPassword = [dictObject objectForKey:@"payPassword"];//    支付密码
            mode.firstName = [dictObject objectForKey:@"firstName"];//   first name
            mode.lastName = [dictObject objectForKey:@"lastName"];//   last name
            NSNumber * birthdayNum = [dictObject objectForKey:@"birthday"];//   生日 8位纯数字，格式:yyyyMMdd 例如：19911012
            mode.birthday = [birthdayNum stringValue];
            mode.gender = [dictObject objectForKey:@"gender"];//       MALE:男，FEMALE:女
            mode.postCode = [dictObject objectForKey:@"postCode"];//   Post Code inviteCode
            mode.EmailStr = [dictObject objectForKey:@"email"];//   email
            mode.inviteCode = [dictObject objectForKey:@"inviteCode"];//       我填写的邀请码
            mode.myInviteCode = [dictObject objectForKey:@"myInviteCode"];//       我的邀请码
            mode.headImageUrl = [dictObject objectForKey:@"headImageUrl"];
            mode.payPassword = [dictObject objectForKey:@"payPassword"];
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            //存储到NSUserDefaults（转NSData存）
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject: mode];
            
            [defaults setObject:data forKey:@"SaveUserMode"];
            [defaults synchronize];
            [jiamiStr base64Data_encrypt:mode.yonghuID];
            [self updateUserMode];
            [self hidden_ZDC_View];
        }else
        {
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"statusCode error", @"Language") andDelay:2.0];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"error = %@",error);
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Post error", @"Language") andDelay:2.0];
        [HudViewFZ HiddenHud];
    }];
}

///// 上传头像
//-(void)postUploadHeadImage:(NSString *)gender
//-(void)postUploadHeadImage:(NSData *)gender
-(void)postUploadHeadImage:(UIImage *)image
{
        
        [HudViewFZ labelExample:self.view];
//        NSDictionary * dict=@{@"file":gender,};
    
//        NSLog(@"dict=== %@",dict);
    NSArray * arr = [NSArray arrayWithObjects:image, nil];
    
    
    [[AFNetWrokingAssistant shareAssistant] uploadImagesWihtImgArr:arr url:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,UploadHeadImage] Tokenbool:NO parameters:nil block:^(id objc, BOOL success) {
        NSLog(@"objc=====  %@",objc);
        NSDictionary *dict= (NSDictionary*)objc;
        NSString * strResult = [dict objectForKey:@"result"];
        NSNumber * statusCode = [dict objectForKey:@"statusCode"];
        
        if(strResult!=nil)
        {
            [HudViewFZ HiddenHud];
            self.ModeUser.headImageUrl=strResult;
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            //存储到NSUserDefaults（转NSData存）
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject: self.ModeUser];
            
            [defaults setObject:data forKey:@"SaveUserMode"];
            [defaults synchronize];
//            [jiamiStr base64Data_encrypt:self.ModeUser.yonghuID];
            [self updateUserMode];
        }else
        {
            if(success==NO)
            {
                [HudViewFZ HiddenHud];
                [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Get error", @"Language") andDelay:2.0];
            }
            if(statusCode!=nil)
            {
                
                NSString * strResult = [dict objectForKey:@"errorMessage"];
                [HudViewFZ HiddenHud];
                [HudViewFZ showMessageTitle:strResult andDelay:2.0];
            }
        }
    }blockprogress:^(id progress) {
        
    }];
}


-(UIImage *)getImage_touxiang
{
//    NSLog(@"URL = %@",[NSString stringWithFormat:@"%@%@%@",FuWuQiUrl,get_downImage,self.ModeUser.headImageUrl]);
//    NSString * fileURL =[NSString stringWithFormat:@"%@%@%@",FuWuQiUrl,get_downImage,self.ModeUser.headImageUrl];
//    UIImage * result;
//
//    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
//
//    result = [UIImage imageWithData:data];
//
//    return result;
    //////  没有获取到返回默认头像
        NSLog(@"URL = %@",[NSString stringWithFormat:@"%@%@%@",FuWuQiUrl,get_downImage,self.ModeUser.headImageUrl]);
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //在此处处理耗时操作
        if(self.ModeUser!=nil)
        {
            if(self.ModeUser.headImageUrl!=nil)
            {
                NSString * fileURL =[NSString stringWithFormat:@"%@%@%@",FuWuQiUrl,get_downImage,self.ModeUser.headImageUrl];
                UIImage * result;
                
                NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
                
                result = [UIImage imageWithData:data];
                
                return result;
            }else
            {
                return [UIImage imageNamed:@"icon_Avatar"];
            }
        }else
        {
            return [UIImage imageNamed:@"icon_Avatar"];
        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            //在主线程刷新
//
//        });
//    });

    
   return [UIImage imageNamed:@"icon_Avatar"];

    
}
-(UIImage *) getImageFromURL:(NSString *)fileURL {
    
    NSLog(@"执行图片下载函数");
    
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    
    result = [UIImage imageWithData:data];
    
    return result;
    
}

-(void)updateUserMode
{
    NSData * data =[[NSUserDefaults standardUserDefaults] objectForKey:@"SaveUserMode"];
    self.ModeUser  = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    [self.topTableview reloadData];
}

-(NSString *)strDate:(NSString *)string
{
    //规定时间格式
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    //设置时区  全球标准时间CUT 必须设置 我们要设置中国的时区
    NSTimeZone *zone = [[NSTimeZone alloc] initWithName:@"CUT"];
    [formatter setTimeZone:zone];
    //变回日期格式
    NSDate *stringDate = [formatter dateFromString:string];
//    NSDate * date = [format dateFromString:string];
    NSDateFormatter* formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"MM/dd/yyyy"];
    //变为数字
    NSString* dateStr = [formatter1 stringFromDate:stringDate];
    return dateStr;
}



-(void)setdatePicker
{
    self.ZDC_View=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.ZDC_View.backgroundColor = ZGQ_BACKGROUND_COLOR;
    tapSuperGesture22 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSuperView:)];
    tapSuperGesture22.delegate = self;
    [self.ZDC_View addGestureRecognizer:tapSuperGesture22];
    self.whiteView=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0)];
    self.whiteView.tag=999;
    self.whiteView.backgroundColor=[UIColor whiteColor];
    
    self.CancelBtn=[[UIButton alloc] initWithFrame:CGRectMake(15, 8, 60, 31)];
    [self.CancelBtn addTarget:self action:@selector(CancelBtnTouch:) forControlEvents:UIControlEventTouchDown];
    [self.CancelBtn setTitle:FGGetStringWithKeyFromTable(@"Cancel", @"Language")  forState:UIControlStateNormal];
    [self.CancelBtn setTitleColor:[UIColor colorWithRed:41/255.0 green:209/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    //    [self.ConfirmBtn.titleLabel setTextColor:[UIColor colorWithRed:41/255.0 green:209/255.0 blue:255/255.0 alpha:1.0]];
    [self.CancelBtn.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
    self.ConfirmBtn=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-60-15, 8, 60, 31)];
    [self.ConfirmBtn addTarget:self action:@selector(ConfirmTouch:) forControlEvents:UIControlEventTouchDown];
    [self.ConfirmBtn setTitle:FGGetStringWithKeyFromTable(@"Confirm", @"Language") forState:UIControlStateNormal];
    [self.ConfirmBtn setTitleColor:[UIColor colorWithRed:41/255.0 green:209/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
//    [self.ConfirmBtn.titleLabel setTextColor:[UIColor colorWithRed:41/255.0 green:209/255.0 blue:255/255.0 alpha:1.0]];
    [self.ConfirmBtn.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
    self.xianLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 47, SCREEN_WIDTH, 1)];
    self.xianLabel.backgroundColor=[UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1.0];
    // 只显示时间
    self.date_picker=[[UIDatePicker alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0)];
    self.date_picker.datePickerMode = UIDatePickerModeDate;
    // 1.1选择datePickr的显示风格
    [self.date_picker setDatePickerMode:UIDatePickerModeDate];
    // 1.2查询所有可用的地区
//    NSLog(@"%@", [NSLocale availableLocaleIdentifiers]);
    //     1.3设置datePickr的地区语言, zh_Han后面是s的就为简体中文,zh_Han后面是t的就为繁体中文， zh_Hans_CN 简体中文 zh_Hant_CN 繁体中文 en_US 英文
    //获取当前设备语言
    //    NSArray *appLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    //    NSString *languageName = [appLanguages objectAtIndex:0];
    [self.date_picker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [self.date_picker setValue:[UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0] forKey:@"textColor"];
    // 1.4监听datePickr的数值变化
    [self.date_picker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];//解决8小时时间差问题
    NSLog(@"self.ModeUser.birthday === %@",self.ModeUser.birthday);
//    NSString * strda;
    if(self.ModeUser.birthday!=nil){
        NSString * strda = [NSString stringWithFormat:@"%@",self.ModeUser.birthday];
        NSDate *birthdayDate = [dateFormatter dateFromString:strda];
        //    NSLog(@"date = %@,  date1 = %@",birthdayDate,[NSDate date]);
        [self.date_picker setDate:birthdayDate];/////设置默认显示时间
    }else
    {
        NSDate *datenow = [NSDate date];
        [self.date_picker setDate:datenow];/////设置默认显示时间
    }
    
    
    //设置最大值时间
    self.date_picker.maximumDate= [NSDate date];//今天
    [self.whiteView addSubview:self.CancelBtn];
    [self.whiteView addSubview:self.ConfirmBtn];
    [self.whiteView addSubview:self.xianLabel];
    [self.whiteView addSubview:self.date_picker];
    [self.ZDC_View addSubview:self.whiteView];
    [self.view addSubview:self.ZDC_View];
    [self show_ZDC_View];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
//        NSLog(@"Class = %@",NSStringFromClass([touch.view class]));
    //    NSLog(@"Class.tag = %ld",touch.view.tag);
    if([NSStringFromClass([touch.view class])isEqual:@"UITableViewCellContentView"]){
        return YES;
    }if([NSStringFromClass([touch.view class])isEqual:@"UIView"]){
        if(touch.view.tag==999)
        {
            return NO;
        }else
        {
            return YES;
        }
    }
    return YES;
}
-(void)show_ZDC_View
{
    [UIView animateWithDuration:(0.4)/*动画持续时间*/animations:^{
        //执行的动画
//        self.ZDC_View.frame=self.view.bounds;
        self.whiteView.frame=CGRectMake(0, SCREEN_HEIGHT-231-64, SCREEN_WIDTH, 231);
        self.date_picker.frame=CGRectMake(0, 48, SCREEN_WIDTH, 185);
    }];
    
}
-(void)hidden_ZDC_View
{
    [UIView animateWithDuration:0.4/*动画持续时间*/animations:^{
        //执行的动画
//        self.ZDC_View.frame =CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
        self.whiteView.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
        self.date_picker.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
    }completion:^(BOOL finished){
        //动画执行完毕后的操作
        [self.ZDC_View removeFromSuperview];
        [self.ZDC_View removeGestureRecognizer:self->tapSuperGesture22];
    }];
}
////点击别的区域收起键盘
- (void)tapSuperView:(UITapGestureRecognizer *)gesture {
    [self hidden_ZDC_View];
    [self.ZDC_View removeGestureRecognizer:tapSuperGesture22 ];
}


-(void)ConfirmTouch:(id)sender
{
    if(self.ModeUser.birthday!=nil)
    {
        if(![self.DateStr isEqualToString:self.ModeUser.birthday])
        {
            [self postUpdateINFO_Birthday:self.DateStr];
        }else
        {
            
            [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Same as before", @"Language") andDelay:2.0];
        }
    }else
    {
        if(![self.DateStr isEqualToString:@""])
        {
            [self postUpdateINFO_Birthday:self.DateStr];
        }
    }
}
-(void)CancelBtnTouch:(id)sender
{
    [self hidden_ZDC_View];
    [self.ZDC_View removeGestureRecognizer:tapSuperGesture22 ];
}



- (void)datePickerValueChanged:(UIDatePicker *)datePicker

{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // 格式化日期格式
    
    formatter.dateFormat = @"yyyyMMdd";
    
    NSString *date = [formatter stringFromDate:datePicker.date];
    self.DateStr=date;
    // 显示时间
    NSLog(@"选择的时间是 ：= %@",date);
    
}





- (void)openCamera
{
    //判断是否已授权
    //    AVAuthorizationStatus autjStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusDenied||authStatus == AVAuthorizationStatusRestricted) {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:FGGetStringWithKeyFromTable(@"Tisp", @"Language")
                                                                           message:FGGetStringWithKeyFromTable(@"Allow StorHub to access camera in Settings-Privacy",@"Language") preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:FGGetStringWithKeyFromTable(@"OK", @"Language") style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                //响应事件
                NSLog(@"action = %@", action);
                [self dismissViewControllerAnimated:YES completion:nil];
                //                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
            
        }else
        {
            UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
            ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
            //            ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            ipc.delegate = self;
            [self.navigationController presentViewController:ipc animated:YES completion:nil];
            //        [self.navigationController pushViewController:ipc animated:YES];
        }
    }
}

-(void)openSDKHQImageEdit:(UIImage*)imageBD
{
     HQImageEditViewController *vc = [[HQImageEditViewController alloc] init];
        vc.originImage = imageBD;
        vc.delegate = self;
        vc.maskViewAnimation = YES;
    //    vc.editViewSize = CGSizeMake(300, 200);
    //    [self presentViewController:vc animated:YES completion:nil];
        [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - HQImageEditViewControllerDelegate
- (void)editController:(HQImageEditViewController *)vc finishiEditShotImage:(UIImage *)image originSizeImage:(UIImage *)originSizeImage {
//    self.imageView.image = originSizeImage;
//    [vc dismissViewControllerAnimated:YES completion:nil];
    [self postUploadHeadImage:originSizeImage];
    [vc.navigationController popViewControllerAnimated:YES];
}

- (void)editControllerDidClickCancel:(HQImageEditViewController *)vc {
//    [vc dismissViewControllerAnimated:YES completion:nil];
    [vc.navigationController popViewControllerAnimated:YES];
}


- (void)openAlbum
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        //        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        //        [self presentViewController:imagePickerVc animated:YES completion:nil];
        UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        //            ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        ipc.delegate = self;
        [self.navigationController presentViewController:ipc animated:YES completion:nil];
    }else{
        //        [self showHint:@"请打开允许访问相册权限"];
        NSLog(@"请打开允许访问相册权限");
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:FGGetStringWithKeyFromTable(@"Tisp", @"Language")
                                                                       message:FGGetStringWithKeyFromTable(@"Allow StorHub to access album in Settings-Privacy",@"Language") preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:FGGetStringWithKeyFromTable(@"OK", @"Language") style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            //响应事件
            NSLog(@"action = %@", action);
            [self dismissViewControllerAnimated:YES completion:nil];
            //                [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate
//相机选的图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 关闭相册\相机
    [picker dismissViewControllerAnimated:YES completion:nil];
    //     [self.navigationController popViewControllerAnimated:NO];
    // 往数据数组拼接图片
    //    [self.dataArr addObject:info[UIImagePickerControllerOriginalImage]];
    NSLog(@"MMMM= %@",info[UIImagePickerControllerOriginalImage]);
    [self openSDKHQImageEdit:[InformationViewController compressImageQuality:info[UIImagePickerControllerOriginalImage] toByte:51200]];
//    [self postUploadHeadImage:[InformationViewController compressImageQuality:info[UIImagePickerControllerOriginalImage] toByte:51200]];
}
//取消按钮
- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picke{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSDictionary *dict = @{FGGetStringWithKeyFromTable(@"Dismiss", @"Language"):@"1"};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeNext" object:nil userInfo:dict];
}
// 相册选的图片
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    
//    [self postUploadHeadImage:[InformationViewController compressImageQuality:(UIImage*)photos[0] toByte:51200]];
    [self openSDKHQImageEdit:[InformationViewController compressImageQuality:(UIImage*)photos[0] toByte:51200]];
}



-(NSData *)compressWithMaxLength:(NSUInteger)maxLength image_P:(UIImage *)imageVV{
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(imageVV, compression);
    //NSLog(@"Before compressing quality, image size = %ld KB",data.length/1024);
    if (data.length < maxLength) return data;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(imageVV, compression);
        //NSLog(@"Compression = %.1f", compression);
        //NSLog(@"In compressing quality loop, image size = %ld KB", data.length / 1024);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    //NSLog(@"After compressing quality, image size = %ld KB", data.length / 1024);
    if (data.length < maxLength) return data;
    UIImage *resultImage = [UIImage imageWithData:data];
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        //NSLog(@"Ratio = %.1f", ratio);
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
        //NSLog(@"In compressing size loop, image size = %ld KB", data.length / 1024);
    }
    //NSLog(@"After compressing size loop, image size = %ld KB", data.length / 1024);
    return data;
}


+ (UIImage *)compressImageQuality:(UIImage *)image toByte:(NSInteger)maxLength {
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return image;
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    return resultImage;
}

-(NSData *)imageData:(UIImage *)myimage
{
    NSData *data=UIImageJPEGRepresentation(myimage, 1.0);
    if (data.length>100*1024) {
        if (data.length>2*1024*1024) {//2M以及以上
            data=UIImageJPEGRepresentation(myimage, 0.05);
        }else if (data.length>1024*1024) {//1M-2M
            data=UIImageJPEGRepresentation(myimage, 0.1);
        }else if (data.length>512*1024) {//0.5M-1M
            data=UIImageJPEGRepresentation(myimage, 0.2);
        }else if (data.length>200*1024) {//0.25M-0.5M
            data=UIImageJPEGRepresentation(myimage, 0.4);
        }
    }
    return data;
}

@end
