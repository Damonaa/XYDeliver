//
//  XYScrollView.h
//  Deliver
//
//  Created by 李小亚 on 16/5/31.
//  Copyright © 2016年 李小亚. All rights reserved.
// 自定义UIView，添加自有的属性，内部放置UIScrolloView

#import <UIKit/UIKit.h>

@class XYTextView, XYVerticalTextView, XYScrollView, XYImageView;

typedef enum{
    TapLocationTop,
    TapLocationLeft,
    TapLocationBottom,
    TapLocationRight,
    TapLocationMiddle
}TapLocation;

/**
 *  定义当前选择的XYScrollViewBlock
 */
typedef void(^CurrentSVBlock)(XYScrollView *scrollView);

@interface XYScrollView : UIView

/**
 *  点击的位置
 */
@property (nonatomic, assign) TapLocation tapLocation;
/**
 *  添加图片
 */
@property (nonatomic, strong) UIImage *image;

/**
 *  展示文字
 */
@property (nonatomic, weak) XYTextView *textView;
/**
 *  展示竖文本的视图
 */
@property (nonatomic, weak) XYVerticalTextView *verticalTextView;
/**
 *  展示图片
 */
@property (nonatomic, weak) XYImageView *imageView;
/**
 *  当前选择的XYScrollViewBlock
 */
@property (nonatomic, copy) CurrentSVBlock currentSV;

@end
