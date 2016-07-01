//
//  XYShareTool.h
//  Deliver
//
//  Created by 李小亚 on 16/6/29.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYShareTool : NSObject
/**
 *  分享图片到第三方应用
 *
 *  @param name           应用名称
 *  @param image          分享的图片
 *  @param text           分享的文字
 *  @param viewController 当前的控制器
 */
+ (void)shareToAppWingName:(NSString *)name image:(UIImage *)image text:(NSString *)text viewController:(UIViewController *)viewController;
@end
