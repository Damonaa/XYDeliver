//
//  UITextView+XY.m
//  Deliver
//
//  Created by 李小亚 on 16/6/12.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "UITextView+XY.h"

@implementation UITextView (XY)

+ (CGSize)singelTextViewWordSizeWithTextView:(UITextView *)textView{
    NSString *testStr = @"窝";
    
    CGSize fonsize = [testStr sizeWithAttributes:@{NSFontAttributeName:[textView font]}];
    return fonsize;
}

@end
