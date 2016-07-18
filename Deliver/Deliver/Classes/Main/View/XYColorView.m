//
//  XYColorView.m
//  Deliver
//
//  Created by 李小亚 on 16/5/30.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYColorView.h"
#import "UIButton+XY.h"

@interface XYColorView ()
/**
 *  全部颜色按钮
 */
@property (nonatomic, strong) NSMutableArray *colorBtns;

/**
 *  全部线宽按钮
 */
@property (nonatomic, strong) NSMutableArray *widthBtns;

/**
 *  主按钮，控制按钮的显示隐藏
 */
@property (nonatomic, weak) UIButton *mainBtn;

@end

@implementation XYColorView

#pragma mark - 懒加载
- (NSMutableArray *)colorBtns{
    if (!_colorBtns) {
        _colorBtns = [NSMutableArray array];
        
//        black，white， pink， blue， green, yellow, orange, red
        [self addOneColorBtnWithImageName:@"COLOR-bc_S"];
        [self addOneColorBtnWithImageName:@"COLOR-w_S"];
        [self addOneColorBtnWithImageName:@"COLOR-p_S"];
        [self addOneColorBtnWithImageName:@"COLOR-b_S"];
        [self addOneColorBtnWithImageName:@"COLOR-g_S"];
        [self addOneColorBtnWithImageName:@"COLOR-y_S"];
        [self addOneColorBtnWithImageName:@"COLOR-o_S"];
        [self addOneColorBtnWithImageName:@"COLOR-r_S"];
    }
    return _colorBtns;
}


- (NSMutableArray *)widthBtns{
    if (!_widthBtns) {
        _widthBtns = [NSMutableArray array];
        //添加5个表示线宽的按钮
        for (int i = 1; i < 6; i ++) {
            UIButton *widthBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d",i]] highlightedImage:nil target:self selcetor:@selector(selectedWidth:) controlEvent:UIControlEventTouchUpInside];
            [self addSubview:widthBtn];
            widthBtn.tag = i;
            [_widthBtns addObject:widthBtn];
        }
    }
    return _widthBtns;
}
//向颜色按钮数组中添加按钮
- (void)addOneColorBtnWithImageName:(NSString *)imageName{
    UIButton *blackBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:imageName] highlightedImage:nil target:self selcetor:@selector(selectedColor:) controlEvent:UIControlEventTouchUpInside];
    [self addSubview:blackBtn];
    blackBtn.tag = _colorBtns.count;
    [_colorBtns addObject:blackBtn];
}

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupChildView];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
//添加子控件
- (void)setupChildView{
    UIButton *mainBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"COLOR-r_S"] highlightedImage:nil target:self selcetor:@selector(mainBtnClick) controlEvent:UIControlEventTouchUpInside];
    [self addSubview:mainBtn];
    self.mainBtn = mainBtn;
    
    mainBtn.hidden = YES;
    
    CGFloat margin = 5;
    mainBtn.x = self.width - mainBtn.width - margin;
    mainBtn.y = self.height - mainBtn.height - margin;
    //设置子按钮的frame
    for (UIButton *btn in self.colorBtns) {
        btn.frame = mainBtn.frame;
    }
    for (UIButton *btn in self.widthBtns) {
        btn.frame = mainBtn.frame;
    }
    
    [self bringSubviewToFront:mainBtn];
}

#pragma mark - 主按钮的点击
- (void)mainBtnClick{
    self.showBtns = !self.showBtns;
//    [self showColorAndWidth:self.isShowBtns];
    [self hidenSelf];
}
#pragma mark - 展示or隐藏 颜色以及线宽按钮
- (void)showColorAndWidth:(BOOL)show{
    CGFloat margin = 5;
    //展示颜色按钮
    for (UIButton *btn in self.colorBtns) {
    //按钮的最终位置
        CGFloat btnY = _mainBtn.center.y - (btn.width + margin) * (btn.tag + 1);
        CGPoint lastPositon = CGPointMake(_mainBtn.center.x, btnY);
        [self moveBtn:btn lastPosition:lastPositon show:show];
    }
    
    //展示线宽按钮
    for (UIButton *btn in self.widthBtns) {
        
        //按钮的最终位置
        CGFloat btnX = _mainBtn.center.x - (btn.width + margin) * btn.tag;
        CGPoint lastPositon = CGPointMake(btnX, _mainBtn.center.y);
        [self moveBtn:btn lastPosition:lastPositon show:show];
    }
}
//动画移动按钮位置
- (void)moveBtn:(UIButton *)btn lastPosition:(CGPoint)lastPosition show:(BOOL)show{
    CAKeyframeAnimation *move = [CAKeyframeAnimation animation];
    move.keyPath = @"position";
    //按钮位移的位置
    NSValue *value1 = [NSValue valueWithCGPoint:self.mainBtn.center];
    NSValue *value2 = [NSValue valueWithCGPoint:lastPosition];
    
    if (show) {//显示
        move.values = @[value1, value2];
        btn.center = lastPosition;
    }else{//隐藏
        move.values = @[value2, value1];
        btn.center = self.mainBtn.center;
    }
    move.duration = XYShowBtnDuration;
    move.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [btn.layer addAnimation:move forKey:nil];
}

#pragma mark - 颜色选择按钮
- (void)selectedColor:(UIButton *)btn{
//    [self hidenSelf];
    //black，white， pink， blue， green, yellow, orange, red
    UIColor *selectedColor;
    switch (btn.tag) {
        case 0:
            selectedColor = [UIColor blackColor];
            break;
        case 1:
            selectedColor = [UIColor whiteColor];
            break;
        case 2:
            selectedColor = [UIColor colorWithRed:0.969 green:0.000 blue:0.322 alpha:1.000];
            break;
        case 3:
            selectedColor = [UIColor blueColor];
            break;
        case 4:
            selectedColor = [UIColor greenColor];
            break;
        case 5:
            selectedColor = [UIColor yellowColor];
            break;
        case 6:
            selectedColor = [UIColor orangeColor];
            break;
        case 7:
            selectedColor = [UIColor redColor];
            break;
            
        default:
            selectedColor = [UIColor blackColor];
            break;
    }
    
    [self.mainBtn setImage:btn.currentImage forState:UIControlStateNormal];
    
    //发出颜色切换的通知
    if (!self.isSettingText) {//不是在编辑文本
        [[NSNotificationCenter defaultCenter] postNotificationName:XYSwitchSelectedColor object:self userInfo:@{XYSwitchSelectedColor:selectedColor}];
    }else{//编辑文本
        if ([self.delegate respondsToSelector:@selector(colorView:selcetedColor:mainBtn:)]) {
            [self.delegate colorView:self selcetedColor:selectedColor mainBtn:_mainBtn];
        }
    }
    
}
#pragma mark - 线宽选择按钮
- (void)selectedWidth:(UIButton *)btn{
//    [self hidenSelf];
    CGFloat scale = btn.tag / 5.0;
    _mainBtn.transform = CGAffineTransformMakeScale(scale, scale);
    
    //发出线宽的变化的通知
    if (!self.isSettingText) {//不是在编辑文本
        [[NSNotificationCenter defaultCenter] postNotificationName:XYSwitchSelectedWidth object:self userInfo:@{XYSwitchSelectedWidth:[NSNumber numberWithInteger:btn.tag]}];
    }else{//编辑文本
        if ([self.delegate respondsToSelector:@selector(colorView:selcetedWidth: mainBtn:)]) {
            [self.delegate colorView:self selcetedWidth:btn.tag mainBtn:_mainBtn];
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hidenSelf];
}
//隐藏自身
- (void)hidenSelf{
    [self showColorAndWidth:NO];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:XYShowBtnDuration];
}
@end
