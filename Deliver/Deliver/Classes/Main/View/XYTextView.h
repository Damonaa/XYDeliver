//
//  XYTextView.h
//  Deliver
//
//  Created by 李小亚 on 16/6/5.
//  Copyright © 2016年 李小亚. All rights reserved.
//展示添加的文字

#import <UIKit/UIKit.h>

@class XYTextView;

@protocol XYTextViewDelegate <NSObject>

@optional
- (void)textViewDidResignFirstResponder:(XYTextView *)textView;

@end
/**
 *  定义 成为第一响应的block
 */
typedef void(^TextViewResponeBlock)(XYTextView *textView);

@interface XYTextView : UITextView
/**
 *  是否是竖文本， 默认为NO
 */
@property (nonatomic, assign, getter=isVerticalText) BOOL verticalText;

@property (nonatomic, weak) id<XYTextViewDelegate> myDelegate;
/**
 *  长按textView的手势
 */
@property (nonatomic, strong)  UILongPressGestureRecognizer *longPress;
/**
 *  成为第一响应的block
 */
@property (nonatomic, copy) TextViewResponeBlock textViewResopne;



@end
