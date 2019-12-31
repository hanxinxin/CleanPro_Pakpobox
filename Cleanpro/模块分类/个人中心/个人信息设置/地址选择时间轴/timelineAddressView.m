//
//  timelineAddressViewController.m
//  BleDemo
//
//  Created by mac on 2019/12/23.
//  Copyright © 2019 mac. All rights reserved.
//

#import "timelineAddressView.h"
#import "timelineAddressTableViewCell.h"
#import "MJExtension.h"
#import "Masonry.h"
#import "UITableView+FDTemplateLayoutCell.h"

#define tableID @"timelineAddressTableViewCell"

@implementation CitySelectMode

@end


static BOOL selectOne_two=NO;

//@interface timelineAddressViewController ()<UITableViewDelegate,UITableViewDataSource>
@interface timelineAddressView ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger ASelect;///tableviewA的选择界面；
    NSInteger SelectInteger; ///tableviewB的选择界面
    BOOL AAndB_bool;
   
}
@end

@implementation timelineAddressView

//- (void)viewDidLoad {
//    [super viewDidLoad];
-(void)awakeFromNib
{

    [self setBackgroundColor:[UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:0.6]];
//    self.tableviewA.frame = CGRectMake(0, 0, SCREEN_WIDTH, 120);
    self.tableviewA.tag=5000;
    self.tableviewA.delegate=self;
    self.tableviewA.dataSource=self;
    self.tableviewA.contentInset = UIEdgeInsetsMake(-0.1, 0, 0, 0);
    self.tableviewA.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableviewA.backgroundColor = [UIColor whiteColor];
//    self.tableviewB.frame = CGRectMake(0, 0, SCREEN_WIDTH, 120);
    self.tableviewB.tag=5001;
    self.tableviewB.delegate=self;
    self.tableviewB.dataSource=self;
    self.tableviewB.contentInset = UIEdgeInsetsMake(-0.1, 0, 0, 0);
    self.tableviewB.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableviewB.backgroundColor = [UIColor whiteColor];
    SelectInteger=9999;
    ASelect=0;
    AAndB_bool=NO;
//    [self.tableviewA registerClass:[timelineAddressTableViewCell class] forCellReuseIdentifier:CCContentCellID];
//        CALayer *layer = [CALayer layer];
//        layer.frame = CGRectMake(0, self.topBarView.frame.size.height - 0, SCREEN_WIDTH, 1);
//    layer.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1].CGColor;
//        [self.topBarView.layer addSublayer:layer];
    [self.CancelBtn setTitle:FGGetStringWithKeyFromTable(@"Cancel", @"Language") forState:(UIControlStateNormal)];
    [self.SaveBtn setTitle:FGGetStringWithKeyFromTable(@"Save", @"Language") forState:(UIControlStateNormal)];
    [self.tableviewA registerNib:[UINib nibWithNibName:@"timelineAddressTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:tableID];
//    self.ArrayCity = [[NSArray alloc] init];
    self.ArrayCity = [NSMutableArray arrayWithCapacity:0];
    self.OneArray = [NSMutableArray arrayWithCapacity:0];
//    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05/*延迟执行时间*/ * NSEC_PER_SEC));
//
//    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self setTableviewFrame];
//    });
    
        [super awakeFromNib];
        
}
-(void)setArrayTable:(NSMutableArray*)arr selectArr:(NSMutableArray *)Selectarray index:(NSInteger)Index
{
    if(arr==nil && Selectarray==nil && Index==0)
    {
        ASelect=0;
        [self Get_AddressSelectList:nil parentIdStr:nil index:0];
    }else if (arr!=nil && Selectarray==nil && Index==0)
    {
        self.ArrayCity = arr;
        [self.tableviewA reloadData];
        [self.tableviewB reloadData];
    }else if (arr==nil && Selectarray!=nil && Index==1)
    {
        ASelect=2;
        ThreeCityMode * mode3=Selectarray[0];
        TwoCityMode * mode2 = mode3.parentRegion;
        OneCityMode * mode1 = mode2.parentRegion;
        [self.OneArray addObject:mode1];
        [self.OneArray addObject:mode2];
        [self.OneArray addObject:mode3];
        [self setTableviewFrame];
        [self Get_AddressSelectList:nil parentIdStr:mode2.idStrTwo index:0];
    }
    else if (arr==nil && Selectarray!=nil && Index==0)
    {
        ASelect=2;
        ThreeCityMode * mode3=Selectarray[2];
        TwoCityMode * mode2 = mode3.parentRegion;
        OneCityMode * mode1 = mode2.parentRegion;
        [self.OneArray addObject:mode1];
        [self.OneArray addObject:mode2];
        [self.OneArray addObject:mode3];
        [self setTableviewFrame];
        [self Get_AddressSelectList:nil parentIdStr:mode2.idStrTwo index:0];
    }
}

/// 根据区号获取地址
-(void)Get_AddressSelectList:(NSString *)postcode parentIdStr:(NSString *)parentId index:(NSInteger)Index
{
    [HudViewFZ labelExample:self];
    NSString * GetURLStr;
    if(postcode!=nil)
    {
        if(parentId!=nil)
        {
            GetURLStr=[NSString stringWithFormat:@"%@%@?postcode=%@&parentId=%@",FuWuQiUrl,Get_AddressSelect,postcode,parentId] ;
        }else
        {
            GetURLStr=[NSString stringWithFormat:@"%@%@?postcode=%@&parentId=%@",FuWuQiUrl,Get_AddressSelect,postcode,parentId];
        }
    }else
    {
        if(parentId!=nil)
        {
            GetURLStr=[NSString stringWithFormat:@"%@%@?parentId=%@",FuWuQiUrl,Get_AddressSelect,parentId] ;
        }else
        {
            GetURLStr=[NSString stringWithFormat:@"%@%@",FuWuQiUrl,Get_AddressSelect];
        }
    }
    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL:GetURLStr parameters:nil progress:^(id progress) {
        
    } success:^(id responseObject) {
        NSLog(@"responseObject== %@",responseObject);
        [HudViewFZ HiddenHud];
       if(responseObject!=nil)
       {
           [self.ArrayCity removeAllObjects];
        if(self->ASelect==0)
        {
            NSArray * arrayZong = (NSArray *)responseObject;
            NSMutableArray * KBArray = [NSMutableArray arrayWithCapacity:0];
           for (int i =0; i<arrayZong.count; i++) {
               NSDictionary * dict =arrayZong[i];
               OneCityMode* mode = [[OneCityMode alloc] init];
               mode.idStr=[dict objectForKey:@"id"];
               mode.regionLevel=[dict objectForKey:@"regionLevel"];
               mode.regionName=[dict objectForKey:@"regionName"];
               mode.regionShortName=[dict objectForKey:@"regionShortName"];
               [KBArray addObject:mode];
           }
            self.ArrayCity = KBArray;
        }else if(self->ASelect==1)
        {
            NSMutableArray * Muarray = [NSMutableArray arrayWithCapacity:0];
                       NSArray * array = (NSArray *)responseObject;
                       for (int i =0 ; i<array.count; i++) {
                           NSDictionary * dict = array[i];
                           TwoCityMode * modeT = [[TwoCityMode alloc] init];
                           modeT.idStrTwo=[dict objectForKey:@"id"];
                           NSDictionary * dictTwo=[dict objectForKey:@"parentRegion"];
                               OneCityMode* modeO = [[OneCityMode alloc] init];
                               modeO.idStr=[dictTwo objectForKey:@"id"];
                               modeO.regionLevel=[dictTwo objectForKey:@"regionLevel"];
                               modeO.regionName=[dictTwo objectForKey:@"regionName"];
                               modeO.regionShortName=[dictTwo objectForKey:@"regionShortName"];
                           modeT.parentRegion = modeO;
                           modeT.regionLevel=[dict objectForKey:@"regionLevel"];
                           modeT.regionName=[dict objectForKey:@"regionName"];
                           [Muarray addObject:modeT];
                       }
                       self.ArrayCity=Muarray;
        }else if(self->ASelect==2)
        {
            NSMutableArray * Muarray3 = [NSMutableArray arrayWithCapacity:0];
            NSArray * array = (NSArray *)responseObject;
            for (int i =0 ; i<array.count; i++) {
                NSDictionary * dict3 = array[i];
                ThreeCityMode * mode3= [[ThreeCityMode alloc] init];
                mode3.idStrThree = [dict3 objectForKey:@"id"];
                NSDictionary * dict=[dict3 objectForKey:@"parentRegion"];
                    TwoCityMode * modeT = [[TwoCityMode alloc] init];
                    modeT.idStrTwo=[dict objectForKey:@"id"];
                    NSDictionary * dictTwo=[dict objectForKey:@"parentRegion"];
                        OneCityMode* modeO = [[OneCityMode alloc] init];
                        modeO.idStr=[dictTwo objectForKey:@"id"];
                        modeO.regionLevel=[dictTwo objectForKey:@"regionLevel"];
                        modeO.regionName=[dictTwo objectForKey:@"regionName"];
                        modeO.regionShortName=[dictTwo objectForKey:@"regionShortName"];
                    modeT.parentRegion = modeO;
                    modeT.regionLevel=[dict objectForKey:@"regionLevel"];
                    modeT.regionName=[dict objectForKey:@"regionName"];
                mode3.parentRegion=modeT;
                mode3.postcode = [dict3 objectForKey:@"postcode"];
                mode3.regionLevel=[dict3 objectForKey:@"regionLevel"];
                mode3.regionName=[dict3 objectForKey:@"regionName"];
                [Muarray3 addObject:mode3];
            }
            self.ArrayCity=Muarray3;
        }
            [self.tableviewA reloadData];
            [self.tableviewB reloadData];
       }
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error);
        [HudViewFZ showMessageTitle:FGGetStringWithKeyFromTable(@"Post error", @"Language") andDelay:2.0];
        [HudViewFZ HiddenHud];
    }];
}


- (IBAction)Cancel_touch:(id)sender {
    if ([self.delegate respondsToSelector:@selector(CancelDelegate:SelectArray:)]) {
        [self.delegate CancelDelegate:1 SelectArray:self.OneArray];
    }
}
- (IBAction)Save_touch:(id)sender {
    if ([self.delegate respondsToSelector:@selector(CancelDelegate:SelectArray:)]) {
        [self.delegate CancelDelegate:2 SelectArray:self.OneArray];
    }
}


#pragma mark -------- Tableview -------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView.tag==5000)
    {
        return self.OneArray.count;
//        return 3;
    }else if(tableView.tag==5001)
    {
//        NSArray * arr= self.ArrayCity[ASelect];
//        return arr.count;
        return self.ArrayCity.count;
    }
    return 0;
}
//4、设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView.tag==5000)
       {
       return [tableView fd_heightForCellWithIdentifier:CCContentCellID cacheByIndexPath:indexPath configuration:^(id cell) {[self configureCell:cell atIndexPath:indexPath];}];
       }else if(tableView.tag==5001)
       {
       return 40;
       }
    
    return 0;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    timelineAddressTableViewCell *cell = [timelineAddressTableViewCell cellWithTableView:tableView];
    if(tableView.tag==5000)
    {
    
    timelineAddressTableViewCell *cell = (timelineAddressTableViewCell *)[tableView dequeueReusableCellWithIdentifier:tableID];
       if (cell == nil) {
           cell= (timelineAddressTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"timelineAddressTableViewCell" owner:self options:nil]  lastObject];
       }
//        if(self.OneArray.count==1)
//        {
//
//        }else{
    
            if (indexPath.row == 0) {
                if(self.OneArray.count==1)
                {
                    cell.lineView.hidden=YES;
                }else
                {
                    cell.lineView.hidden=NO;
                }
                [cell.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(cell.pointView.mas_bottom);
                    make.bottom.equalTo(cell);
                    make.width.mas_offset(0.5);
                    make.centerX.equalTo(cell.pointView);
                }];
            }else if(indexPath.row == (self.OneArray.count-1))
            {
                [cell.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(cell);
                    make.bottom.equalTo(cell.pointView.mas_bottom);
                    make.width.mas_offset(0.5);
                    make.centerX.equalTo(cell.pointView);
                   
                }];
            }else {
                [cell.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(cell);
                    make.bottom.equalTo(cell);
                    make.width.mas_offset(0.5);
                    make.centerX.equalTo(cell.pointView);
                }];
            }
            [self configureCell:cell atIndexPath:indexPath];
//        }
        //cell选中效果
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(indexPath.row==0)
        {
            OneCityMode * mode1 =self.OneArray[0];
            [cell.cellTitle setText:mode1.regionName];
        }else if(indexPath.row==1)
        {
            TwoCityMode * mode2 =self.OneArray[1];
            [cell.cellTitle setText:mode2.regionName];
        }else if(indexPath.row==2)
        {
            ThreeCityMode * mode3 =self.OneArray[2];
            [cell.cellTitle setText:mode3.regionName];
        }
        
        
//        CitySelectMode * mode = self.OneArray[indexPath.row];
////        SelectInteger = mode.indexS;
//        [cell.cellTitle setText:mode.cityName];
    
    return cell;
        
        }else if(tableView.tag==5001)
        {
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellID"];
                
                //            cell.contentView.backgroundColor = [UIColor blueColor];
                
            }
//            UIView *lbl = [[UIView alloc] init]; //定义一个label用于显示cell之间的分割线（未使用系统自带的分割线），也可以用view来画分割线
//            lbl.frame = CGRectMake(cell.frame.origin.x + 10, 0, self.width-1, 1);
//            lbl.backgroundColor =  [UIColor colorWithRed:240/255.0 green:241/255.0 blue:242/255.0 alpha:1];
//            [cell.contentView addSubview:lbl];
            //cell选中效果
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.textColor = [UIColor colorWithRed:152/255.0 green:169/255.0 blue:179/255.0 alpha:1.0];
            
//            NSArray * arr= self.ArrayCity[ASelect];
            if(ASelect==0)
            {
                OneCityMode * mode = self.ArrayCity[indexPath.row];
                cell.textLabel.text = [NSString stringWithFormat:@"%@",mode.regionName];;
                if(self.OneArray.count>=1)
                {
                OneCityMode * mode1 =self.OneArray[0];
                [self setCellImage:[mode1.idStr isEqualToString:mode.idStr] Tabelcell:cell];
                }else
                {
                    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
                    imgV.frame = CGRectMake(0,0,20,20);
                    cell.accessoryView = imgV;
                    cell.textLabel.textColor = [UIColor colorWithRed:152/255.0 green:169/255.0 blue:179/255.0 alpha:1.0];
                }
            }else if(ASelect==1)
            {
                TwoCityMode * mode2 = self.ArrayCity[indexPath.row];
                cell.textLabel.text = [NSString stringWithFormat:@"%@",mode2.regionName];;
                if(self.OneArray.count>=2)
                {
                TwoCityMode * mode22 =self.OneArray[1];
                [self setCellImage:[mode22.idStrTwo isEqualToString:mode2.idStrTwo] Tabelcell:cell];
                }else
                {
                    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
                    imgV.frame = CGRectMake(0,0,20,20);
                    cell.accessoryView = imgV;
                    cell.textLabel.textColor = [UIColor colorWithRed:152/255.0 green:169/255.0 blue:179/255.0 alpha:1.0];
                }
            }
            else if(ASelect==2)
            {
                ThreeCityMode * mode3 = self.ArrayCity[indexPath.row];
                cell.textLabel.text = [NSString stringWithFormat:@"%@",mode3.regionName];;
                
                if(self.OneArray.count>=3)
                {
                ThreeCityMode * mode33 =self.OneArray[2];
                [self setCellImage:[mode33.idStrThree isEqualToString:mode3.idStrThree] Tabelcell:cell];
                }else
                {
                    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
                    imgV.frame = CGRectMake(0,0,20,20);
                    cell.accessoryView = imgV;
                    cell.textLabel.textColor = [UIColor colorWithRed:152/255.0 green:169/255.0 blue:179/255.0 alpha:1.0];
                }
            }
//            cell.textLabel.textColor = [UIColor darkGrayColor];
            //    if(indexPath.row!=3)
            //    {
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
            //    }
//            cell.textLabel.textColor = [UIColor darkGrayColor];
            //    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            //    cell.layer.cornerRadius=4;
            return cell;
        }
    return nil;
}
- (void)configureCell:(timelineAddressTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    //使用Masonry进行布局的话，这里要设置为NO
    cell.fd_enforceFrameLayout = NO;
}

-(void)setCellImage:(BOOL)boolCell Tabelcell:(UITableViewCell*)cell
{
    if(boolCell)
    {
        UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check-circle-fill"]];
                           imgV.frame = CGRectMake(0,0,20,20);
                           cell.accessoryView = imgV;
                           cell.textLabel.textColor = [UIColor colorWithRed:26/255.0 green:149/255.0 blue:229/255.0 alpha:1.0];
    }else
    {
        UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        imgV.frame = CGRectMake(0,0,20,20);
        cell.accessoryView = imgV;
        cell.textLabel.textColor = [UIColor colorWithRed:152/255.0 green:169/255.0 blue:179/255.0 alpha:1.0];
    }
}

////行高
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    return 40;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 44;
//}
////设置间隔高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
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
    view_c.frame=CGRectMake(0, 0,SCREEN_WIDTH, 0.6);
    view_c.backgroundColor=[UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
    return view_c;
}
//选中时 调用的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView.tag==5000)
    {
        ASelect = indexPath.row;
//        CitySelectMode * mode = self.OneArray[indexPath.row];
//        SelectInteger = mode.indexS;
//        AAndB_bool=YES;
        if(ASelect==0)
        {
//            [self.OneArray removeAllObjects];
            [self Get_AddressSelectList:nil parentIdStr:nil index:0];
            selectOne_two=YES;
        }else if (ASelect==1)
        {
//            OneCityMode * mode =self.OneArray[0];
//            [self.OneArray removeAllObjects];
//            [self.OneArray addObject:mode];
//            [self Get_AddressSelectList:nil parentIdStr:mode.idStr index:0];
            OneCityMode * mode =self.OneArray[0];
            [self Get_AddressSelectList:nil parentIdStr:mode.idStr index:0];
            selectOne_two=YES;
        }else if (ASelect==2)
        {
//            OneCityMode * mode1 =self.OneArray[0];
            TwoCityMode * mode2 =self.OneArray[1];
//            [self.OneArray removeAllObjects];
//            [self.OneArray addObject:mode1];
//            [self.OneArray addObject:mode2];
            [self Get_AddressSelectList:nil parentIdStr:mode2.idStrTwo index:0];
            selectOne_two=YES;
        }
//        [self.tableviewA reloadData];
//        [self.tableviewB reloadData];
    }else if(tableView.tag==5001)
    {
            if(ASelect==0)
            {
                if(selectOne_two==YES)
                {
                    OneCityMode * mode = self.ArrayCity[indexPath.row];
                    [self.OneArray removeAllObjects];
                    [self.OneArray addObject:mode];
                    ASelect=1;
                    [self Get_AddressSelectList:nil parentIdStr:mode.idStr index:0];
                }else{
                
                    OneCityMode * mode = self.ArrayCity[indexPath.row];
                    [self.OneArray removeAllObjects];
                    [self.OneArray addObject:mode];
                    ASelect=1;
                    [self Get_AddressSelectList:nil parentIdStr:mode.idStr index:0];
                
                }
                selectOne_two=NO;
            }else if (ASelect==1)
            {
                if(selectOne_two==YES)
                {
                    TwoCityMode * mode = self.ArrayCity[indexPath.row];
                    [self.OneArray replaceObjectAtIndex:1 withObject:mode];
                    if(self.OneArray.count==3)
                    {
                        [self.OneArray removeObjectAtIndex:2];
                    }
                    ASelect=2;
                    [self Get_AddressSelectList:nil parentIdStr:mode.idStrTwo index:0];
                }else
                {
                    ASelect=2;
                    TwoCityMode * mode = self.ArrayCity[indexPath.row];
                    [self.OneArray addObject:mode];
                    [self Get_AddressSelectList:nil parentIdStr:mode.idStrTwo index:0];
                     
                }
                selectOne_two=NO;
            }else if (ASelect==2)
            {
                if(selectOne_two==YES)
                {
                    ThreeCityMode * mode = self.ArrayCity[indexPath.row];
                   [self.OneArray replaceObjectAtIndex:2 withObject:mode];
                    ASelect=2;
                }else
                {
                    ASelect=2;
                    ThreeCityMode * mode = self.ArrayCity[indexPath.row];
                    if(self.OneArray.count==3)
                    {
                        [self.OneArray replaceObjectAtIndex:2 withObject:mode];
                    }else
                    {
    //                    ThreeCityMode * mode = self.ArrayCity[indexPath.row];
                        [self.OneArray addObject:mode];
                    }
                }
                selectOne_two=NO;
                [self.tableviewA reloadData];
                [self.tableviewB reloadData];
            }
            
       
    }
    
    
    
    [self setTableviewFrame];
}

-(void)setTableviewFrame
{
//    [self.tableviewA mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.topBarView.mas_left).offset(0);
//        make.width.mas_offset(SCREEN_WIDTH);
//        make.height.mas_offset((self.OneArray.count*40));
//        make.top.mas_offset(self.topBarView.bottom);
//    }];
//    [self.tableviewB mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.tableviewA.mas_left).offset(0);
//        make.width.mas_offset(SCREEN_WIDTH);
//        make.height.mas_offset(SCREEN_HEIGHT-(self.OneArray.count*40+200));
//        make.top.mas_offset(self.tableviewA.bottom);
//    }];
    self.tableviewA.frame = CGRectMake(self.topBarView.left, self.topBarView.bottom, SCREEN_WIDTH, (self.OneArray.count*44.f));
    self.tableviewB.frame = CGRectMake(self.topBarView.left, self.tableviewA.bottom, SCREEN_WIDTH, SCREEN_HEIGHT-(self.OneArray.count*44.f+self.topBarView.height+150.f+(kNavBarAndStatusBarHeight)));
}














































//  tableviewd以前的点击处理代码
/*
if(tableView.tag==5000)
{
    ASelect = indexPath.row;
    CitySelectMode * mode = self.OneArray[indexPath.row];
    SelectInteger = mode.indexS;
    AAndB_bool=YES;
    [self.tableviewA reloadData];
    [self.tableviewB reloadData];
}else if(tableView.tag==5001)
{
    NSLog(@"ASelect == %ld",(long)ASelect);
     NSArray * arr= self.ArrayCity[ASelect];
    SelectInteger = indexPath.row;
    CitySelectMode * mode = [[CitySelectMode alloc] init];
    mode.cityName = arr[indexPath.row];
    mode.indexS = indexPath.row;

    if(AAndB_bool==YES)
    {
                if(ASelect==0)
                {
                    [self.OneArray removeAllObjects];
                    [self.OneArray addObject:mode];
                    CitySelectMode * mode2 = [[CitySelectMode alloc] init];
                    mode2.cityName = @"Please select";
                    mode2.indexS = 9000;
                    [self.OneArray addObject:mode2];
                    ASelect=1;
                    SelectInteger=9999;
                }else if(ASelect==1)
                {
                    if(self.OneArray.count==3)
                    {
                        [self.OneArray removeObjectAtIndex:2];
                        [self.OneArray removeObjectAtIndex:1];
                        [self.OneArray addObject:mode];
                        CitySelectMode * mode2 = [[CitySelectMode alloc] init];
                        mode2.cityName = @"Please select";
                        mode2.indexS = 9000;
                        [self.OneArray addObject:mode2];
                        ASelect=2;
                        SelectInteger=9999;
                    }else if(self.OneArray.count==2)
                    {
                        [self.OneArray insertObject:mode atIndex:1];
                        ASelect=2;
                        SelectInteger=9999;
                    }
                    
                }else if(ASelect==2)
                {
                   
                    [self.OneArray replaceObjectAtIndex:2 withObject:mode];
                    ASelect=2;
                    SelectInteger=9999;
                }
    }else{
    if(self.OneArray.count<2)
    {
            [self.OneArray addObject:mode];
            CitySelectMode * mode2 = [[CitySelectMode alloc] init];
            mode2.cityName = @"Please select";
            mode2.indexS = 9000;
            [self.OneArray addObject:mode2];
            ASelect=1;
        
    }else if(self.OneArray.count ==2)
    {
         [self.OneArray insertObject:mode atIndex:1];
        ASelect=2;
        
    }else if(self.OneArray.count ==3)
    {
        ASelect=2;
        [self.OneArray replaceObjectAtIndex:2 withObject:mode];
    }
    }
    AAndB_bool=NO;
    [self.tableviewA reloadData];
    [self.tableviewB reloadData];
}
 */

@end
