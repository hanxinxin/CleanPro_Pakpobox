//
//  PassWordTextView.m
//  TextFieldTest
//
//  Created by Tpphha on 15/12/16.
//  Copyright © 2015年 Tpphha. All rights reserved.
//

#import "TPPasswordTextView.h"

@interface TPPasswordTextView ()

// 主要作用是为了 展示 收齐 键盘
@property(nonatomic, weak) UITextField *textField;

//泛型约束   数组里面只能是  TextField
@property (nonatomic, strong) NSMutableArray<UITextField *> *dataSource;

@end

@implementation TPPasswordTextView

#pragma mark ==== 懒加载
- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UITextField *textField = [[UITextField alloc] initWithFrame:self.bounds];
        
        textField.hidden = YES;
        
        // 数字键盘
        textField.keyboardType = UIKeyboardTypeNumberPad;
        // 添加  监听  TF 变化时执行
        [textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
        
        [self addSubview:textField];
        
        self.textField = textField;
        
        //   隐藏  键盘
        self.autoHideKeyboard = YES;
    }
    return self;
}



//  set方法
- (void)setElementCount:(NSInteger)elementCount {
    _elementCount = elementCount;
    if (elementCount <= 0) {
        return;
    }
    
    if (self.dataSource.count > 0) {
        
        //block 遍历  方法
        [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //单独取消一个
            [NSObject cancelPreviousPerformRequestsWithTarget:obj selector:@selector(removeFromSuperview) object:nil];
        
        }];
        
        // 类似于 for循环，但有效率高于for循环 makeObjectsPerformSelector:类似于NSNotifation机制，并发的执行同一件事，不能像for循环那样区别对待
     
        [self.dataSource makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        [self.dataSource removeAllObjects];
    }
    //  循环创建 TextField
    for (int i = 0; i < self.elementCount; i++)
    {
        UITextField *pwdTextField = [[UITextField alloc] init];
        
        pwdTextField.enabled = NO;
        
        pwdTextField.textAlignment = NSTextAlignmentCenter;//居中
        
        pwdTextField.secureTextEntry = YES;//设置密码模式
        //  不响应用户点击   仅做展示用    不挡住  self.textField 相应的事件
        pwdTextField.userInteractionEnabled = NO;
        
        // 插入一个pwdTextField ,并且在 self.textField 下面
        [self insertSubview:pwdTextField belowSubview:self.textField];
        
        [self.dataSource addObject:pwdTextField];
    }
}




- (void)setElementMargin:(CGFloat)elementMargin {
    _elementMargin = elementMargin;
//    会默认调用layoutSubViews
    [self setNeedsLayout];
//   自动调用drawRect方法
    [self setNeedsDisplay];
}



- (void)clearPassword {
    self.textField.text = nil;
    [self textChange:self.textField];
}


//  显示  键盘
- (void)showKeyboard {
    [self.textField becomeFirstResponder];
}


//  回收键盘
- (void)hideKeyboard {
    [self.textField resignFirstResponder];
}


#pragma mark - 文本框内容改变
- (void)textChange:(UITextField *)textField {
    NSString *password = textField.text;
    if (password.length > self.elementCount) {
        return;
    }
    
    for (int i = 0; i < self.dataSource.count; i++)
    {
        UITextField *pwdTextField= [self.dataSource objectAtIndex:i];
        if (i < password.length) {
            NSString *pwd = [password substringWithRange:NSMakeRange(i, 1)];
            pwdTextField.text = pwd;
        } else {
            pwdTextField.text = nil;
        }
        
    }
    
    if (password.length == self.dataSource.count)
    {
        if (self.autoHideKeyboard) {
            [self hideKeyboard];//隐藏键盘
        }
    }
    
    !self.passwordDidChangeBlock ? : self.passwordDidChangeBlock(textField.text);
}



//子视图 重新布局
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = (self.bounds.size.width - (self.elementCount - 1) * self.elementMargin) / self.elementCount;
    CGFloat h = self.bounds.size.height;
    for (NSUInteger i = 0; i < self.dataSource.count; i++) {
        UITextField *pwdTextField = [self.dataSource objectAtIndex:i];
        
        //  x 起始点
        x = i * (w + self.elementMargin);
        pwdTextField.frame = CGRectMake(x, y, w, h);
    }
}




//  点击  弹出  键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self showKeyboard];
}



//  绘图操作   画矩形
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    //  获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self.backgroundColor set];
    
    //   矩形
    CGContextFillRect(context, rect);
    
    //  设置线条样式
    CGContextSetLineCap(context, kCGLineCapSquare);
    
    // 设置 线条 粗细宽度
    CGContextSetLineWidth(context, self.elementBorderWidth);
    
    //  设置颜色
    CGContextSetStrokeColorWithColor(context, self.elementBorderColor.CGColor);
    
    //  设置当前填充颜色的图形上下文,使用CGColor
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    
    CGContextBeginPath(context);
    if (self.elementMargin != 0) {
        for (UITextField *textField in self.dataSource) {
            CGRect rect = CGRectInset(textField.frame, self.elementBorderWidth, self.elementBorderWidth);
            CGFloat left = rect.origin.x;
            CGFloat right = rect.origin.x + rect.size.width;
            CGFloat top = rect.origin.y;
            CGFloat bottom = rect.origin.y + rect.size.height;
            
            //  开始画线   起始点
            CGContextMoveToPoint(context, left, top);
            //  顶部
            CGContextAddLineToPoint(context, right, top);
            // 右侧竖线
            CGContextAddLineToPoint(context, right, bottom);
            // 底部
            CGContextAddLineToPoint(context, left, bottom);
//            封闭当前线路   连接起始点
            CGContextClosePath(context);
        }
    }
    else {
        CGPoint leftTopPoint, rightTopPoint, leftBottomPoint, rightBottomPoint;
        for (NSUInteger i = 0; i < self.dataSource.count; i++) {
            
            UITextField *textField = [self.dataSource objectAtIndex:i];
            
            CGRect rect = CGRectInset(textField.frame, self.elementBorderWidth, self.elementBorderWidth);
            
            CGFloat left = rect.origin.x;
            
            CGFloat right = rect.origin.x + rect.size.width;
            
            CGFloat top = rect.origin.y;
            
            CGFloat bottom = rect.origin.y + rect.size.height;
            
            //  开始画线
            CGContextMoveToPoint(context, left, top);
            // 画直线
            CGContextAddLineToPoint(context, left, bottom);
            
            CGContextClosePath(context);
            if (self.dataSource.count - 1 == i) {
                CGContextMoveToPoint(context, right, top);
                CGContextAddLineToPoint(context, right, bottom);
                CGContextClosePath(context);
                rightTopPoint = CGPointMake(right, top);
                rightBottomPoint = CGPointMake(right, bottom);
            }else if (0 == i) {
                leftTopPoint = CGPointMake(left, top);
                leftBottomPoint = CGPointMake(left, bottom);
            }
        }
        
        CGContextMoveToPoint(context, leftTopPoint.x, leftTopPoint.y);
        CGContextAddLineToPoint(context, rightTopPoint.x, rightTopPoint.y);
        CGContextClosePath(context);
        
        CGContextMoveToPoint(context, leftBottomPoint.x, leftBottomPoint.y);
        CGContextAddLineToPoint(context, rightBottomPoint.x, rightBottomPoint.y);
        CGContextClosePath(context);
    }
    CGContextStrokePath(context);
}


@end
