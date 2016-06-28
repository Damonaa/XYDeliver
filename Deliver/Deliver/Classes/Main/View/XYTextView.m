//
//  XYTextView.m
//  Deliver
//
//  Created by 李小亚 on 16/6/5.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYTextView.h"
//#import "UITextView+XY.h"
#import "XYFont.h"
#import "XYFontTool.h"
#import "NSString+XY.h"

@interface XYTextView ()<UITextViewDelegate, UIGestureRecognizerDelegate>
/**
 *  文本的行数
 */
@property (nonatomic, assign) NSInteger rowCount;

/**
 *  新的文本长度
 */
@property (nonatomic, assign) NSUInteger newTextLength;
/**
 *  新的第一响应
 */
@property (nonatomic, assign, getter=isNewFirstRespone) BOOL newFirstRespone;
/**
 *  是否是根据文字长度，自动切换行
 */
//@property (nonatomic, assign, getter=isAutoSwitch) BOOL autoSwitch;


@end

@implementation XYTextView
- (instancetype)init{
    if (self = [super init]) {
        self.delegate = self;
        _rowCount = 0;
        _newTextLength = 0;
        //设置默认字体
        
        CGFloat fontSize = [[[NSUserDefaults standardUserDefaults] objectForKey:XYFontSize] floatValue];
        if (fontSize == 0) {
            fontSize = 15.0;
        }
        
        NSMutableDictionary *attrDic = [NSMutableDictionary dictionary];
        attrDic[NSFontAttributeName] = [UIFont systemFontOfSize:fontSize];
        self.typingAttributes = attrDic;
        
        //长按切换为编辑状态
        self.longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressTextView:)];
        [self addGestureRecognizer:_longPress];
        _longPress.delegate = self;
    }
    return self;
}

//长按textView
- (void)longPressTextView:(UILongPressGestureRecognizer *)gesture{
    self.editable = YES;
    self.selectable = YES;
    [self becomeFirstResponder];

}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
//    return YES;
//}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //如果是竖文本，点击return，放弃第一响应，转到下一个textView
    
//    XYLog(@"！！！！！%ld -- %ld",textView.text.length, _newTextLength);
    
    if (self.isVerticalText) {
        
//        if ([text isEqualToString:@"…"]) {
//            text = @".\n.\n.\n";
//        }
        
        if ([text isEqualToString:@"\n"]) {//换行
//            XYLog(@"return");
            [self resignFirstResponder];
            //响应代理
            if ([self.myDelegate respondsToSelector:@selector(textViewDidResignFirstResponder:)]) {
                [self.myDelegate textViewDidResignFirstResponder:self];
            }
            return NO;
        }
    }
    return YES;
}
//成为第一响应
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    //设置字体以及大小
    if (_textViewResopne) {
        _textViewResopne(self);
    }
    
    self.newFirstRespone = YES;
    [self performSelector:@selector(textViewDidChange:) withObject:textView afterDelay:0.1f];
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
//    [self performSelector:@selector(textViewDidChange:) withObject:textView afterDelay:0.1f];
}
//文本内容变化
- (void)textViewDidChange:(UITextView *)textView{
    //获取当前光标在textView中的point
    CGPoint currentPoint;
    if (textView.selectedTextRange) {
        currentPoint = [textView caretRectForPosition:textView.selectedTextRange.start].origin;
    }else{
        currentPoint = CGPointZero;
    }
    //转换坐标到主视图
    CGPoint supPoint;
    if (self.isVerticalText) {
        supPoint = [self convertPoint:currentPoint toView:self.superview.superview.superview.superview];
    }else{
        supPoint = [self convertPoint:currentPoint toView:self.superview.superview.superview];
    }
    
//    XYLog(@"·····%ld -- %ld",textView.text.length, _newTextLength);
    BOOL isDelete;
    if (textView.text.length < _newTextLength) {//文本长度在减小，在删除文本
        isDelete = YES;
        
    }else{
        isDelete = NO;

    }
    _newTextLength = textView.text.length;
    
#warning undo temp 40？？
    //如果文本输入的高度超出textView，则转到下一个textView
    if (currentPoint.y > self.height - 40) {
        //            [self textView:self shouldChangeTextInRange:NSMakeRange(0, 0) replacementText:@"\n"];
    }

    //发出通知，传递当前的光标的point
    [[NSNotificationCenter defaultCenter] postNotificationName:XYCurrentCursorPosition object:self userInfo:@{XYCurrentCursorPosition:[NSValue valueWithCGPoint:supPoint], XYIsDeleteText:[NSNumber numberWithBool:isDelete], XYIsNewRespone:[NSNumber numberWithBool:self.isNewFirstRespone]}];
    _newFirstRespone = NO;

}
@end
