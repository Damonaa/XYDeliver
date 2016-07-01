//
//  XYToolBarView.m
//  XYWeiBoThird
//
//  Created by 李小亚 on 16/4/28.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYKeyboardToolBarView.h"
#import "UIImage+XY.h"
@implementation XYKeyboardToolBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupChildView];
        self.backgroundColor = [UIColor colorWithRed:0.079 green:0.063 blue:0.073 alpha:1.000];
//        self.image = [UIImage stretchableImage:[UIImage imageNamed:@"compose_toolbar_background"]];
        self.userInteractionEnabled = YES;
    }
    return self;
}
//添加子控件，按钮
- (void)setupChildView{
    //键盘
    [self setupOneBtnWithNormalImage:[UIImage imageNamed:@"text_tool_btn_keyboard_default"] highlightedImage:[UIImage imageNamed:@"text_tool_btn_keyboard_default"]];
    
    //字体
    [self setupOneBtnWithNormalImage:[UIImage imageNamed:@"tool_btn_text_default"] highlightedImage:[UIImage imageNamed:@"tool_btn_text_default"]];
    //颜色
    [self setupOneBtnWithNormalImage:[UIImage imageNamed:@"collage_one_menu_color_default"] highlightedImage:[UIImage imageNamed:@"collage_one_menu_color_default"]];
    //设置
    [self setupOneBtnWithNormalImage:[UIImage imageNamed:@"share_btn_setting_default"] highlightedImage:[UIImage imageNamed:@"share_btn_setting_default"]];
    
    //完成
    [self setupOneBtnWithNormalImage:[UIImage imageNamed:@"all_top_btn_done_default"] highlightedImage:[UIImage imageNamed:@"all_top_btn_done_default"]];
}
//添加一个按钮
- (void)setupOneBtnWithNormalImage:(UIImage *)normalImage highlightedImage:(UIImage *)highlightedImage{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = self.subviews.count;
    [self addSubview:btn];
    [btn setImage:normalImage forState:UIControlStateNormal];
    [btn setImage:highlightedImage forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(clickToolBarBtn:) forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat btnW = self.width / self.subviews.count;
    CGFloat btnH = 35;
    
    int i = 0;
    for (UIButton *btn in self.subviews) {
        btn.x = i * btnW;
        btn.y = 0;
        btn.width = btnW;
        btn.height = btnH;
        i ++;
    }
    
}

//响应点击 事件
- (void)clickToolBarBtn:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(toolBarView:didClickBtnAtIndex:)]) {
        [self.delegate toolBarView:self didClickBtnAtIndex:btn.tag];
    }
}

+ (void)hiden{
    
}
@end
