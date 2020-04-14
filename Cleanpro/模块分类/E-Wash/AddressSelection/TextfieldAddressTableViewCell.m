//
//  TextfieldAddressTableViewCell.m
//  Cleanpro
//
//  Created by mac on 2020/3/27.
//  Copyright © 2020 mac. All rights reserved.
//

#import "TextfieldAddressTableViewCell.h"
@interface TextfieldAddressTableViewCell()<UITextViewDelegate>

@end
@implementation TextfieldAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.textView.delegate=self;
//    [self.textView addTarget:self action:@selector(textFieldEditChanged:)  forControlEvents:UIControlEventEditingChanged];
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    NSLog(@"textView=%@",textView.text);
    //    textView.backgroundColor = [UIColor whiteColor];
       if([textView.text isEqualToString:FGGetStringWithKeyFromTable(@"Please enter your address", @"Language")])
          {
              textView.text=@"";
          }
        return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    NSLog(@"textViewDidBeginEditing:");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)textFieldEditChanged:(UITextField*)textField
//{
//        realName = textField.text;
//    if ([self.delegate respondsToSelector:@selector(textViewText:)]) {
//        [self.delegate textViewText:textView.text];
//    }
//}

//UITextView:
//
//实现其delegate方法

- (void)textViewDidChange:(UITextView *)textView

{
        NSLog(@"text:%@", textView.text);
    if ([self.delegate respondsToSelector:@selector(textViewText:)]) {
        [self.delegate textViewText:textView.text];
    }
}


@end
