//
//  TextfieldAddressTableViewCell.h
//  Cleanpro
//
//  Created by mac on 2020/3/27.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol TextfieldAddressTableViewCellDelegate <NSObject>
@optional

- (void)textViewText:(NSString*)text;
@end
@interface TextfieldAddressTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, weak) id<TextfieldAddressTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
