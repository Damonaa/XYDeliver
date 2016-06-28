//
//  XYColorBtn.h
//  Deliver
//
//  Created by 李小亚 on 16/5/31.
//  Copyright © 2016年 李小亚. All rights reserved.
// 显示在主界面的颜色展示按钮，点击显示选择颜色以及线宽

#import <UIKit/UIKit.h>

@class XYColorBtn;

@protocol XYColorBtnDelegate <NSObject>

- (void)colorBtnDidClick:(XYColorBtn *)colorBtn;

@end

@interface XYColorBtn : UIImageView

@property (nonatomic, weak) id<XYColorBtnDelegate> delegate;
/**
 *  按钮图片
 */
@property (nonatomic, strong) UIImage *btnImage;
/**
 *  按钮size
 */
@property (nonatomic, assign) CGFloat btnSize;


@end
