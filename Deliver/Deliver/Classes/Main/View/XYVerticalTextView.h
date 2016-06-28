//
//  XYVerticalTextView.h
//  Deliver
//
//  Created by 李小亚 on 16/6/8.
//  Copyright © 2016年 李小亚. All rights reserved.
// 书写竖文本

#import <UIKit/UIKit.h>

@class XYVerticalTextView;

typedef void(^VerticalTVBlock)(XYVerticalTextView *verticalTV);

@interface XYVerticalTextView : UIView
/**
 *  一个文字的宽
 */
@property (nonatomic, assign) float singleWidth;


/**
 *  存放全部的文字输入框
 */
@property (nonatomic, strong) NSMutableArray *textViews;
/**
 *  选择当前的竖文本视图的block
 */
@property (nonatomic, copy) VerticalTVBlock verticalTV;


@property (nonatomic, assign) float newWidth;

@end
