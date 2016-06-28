//
//  XYFilterToolBar.h
//  Deliver
//
//  Created by 李小亚 on 16/6/22.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYFilterToolBar;

@protocol XYFilterToolBarDelegate <NSObject>

@optional
/**
 *  点击取消按钮
 */
- (void)filterToolBarDidClickCancelBtn:(XYFilterToolBar *)filterToolBar;
/**
 *  点击确认按钮
 */
- (void)filterToolBarDidClickDoneBtn:(XYFilterToolBar *)filterToolBar;

@end

@interface XYFilterToolBar : UIView

@property (nonatomic, weak) id<XYFilterToolBarDelegate> delegate;

@end
