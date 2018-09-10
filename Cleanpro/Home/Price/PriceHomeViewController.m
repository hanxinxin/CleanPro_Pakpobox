//
//  PriceHomeViewController.m
//  Cleanpro
//
//  Created by mac on 2018/7/20.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "PriceHomeViewController.h"
#import "PirceListTableViewCell.h"
#import "BGLabel.h"
#import "VPKCUIViewExt.h"

#define tableID @"PirceListTableViewCell"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height



@implementation SKU_class

@end

@implementation SKU_Dryclass
@end

@interface PriceHomeViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger cout_line;
    NSMutableArray * arr_jixing;
}
@end

@implementation PriceHomeViewController
@synthesize StableView,M_array,value_array,value_Dryarray,cellTitleArr;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"Price";
    StableView.hidden=YES;
    self.view.backgroundColor=[UIColor colorWithRed:236/255.0 green:240/255.0 blue:241/255.0 alpha:1];
    M_array=[NSMutableArray arrayWithCapacity:0];
    value_array=[NSMutableArray arrayWithCapacity:0];
    arr_jixing=[NSMutableArray arrayWithCapacity:0];
    value_Dryarray=[NSMutableArray arrayWithCapacity:0];;
    cellTitleArr=[NSMutableArray arrayWithCapacity:0];
    cout_line=0;
    [self getPriceList];
    
}

-(void)getPriceList
{
    [value_Dryarray removeAllObjects];
    [cellTitleArr removeAllObjects];
//    [HudViewFZ labelExample:self.view];
////    [NSString stringWithFormat:@"%@%@",FuWuQiUrl,Get_PriceList];
//    [[AFNetWrokingAssistant shareAssistant] GETWithCompleteURL:[NSString stringWithFormat:@"%@%@",FuWuQiUrl,Get_PriceList] parameters:nil progress:^(id progress) {
//        
//    } success:^(id responseObject) {
//        NSLog(@"responseObject：%@",responseObject);
//      NSArray * arrLa = (NSArray *)responseObject;
//        if(arrLa.count>0){
//            [self->arr_jixing removeAllObjects];
//            [self->value_array removeAllObjects];
//            self->cout_line=0;
//            [HudViewFZ HiddenHud];
//        for (int i= 0; i<arrLa.count; i++) {
//            if(i==0){
//            NSDictionary * dict_A=(NSDictionary *)arrLa[i];
////            NSLog(@"价格列表：%@",dict_A);
//                NSString * nameTitle=[dict_A objectForKey:@"name"];
//                                      [self->cellTitleArr addObject:nameTitle];
//            NSArray * sku_list_Arr=[dict_A objectForKey:@"sku_list"];
//            NSString * iseq=@"";
//            self->cout_line=0;
//            for (int j=0; j<sku_list_Arr.count; j++) {
//                SKU_class * mode_sku=[[SKU_class alloc] init];
//                NSDictionary * zong_Dict=sku_list_Arr[j];
//                mode_sku.Price=[zong_Dict objectForKey:@"price"];
//                NSArray * arr_values=[zong_Dict objectForKey:@"prop_values"];
//                for (int k=0; k<arr_values.count; k++) {
//                    NSDictionary * zong_Value=arr_values[k];
//                    if(k==0){
//                    mode_sku.prop_value1=[zong_Value objectForKey:@"value"];
//                        ////计算有多少个机型
////                        if(i==0)
////                        {NSLog(@"踩踩踩");
////                            iseq= mode_sku.prop_value1;
////                            self->cout_line=1;
////                            [self->arr_jixing addObject:iseq];
////                        }
//                        if([mode_sku.prop_value1 isEqualToString:iseq])
//                        {
////                            NSLog(@"惨叫姐姐");
//                        }else
//                        {
//                            iseq= mode_sku.prop_value1;
//                            self->cout_line+=1;
//                            [self->arr_jixing addObject:iseq];
////                            NSLog(@"摸摸摸");
//                        }
//                    }else if(k==1)
//                    {
//                    //////////////////////////////
//                    mode_sku.prop_value2=[zong_Value objectForKey:@"value"];
//                    }
//                }
//                [self->value_array addObject:mode_sku];
//            }
//            NSArray * item_props_arr=[dict_A objectForKey:@"item_props"];
//            for (int k=0; k<item_props_arr.count; k++) {
//                NSDictionary * dict=item_props_arr[k];
//                NSString * item_Name=[dict objectForKey:@"name"];
//                [self->M_array addObject:item_Name];
//            }
//            
//            }else if(i==1){
//                
//                NSDictionary * dict_A=(NSDictionary *)arrLa[i];
//                //            NSLog(@"价格列表：%@",dict_A);
//                NSString * nameTitle=[dict_A objectForKey:@"name"];
//                [self->cellTitleArr addObject:nameTitle];
//                NSArray * sku_list_Arr=[dict_A objectForKey:@"sku_list"];
//                for (int j=0; j<sku_list_Arr.count; j++) {
//                    SKU_Dryclass * mode_sku=[[SKU_Dryclass alloc] init];
//                    NSDictionary * zong_Dict=sku_list_Arr[j];
//                    mode_sku.Price=[zong_Dict objectForKey:@"price"];
//                    NSArray * arr_values=[zong_Dict objectForKey:@"prop_values"];
//                    for (int k=0; k<arr_values.count; k++) {
//                        NSDictionary * zong_Value=arr_values[k];
//                        mode_sku.prop_value1=[zong_Value objectForKey:@"value"];
//                        
//                    }
//                    [self->value_Dryarray addObject:mode_sku];
//                }
//            
//                
//            }
//            
//        }
//        
//            NSLog(@"cout === %ld",self->arr_jixing.count);
//            NSLog(@"cout_line =%ld",self->cout_line);
//            [self addSTableview];
//        }else
//        {
//            [HudViewFZ showMessageTitle:@"Data acquisition failure" andDelay:2.0];
//        }
//    } failure:^(NSError *error) {
//        NSLog(@"Error= %@",error);
//        [HudViewFZ HiddenHud];
//        [HudViewFZ showMessageTitle:@"Error" andDelay:2.0];
//    }];
}


-(void)addSTableview
{
//    StableView.frame=CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
    StableView.hidden=NO;
    if(SCREEN_WIDTH==375.000000 && SCREEN_HEIGHT==812.000000)
    {
        StableView.frame=CGRectMake(20, 64+20+8, SCREEN_WIDTH-20*2,SCREEN_HEIGHT-64-20-8);
    }else{
        StableView.frame=CGRectMake(20, 64+8, SCREEN_WIDTH-20*2,SCREEN_HEIGHT-64-8);
    }
    StableView.delegate=self;
    StableView.dataSource=self;
    StableView.backgroundColor=[UIColor colorWithRed:236/255.0 green:240/255.0 blue:241/255.0 alpha:1];
    //     self.Set_tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //    self.Set_tableView.separatorInset=UIEdgeInsetsMake(0,10, 0, 10);           //top left bottom right 左右边距相同
    StableView.separatorStyle=UITableViewCellSeparatorStyleNone;
     [StableView registerNib:[UINib nibWithNibName:@"PirceListTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:tableID];
    [self.view addSubview:StableView];
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
/////只创建title
-(UIView * )label_word:(NSInteger)line column:(NSInteger)column titleLabel:(NSArray * )arrTitle width_w:(CGFloat)width left_L:(CGFloat)left Top_r:(CGFloat)top height_z:(CGFloat)height cell_width:(CGFloat)cell_wid jixing:(NSArray*)jixing priceArr:(NSArray*)priceArr
{
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(left, top, width, height)];
    view.backgroundColor=[UIColor clearColor];
    CGFloat title_h=0;
    CGFloat title_width=cell_wid/column;
    CGFloat toptitle=30;
    for (NSInteger i = 0; i<column; i++) {
        BGLabel * label=[[BGLabel alloc] initWithFrame:CGRectMake(title_width*i, 0, title_width, 30)];
        label.text=arrTitle[i];
//        label.font = [UIFont fontWithName:@"San-Francisco-Text-Regular" size:30];
        label.font = [UIFont systemFontOfSize:14.f];
        label.backgroundColor=[UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1];
        [view addSubview:label];
        
    }
    title_h+=(30+8);
    NSInteger JS_L=0;
    for (NSInteger j = 0; j<line; j++) {
        BGLabel * label_J=[[BGLabel alloc] initWithFrame:CGRectMake(0,toptitle+8+ 30*column*j+8*j, title_width, 30*column)];
        label_J.text=jixing[j];
        label_J.font = [UIFont fontWithName:@"ArialMT"size:28];
        [view addSubview:label_J];
        if(j%2)
        {
             label_J.backgroundColor=[UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1];
        }else
        {
           
            label_J.backgroundColor=[UIColor whiteColor];
        }
//        static NSInteger JS_L=0;
        
        for (NSInteger l = 0; l<column; l++) {
            for (NSInteger k = 0; k<(column-1); k++) {
                    BGLabel * label_K=[[BGLabel alloc] initWithFrame:CGRectMake(title_width*(k+1),title_h, title_width, 30)];
//                    label_K.text=@"k";
                label_K.font = [UIFont systemFontOfSize:14.f];
                if(j%2)
                {
                    label_K.backgroundColor=[UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1];
                }else
                {
                    label_K.backgroundColor=[UIColor whiteColor];
                }
//                NSLog(@"JS_L= %ld",JS_L);
                SKU_class * mode=priceArr[JS_L];
                if(k==0)
                {
                    label_K.text=[NSString stringWithFormat:@"%@",mode.prop_value2];
                    
                }else if (k==1)
                {
                    label_K.text= [NSString stringWithFormat:@"%@",mode.Price];
                   
                }
                    [view addSubview:label_K];
                
                
            if(k==1){
                title_h+=30;
            }
              
            }
            JS_L++;
            
        }
        
        title_h+=8;
    }
    
    return view;
}


/////Dry的 title
-(UIView * )Drylabel_word:(NSInteger)line column:(NSInteger)column titleLabel:(NSArray * )arrTitle width_w:(CGFloat)width left_L:(CGFloat)left Top_r:(CGFloat)top height_z:(CGFloat)height cell_width:(CGFloat)cell_wid Neirong:(NSArray*)arrNeirong
{
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(left, top, width, height)];
    view.backgroundColor=[UIColor clearColor];
    CGFloat title_h=0;
    CGFloat title_width=cell_wid/3;
//    CGFloat toptitle=30;
    for (NSInteger i = 0; i<column; i++) {
        BGLabel * label=[[BGLabel alloc] initWithFrame:CGRectMake(title_width*i, 0, title_width, 30)];
        label.text=arrTitle[i];
        label.font = [UIFont systemFontOfSize:14.f];
        label.backgroundColor=[UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1];
        [view addSubview:label];
        
    }
    title_h+=(30+8);
//    for (NSInteger j = 0; j<line; j++) {
//        BGLabel * label_J=[[BGLabel alloc] initWithFrame:CGRectMake(0,toptitle+8+ 30*column*j+8*j, title_width, 30*column)];
//        label_J.text=@"j";
//        [view addSubview:label_J];
        for (NSInteger l = 0; l<value_Dryarray.count; l++) {
            
            for (NSInteger k = 0; k<2; k++) {
                SKU_Dryclass * mode=value_Dryarray[l];
                BGLabel * label_K=[[BGLabel alloc] initWithFrame:CGRectMake(title_width*(k),title_h, title_width, 30)];
                if(k==0)
                {
                    label_K.text=[NSString stringWithFormat:@"%@",mode.prop_value1];
                }else if (k==1)
                {
                    label_K.text=[NSString stringWithFormat:@"%@",mode.Price];;
                }
                label_K.font = [UIFont systemFontOfSize:14.f];
                if(l%2)
                {
                    label_K.backgroundColor=[UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1];
                }else
                {
                    label_K.backgroundColor=[UIColor whiteColor];
                }
                [view addSubview:label_K];
                if(k==1){
                    title_h+=30;
                }
            }
            title_h+=8;
        }
        
    
//    }
    
    return view;
}


#pragma mark -------- Tableview -------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
//4、设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self->cellTitleArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"PirceListTableViewCell";//这里的cellID就是cell的xib对应的名称
    PirceListTableViewCell *cell = (PirceListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if(nil == cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIndentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.backgroundColor=[UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;///设置无选中状态
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//        NSLog(@"高度：%f",SCREEN_HEIGHT);
//        topView
        
        CGFloat Cell_W=cell.topView.frame.size.width;
        CGFloat Cell_left=cell.topView.frame.origin.x;
        CGFloat Cell_H=cell.topView.bottom+10;
        if(indexPath.section==0)
        {
            cell.title_label_two.text=[NSString stringWithFormat:@"%@",self->cellTitleArr[indexPath.section]];
            [cell.left_btn_two setImage:[UIImage imageNamed:@"icon_laundry"] forState:UIControlStateNormal];
            cell.title_label_two.textColor=[UIColor whiteColor];
            cell.topView_two.backgroundColor = [UIColor colorWithRed:67.0039/255.0 green:225/255.0 blue:231/255.0 alpha:1];
            [self->M_array addObject:@"Price(RM)"];
            [cell addSubview:[self label_word:self->cout_line column:self->M_array.count     titleLabel:self->M_array width_w:Cell_W left_L:Cell_left Top_r:Cell_H height_z:(self->cout_line*3*30+self->cout_line*8) cell_width:Cell_W jixing:self->arr_jixing priceArr:self->value_array]];
//
        }else if (indexPath.section==1)
        {
//            cell.title_label_two.text=@"Dry";
            cell.title_label_two.text=[NSString stringWithFormat:@"%@",self->cellTitleArr[indexPath.section]];
            [cell.left_btn_two setImage:[UIImage imageNamed:@"Honggan"] forState:UIControlStateNormal];
            cell.title_label_two.textColor=[UIColor whiteColor];
            cell.topView_two.backgroundColor = [UIColor colorWithRed:231.996/255.0 green:203.997/255.0 blue:49.9992/255.0 alpha:1];
           [cell addSubview:[self Drylabel_word:0 column:2     titleLabel:@[@"Duration(min)",@"Price(RM)"] width_w:Cell_W left_L:Cell_left Top_r:Cell_H height_z:30*3+8*3+50 cell_width:Cell_W Neirong:self.value_Dryarray]];
            
        }
        
    });
    return cell;
}
//设置间隔高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.f;
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
    view_c.backgroundColor=[UIColor colorWithRed:236/255.0 green:240/255.0 blue:241/255.0 alpha:1];
    return view_c;
}
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0)
    {
//    return 13*30+5*8+45;
        return ((self->cout_line*3)*30+self->cout_line*8)+65+38;
    }else if (indexPath.section==1)
        
    {
        return 30*3+8*3+70;
    }
    return 0;
}

//选中时 调用的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
    }
    
    
    // 在手指离开的那一刻进行反选中
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}



@end
