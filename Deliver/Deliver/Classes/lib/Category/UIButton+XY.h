//
//  UIButton+XY.h
//  XYNetEasyNews
//
//  Created by 李小亚 on 16/5/15.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (XY)

/**
 *  初始化创建按钮，带有图片，无文字
 *  @param target          目标对象
 *  @param selector        方法
 *  @param event           响应方式
 *  @param normalImage     正常状态下的图片
 *  @param hightlightImage 高亮图片
 *  @return 按钮
 */
+ (instancetype)buttonWithNormalImage:(UIImage *)normalImage highlightedImage:(UIImage *)highlightedImage target:(id)target selcetor:(SEL)selector controlEvent:(UIControlEvents)event;


/**
 *  初始化创建按钮，带有图片，文字
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
+ (instancetype)buttonWithNormalImage:(UIImage *)normalImage hightlightImage:(UIImage *)hightlightedImage target:(id)target selcetor:(SEL)selector controlEvent:(UIControlEvents)event title:(NSString *)title;

/**
 *  初始化创建按钮,带文字，不带图片
 *
 *  @param target          目标对象
 *  @param selector        方法
 *  @param event           响应方式
 *  @param title           按钮标题
 *
 *  @return 按钮
 */
+ (instancetype)buttonWithTarget:(id)target selcetor:(SEL)selector controlEvent:(UIControlEvents)event title:(NSString *)title;

@end
