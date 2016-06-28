//
//  XYColorBtn.m
//  Deliver
//
//  Created by 李小亚 on 16/5/31.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYColorBtn.h"

@interface XYColorBtn ()

@property (nonatomic, weak) UIButton *btn;

@end

@implementation XYColorBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.image = [UIImage imageNamed:@"anchor"];
        [self setupChildView];
        //添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapColorBtn)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
//添加子控件
- (void)setupChildView{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"COLOR-r_S"] forState:UIControlStateNormal];
    self.btn = btn;
    [self addSubview:btn];
    [btn sizeToFit];
    btn.width *= 0.8;
    btn.height *= 0.8;
    btn.x = (38 - btn.width) / 2;
    btn.y = (38 - btn.height) / 2;
    [btn addTarget:self action:@selector(tapColorBtn) forControlEvents:UIControlEventTouchUpInside];
}
//设置按钮图片
- (void)setBtnImage:(UIImage *)btnImage{
    _btnImage = btnImage;
    [_btn setImage:btnImage forState:UIControlStateNormal];
}
//设置按钮的size
- (void)setBtnSize:(CGFloat)btnSize{
    _btnSize = btnSize;
    
    CGFloat scale = 0.125 * btnSize + 0.175;//btnSize / 5.0;
    _btn.transform = CGAffineTransformMakeScale(scale, scale);
}

//点击颜色按钮
- (void)tapColorBtn{
    if ([self.delegate respondsToSelector:@selector(colorBtnDidClick:)]) {
        [self.delegate colorBtnDidClick:self];
    }
}

@end
