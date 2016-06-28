//
//  XYToolOptionsView.h
//  Deliver
//
//  Created by 李小亚 on 16/5/30.
//  Copyright © 2016年 李小亚. All rights reserved.
//  底部工具栏，一些对拼图容器的设置 模板，边框，比例，滤镜

#import <UIKit/UIKit.h>

@class XYToolOptionsView;

@protocol XYToolOptionsViewDelegate <NSObject>

- (void)toolOptionsView:(XYToolOptionsView *)toolView didClickBtn:(UIButton *)btn;
- (void)toolOptionViewDidClickMainBtn:(XYToolOptionsView *)toolView;

@end

@interface XYToolOptionsView : UIView

/**
 *  是否显示菜单，默认NO
 */
@property (nonatomic, assign, getter=isShowMenu) BOOL showMenu;


@property (nonatomic, weak) id<XYToolOptionsViewDelegate> delegate;
/**
 *  展示或者隐藏菜单
 *
 *  @param show 
 */
- (void)showMenu:(BOOL)show;

@end
