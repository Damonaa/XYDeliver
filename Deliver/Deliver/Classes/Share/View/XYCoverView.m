//
//  XYCoverView.m
//  Weibo
//
//  Created by 李小亚 on 16/3/18.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYCoverView.h"
#import "UIButton+XY.h"


@interface XYCoverView ()
/**
 *  朋友圈分享
 */
@property (nonatomic, weak) UIButton *wechatBtn;;
/**
 *  QQ空间分享
 */
@property (nonatomic, weak) UIButton *zoneBtn;
/**
 *  微博分享
 */
@property (nonatomic, weak) UIButton *weiboBtn;
/**
 *  保存到相册
 */
@property (nonatomic, weak) UIButton *albumBtn;

/**
 *  存放全部的按钮
 */
@property (nonatomic, strong) NSMutableArray *shareBtns;
@end

@implementation XYCoverView

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.599];
        [self setupChildView];
    }
    return self;
}

- (void)setupChildView{
    UIButton *wechatBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"share_platform_wechattimeline"] highlightedImage:nil target:self selcetor:@selector(shareBtnClick:) controlEvent:UIControlEventTouchUpInside];
    wechatBtn.tag = 0;
    self.wechatBtn = wechatBtn;
    [self addSubview:wechatBtn];
    
    UIButton *zoneBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"share_platform_qzone"] highlightedImage:nil target:self selcetor:@selector(shareBtnClick:) controlEvent:UIControlEventTouchUpInside];
    self.zoneBtn = zoneBtn;
    zoneBtn.tag = 1;
    [self addSubview:zoneBtn];
    
    UIButton *weiboBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"share_platform_sina"] highlightedImage:nil target:self selcetor:@selector(shareBtnClick:) controlEvent:UIControlEventTouchUpInside];
    self.weiboBtn = weiboBtn;
    weiboBtn.tag = 2;
    [self addSubview:weiboBtn];
    
    UIButton *albumBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"store_home_cell_nophotos"] highlightedImage:nil target:self selcetor:@selector(shareBtnClick:) controlEvent:UIControlEventTouchUpInside];
    albumBtn.tag = 3;
    self.albumBtn = albumBtn;
    [self addSubview:albumBtn];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat btnY = XYScreenHeight / 2 - 10;
    CGFloat margin = 20;
    
    CGFloat singleW = (XYScreenWidth - margin * 2) / 4;
    
    for (UIButton *btn in self.subviews) {
        btn.y = btnY;
        btn.x = margin + singleW * btn.tag;
    }
}

+ (instancetype)show{
    XYCoverView *coverView = [[XYCoverView alloc] init];
    [XYKeyWindow addSubview:coverView];
    return coverView;
}

#pragma mark - 点击空白区域
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(coverViewClick:)]) {
        [self.delegate coverViewClick:self];
    }
}

#pragma mark - 分享按钮的点击
- (void)shareBtnClick:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(coverView:didClickShareBtnWithIndex:)]) {
        [self.delegate coverView:self didClickShareBtnWithIndex:button.tag];
    }
}


#pragma mark - 隐藏，移除
+ (void)hiden{
    for (UIView *view in XYKeyWindow.subviews) {
        if ([view isKindOfClass:self]) {
            [view removeFromSuperview];
        }
    }
}
@end
