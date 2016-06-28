//
//  XYToolBarView.h
//  XYWeiBoThird
//
//  Created by 李小亚 on 16/4/28.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYKeyboardToolBarView;

@protocol XYKeyboardToolBarViewDelegate <NSObject>

- (void)toolBarView:(XYKeyboardToolBarView *)toolBarView didClickBtnAtIndex:(NSInteger)index;
@end

@interface XYKeyboardToolBarView : UIImageView

@property (nonatomic, weak) id<XYKeyboardToolBarViewDelegate> delegate;
@end
