//
//  UIButton+XY.m
//  XYNetEasyNews
//
//  Created by 李小亚 on 16/5/15.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "UIButton+XY.h"

@implementation UIButton (XY)

/**
 *  初始化创建按钮
 *  @param target          目标对象
 *  @param selector        方法
 *  @param event           响应方式
 *  @param normalImage     正常状态下的图片
 *  @param hightlightImage 高亮图片
 *  @return 按钮
 */
+ (instancetype)buttonWithNormalImage:(UIImage *)normalImage highlightedImage:(UIImage *)highlightedImage target:(id)target selcetor:(SEL)selector controlEvent:(UIControlEvents)event{
    UIButton *btn = [self buttonWithNormalImage:normalImage hightlightImage:highlightedImage target:target selcetor:selector controlEvent:UIControlEventTouchUpInside title:nil];
    return btn;
}


/**
 *  初始化创建按钮
 *
 *  @param normalImage     正常状态下的图片
 *  @param hightlightImage 高亮图片
 *  @param target          目标对象
 *  @param selector        方法
 *  @param event           响应方式
 *  @param title           按钮标题
 *
 *  @return 按钮
 */
+ (instancetype)buttonWithNormalImage:(UIImage *)normalImage hightlightImage:(UIImage *)hightlightedImage target:(id)target selcetor:(SEL)selector controlEvent:(UIControlEvents)event title:(NSString *)title{
    
    UIButton *btn = [self buttonWithType:UIButtonTypeCustom];
    if (normalImage) {
        [btn setImage:normalImage forState:UIControlStateNormal];
    }
    if (hightlightedImage) {
        [btn setImage:hightlightedImage forState:UIControlStateHighlighted];
    }
    if (title) {
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    
    [btn addTarget:target action:selector forControlEvents:event];
    [btn sizeToFit];
    
    return btn;
    
}

/**
 *  初始化创建按钮
 *
 *  @param target          目标对象
 *  @param selector        方法
 *  @param event           响应方式
 *  @param title           按钮标题
 *
 *  @return 按钮
 */
+ (instancetype)buttonWithTarget:(id)target selcetor:(SEL)selector controlEvent:(UIControlEvents)event title:(NSString *)title{
    UIButton *btn = [self buttonWithType:UIButtonTypeCustom];
    if (title) {
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [btn setTitleColor:XYTextColor forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    
    [btn addTarget:target action:selector forControlEvents:event];
    [btn sizeToFit];
    btn.width += 20;
    return btn;
}
@end
