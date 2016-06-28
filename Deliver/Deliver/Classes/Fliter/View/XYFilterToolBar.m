//
//  XYFilterToolBar.m
//  Deliver
//
//  Created by 李小亚 on 16/6/22.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYFilterToolBar.h"
#import "UIButton+XY.h"

@interface XYFilterToolBar ()

/**
 *  取消按钮
 */
@property (nonatomic, weak) UIButton *cancelBtn;

/**
 *  确定按钮
 */
@property (nonatomic, weak) UIButton *doneBtn;
@end

@implementation XYFilterToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupChildView];
        self.backgroundColor = [UIColor colorWithRed:0.243 green:0.210 blue:0.058 alpha:1.000];
    }
    return self;
}
//添加子控件
- (void)setupChildView{
//    self.cancelBtn
     UIButton *cancelBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"home_toolbar_btn_close_default"] highlightedImage:[UIImage imageNamed:@"home_toolbar_btn_close_pressed"] target:self selcetor:@selector(cancelBtnClick) controlEvent:UIControlEventTouchUpInside];
    self.cancelBtn = cancelBtn;
    [self addSubview:_cancelBtn];
    
//    self.doneBtn
    UIButton *doneBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"all_top_btn_done_default"] highlightedImage:[UIImage imageNamed:@"all_top_btn_done_pressed"] target:self selcetor:@selector(doneBtnClick) controlEvent:UIControlEventTouchUpInside];
    self.doneBtn = doneBtn;
    [self addSubview:_doneBtn];
    
    
}
//布局子控件位置
- (void)layoutSubviews{
    [super layoutSubviews];
    _cancelBtn.x = 10;
    _cancelBtn.y = (self.height - _cancelBtn.height) / 2;
    
    _doneBtn.x = self.width - _doneBtn.width - 10;
    _doneBtn.y = (self.height - _cancelBtn.height) / 2;
}

#pragma mark - 取消按钮
- (void)cancelBtnClick{
    if ([self.delegate respondsToSelector:@selector(filterToolBarDidClickCancelBtn:)]) {
        [self.delegate filterToolBarDidClickCancelBtn:self];
    }
}
#pragma mark - 确认按钮
- (void)doneBtnClick{
    if ([self.delegate respondsToSelector:@selector(filterToolBarDidClickDoneBtn:)]) {
        [self.delegate filterToolBarDidClickDoneBtn:self];
    }
}


@end
