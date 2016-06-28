//
//  XYColorView.h
//  Deliver
//
//  Created by 李小亚 on 16/5/30.
//  Copyright © 2016年 李小亚. All rights reserved.
//  展示选择颜色和线宽

#import <UIKit/UIKit.h>

@class XYColorView;
@protocol XYColorViewDelegate <NSObject>
/**
 *  选中颜色
 *
 *  @param colorView XYColorView
 *  @param color     颜色
 */
- (void)colorView:(XYColorView *)colorView selcetedColor:(UIColor *)color mainBtn:(UIButton *)mainBtn;
/**
 *  选中线宽
 *
 *  @param colorView XYColorView
 *  @param width     线宽 size
 */
- (void)colorView:(XYColorView *)colorView selcetedWidth:(CGFloat)width mainBtn:(UIButton *)mainBtn;

@end

@interface XYColorView : UIView
/**
 *  是否展示子按钮， 默认为NO
 */
@property (nonatomic, assign, getter=isShowBtns) BOOL showBtns;

@property (nonatomic, weak) id<XYColorViewDelegate> delegate;



/**
 *  是否是在是设置文字的颜色和size， 默认为NO
 */
@property (nonatomic, assign, getter=isSettingText) BOOL settingText;

/**
 *  展示或者隐藏视图
 */
- (void)showColorAndWidth:(BOOL)show;

- (void)hidenSelf;
@end
