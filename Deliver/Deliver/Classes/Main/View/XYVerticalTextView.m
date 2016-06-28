//
//  XYVerticalTextView.m
//  Deliver
//
//  Created by 李小亚 on 16/6/8.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYVerticalTextView.h"
#import "XYTextView.h"

@interface XYVerticalTextView ()<XYTextViewDelegate>

@end

@implementation XYVerticalTextView

- (NSMutableArray *)textViews{
    if (!_textViews) {
        _textViews = [NSMutableArray array];
    }
    return _textViews;
}

- (instancetype)init{
    if (self = [super init]) {
        
        _newWidth = 0.0;
        _singleWidth = 0.0;
        
        //长按切换为编辑状态
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressTextView:)];
        [self addGestureRecognizer:longPress];
    }
    return self;
}

//长按textView
- (void)longPressTextView:(UILongPressGestureRecognizer *)gesture{

    CGPoint loc = [gesture locationInView:gesture.view];
    
    for (XYTextView *textView in self.textViews) {
        textView.editable = YES;
        textView.selectable = YES;
    }
    
    //反向循环遍历
    if (_textViews.count > 0) {
        for (NSInteger i = _textViews.count; i > 0; i --) {
            XYTextView *textView = _textViews[i - 1];
            //检测长按的点是否是在textView或者附近
            CGRect tempRect = CGRectMake(textView.x - _singleWidth / 4, textView.y, textView.width + _singleWidth / 2, textView.height);
            if (CGRectContainsPoint(tempRect, loc) && textView.text.length > 0) {
                //最近的点击，且有文字的变为第一响应
                [textView becomeFirstResponder];
                break;
            }else if(textView.text.length > 0){//寻找到最后一个有文字的变为第一响应
                [textView becomeFirstResponder];
                break;
            }else{
                textView = _textViews[0];
                [textView becomeFirstResponder];
            }
        }
    }
    
    
}

#pragma mark - 添加文本输入栏
- (void)setSingleWidth:(float)singleWidth{
    _singleWidth = singleWidth;
    
    CGFloat margin = singleWidth / 2;//间隔
    NSInteger totalColumn = floorf(self.width/ (singleWidth * 1.5 + margin));
    for (NSInteger i = 0; i < totalColumn; i ++) {
        XYTextView *textView = [self setupOneTextView];
        [self.textViews addObject:textView];
    }
}
#pragma mark - 添加一个textView
- (XYTextView *)setupOneTextView{
    XYTextView *textView = [[XYTextView alloc] init];
    textView.verticalText = YES;
    textView.myDelegate = self;
    textView.textViewResopne = ^(XYTextView *textView){
        if (_verticalTV) {
            _verticalTV(self);
        }
    };
    [textView removeGestureRecognizer:textView.longPress];
    
    textView.tag = self.textViews.count + 1;
    //宽
    CGFloat finalWidth = _newWidth == 0.0 ? _singleWidth : _newWidth;
    textView.width = finalWidth * 1.5;
    [self addSubview:textView];
//    textView.backgroundColor = [UIColor orangeColor];
    return textView;
}
#pragma mark - 改变字体的size
- (void)setNewWidth:(float)newWidth{
    _newWidth = newWidth;
    [self layoutSubviews];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat finalWidth = _newWidth == 0.0 ? _singleWidth : _newWidth;
//    XYLog(@"before --- %ld -- finalWidth %f", _textViews.count, finalWidth);
    int i = 1;
    CGFloat margin = finalWidth / 5;
    CGFloat tvWidth = finalWidth * 1.5;
    CGFloat tvHeight = self.height - margin * 2;
    for (XYTextView *textView in self.textViews) {
        textView.width = tvWidth;
        textView.height = tvHeight;
        CGFloat x = self.width - (margin + textView.width) * i;
        textView.x = x;
        textView.y = margin;
        
        
//        XYLog(@"%f", x);
        //如果textView超出范围，则隐藏
        textView.hidden = x < 0 ? YES : NO;

        if (i == _textViews.count) {//最后一个
            //空出的空间可以放置新的textView的个数
            int spaceCount = x / (margin + tvWidth);
            if (spaceCount > 0) {
                for (int i = 0; i < spaceCount; i ++) {
                    XYTextView *newTV = [self setupOneTextView];
                    XYTextView *firstTV = _textViews[0];
                    newTV.font = [UIFont fontWithName:firstTV.font.familyName size:firstTV.font.pointSize];
                    newTV.height = tvHeight;
                    newTV.y = margin;
                    newTV.x = x - (margin + tvWidth) * (i + 1);
                    [self.textViews addObject:newTV];
                }
            }
            
        }
        
        i ++;
    }
    
//    XYLog(@"after --- %ld", _textViews.count);
}

#pragma mark - XYTextViewDelegate
//切换第一响应的textView
- (void)textViewDidResignFirstResponder:(XYTextView *)textView{
    NSInteger tvTag = textView.tag;

    XYTextView *newTextView;
    //textView的tag从1开始
    for (NSInteger i = tvTag; i < _textViews.count + 1; i ++) {
        if (i == _textViews.count) {
            i = 0;
        }
        newTextView = self.textViews[i];
        if (!newTextView.isHidden) {
            break;
        }
    }
    
    [newTextView becomeFirstResponder];
}
@end
