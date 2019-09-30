//
//  ViewOrder.h
//  Cleanpro
//
//  Created by mac on 2019/3/28.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ViewOrder : UIView

-(void)setLabelText_OrderNo:(NSString*)str;
-(void)setLabelText_Location:(NSString*)str;
-(void)setLabelText_MachineNo:(NSString*)str;
@property (weak, nonatomic) IBOutlet UILabel *OrderNo;
@property (weak, nonatomic) IBOutlet UILabel *Location;
@property (weak, nonatomic) IBOutlet UILabel *MachineNo;

@end

NS_ASSUME_NONNULL_END
