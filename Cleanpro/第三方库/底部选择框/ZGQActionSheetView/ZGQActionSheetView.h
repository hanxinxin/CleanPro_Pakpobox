//
//  ZGQActionSheetView.h
//  BBLive
//
//  Created by 小丁 on 2017/7/5.
//  Copyright © 2017年 车互帮. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZGQActionSheetView;

@protocol ZGQActionSheetViewDelegate <NSObject>

@optional

/**
 点击某个选项时执行

 @param sheetView sheetView
 @param index 点击的选项下标
 @param text 选中的文字
 */
- (void)ZGQActionSheetView:(ZGQActionSheetView *)sheetView didSelectRowAtIndex:(NSInteger )index text:(NSString *)text;

/**
 取消选择时执行

 @param sheetView sheetView
 */
- (void)ZGQActionSheetViewdidCancelSelectFrom:(ZGQActionSheetView *)sheetView;

@end


@interface ZGQActionSheetView : UIView

- (instancetype) init NS_UNAVAILABLE;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;


/**
 是否展示示例图片
 */
@property (nonatomic, assign) BOOL showSampleView;
/**
 示例图本名
 */
@property (nonatomic,   copy) NSString *sampleImageFileName;
/**
 示例图片说明
 */
@property (nonatomic,   copy) NSString *sampleTitleName;
/**
 最大展现数量 默认为5个
 */
@property (nonatomic, assign) NSInteger maxShowCount;
/**
 字体大小 默认为17
 */
@property (nonatomic, assign) CGFloat fontSize;
/**
 选项文字颜色
 */
@property (nonatomic, strong) UIColor *optionColor;
/**
 选项高度 默认为56
 */
@property (nonatomic, assign) CGFloat optionHeight;
/**
 取消按钮上方缝隙 默认为5
 */
@property (nonatomic, assign) CGFloat gap;
/**
 是否需要取消按钮 默认为YES
 */
@property (nonatomic, assign) BOOL needCancelButton;

/**
 取消按钮文案 默认为“取消”
 */
@property (nonatomic, copy) NSString *cancelTitle;
/**
 选项数组
 */
@property (nonatomic, strong) NSArray <NSString *>*options;
/**
 代理
 */
@property (nonatomic, weak) id<ZGQActionSheetViewDelegate>delegate;

/**
 根据数组创建一个多项选择视图

 @param options 选项数组
 @return 多项选择视图
 */
- (instancetype)initWithOptions:(NSArray<NSString *>*)options;

/**
 根据数组创建一个多项选择视图(带选择和取消回调)

 @param options 选项数组
 @param completion 选择回调
 @param cancelBlock 取消回调
 @return 多项选择视图
 */
- (instancetype)initWithOptions:(NSArray<NSString*>*)options
                     completion:(void(^)(NSInteger index))completion
                         cancel:(void(^)(void))cancelBlock;



/**
 展现视图
 */
- (void)show;

@end
