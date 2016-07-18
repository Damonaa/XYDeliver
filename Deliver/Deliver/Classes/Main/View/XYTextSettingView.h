//
//  XYTextSettingView.h
//  Deliver
//
//  Created by 李小亚 on 16/6/20.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef enum{
//    
//}XYAligmentType;

@class XYTextSettingView;

@protocol XYTextSettingViewDelegate <NSObject>

@optional
/**
 *  修改对齐方式
 */
- (void)textSettingView:(XYTextSettingView *)textSettingView didChangeAligment:(NSInteger)aligmentIndex;
/**
 *  常规体 or 粗体
 */
- (void)textSettingView:(XYTextSettingView *)textSettingView didChangeFontSize:(NSInteger)sizeIndex;
/**
 *  简体 or 繁体
 */
- (void)textSettingView:(XYTextSettingView *)textSettingView didChangeFont:(NSInteger)fontIndex;

@end

@interface XYTextSettingView : UIImageView


@property (nonatomic, weak) id<XYTextSettingViewDelegate> delegate;

@end
