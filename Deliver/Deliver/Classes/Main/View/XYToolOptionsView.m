//
//  XYToolOptionsView.m
//  Deliver
//
//  Created by 李小亚 on 16/5/30.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYToolOptionsView.h"

@interface XYToolOptionsView ()
/**
 *  主按钮，点击显示菜单
 */
@property (nonatomic, weak) UIButton *mainBtn;
/**
 存放所有的菜单按钮
 */
@property (nonatomic, strong) NSMutableArray *menus;

@end

@implementation XYToolOptionsView

//懒加载
- (NSMutableArray *)menus{
    if (!_menus) {
        _menus = [NSMutableArray array];
    }
    return _menus;
}

//初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupChildView];
    }
    return self;
}
//添加子控件
- (void)setupChildView{
    
    //主按钮
    UIButton *mainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.mainBtn = mainBtn;
    [self addSubview:mainBtn];
    mainBtn.frame = CGRectMake(0, 0, 48, 48);
    [mainBtn setBackgroundImage:[UIImage imageNamed:@"small_main_menu"] forState:UIControlStateNormal];
    [mainBtn addTarget:self action:@selector(clickMain) forControlEvents:UIControlEventTouchUpInside];
    //添加菜单按钮
    [self addMenuButtonWithBGName:@"tool_btn_template__default" hlImageName:nil tag:1 title:@"模板"];
    [self addMenuButtonWithBGName:@"tool_btn_bore_rectangle__default" hlImageName:nil tag:2 title:@"有边框"];
    [self addMenuButtonWithBGName:@"tool_btn_scale_1_1default" hlImageName:@"tool_btn_scale_btn_1_1pressed" tag:3 title:@"1:1"];
    [self addMenuButtonWithBGName:@"tool_btn_effects_pressed" hlImageName:@"tool_btn_effects_default" tag:4 title:@"滤镜"];
//    [self addMenuButtonWithBGName:@"tool_btn_text_default" hlImageName:nil tag:5 title:@"字体"];
    
    [self bringSubviewToFront:mainBtn];
}

//创建一个按钮
- (void)addMenuButtonWithBGName:(NSString *)name hlImageName:(NSString *)hlImageName tag:(NSInteger)tag title:(NSString *)title{
    UIButton *menu = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:menu];
    menu.frame = self.mainBtn.frame;
    if (name) {
       [menu setBackgroundImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    }
    if (hlImageName) {
        [menu setBackgroundImage:[UIImage imageNamed:hlImageName] forState:UIControlStateHighlighted];
    }
    [menu setTitle:title forState:UIControlStateNormal];
    [menu setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    menu.titleLabel.font = [UIFont systemFontOfSize:13];
    menu.tag = tag;
    [self.menus addObject:menu];
    
    [menu addTarget:self action:@selector(menuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

//响应主按钮点击事件
- (void)clickMain{
    //是否是原始状态
    self.showMenu = CGAffineTransformIsIdentity(self.mainBtn.transform);
    [self showMenu:self.isShowMenu];
    if ([self.delegate respondsToSelector:@selector(toolOptionViewDidClickMainBtn:)]) {
        [self.delegate toolOptionViewDidClickMainBtn:self];
    }
}

- (void)showMenu:(BOOL)show{
    
    for (UIButton *btn in self.menus) {

        CAAnimationGroup *group = [CAAnimationGroup animation];
        
        CAKeyframeAnimation * move = [CAKeyframeAnimation animation];
        move.keyPath = @"position";
        
        //按钮的最终位置
        CGFloat singleW = (self.width - 55 ) / (_menus.count + 1);
        CGFloat btnX = singleW * btn.tag + self.mainBtn.center.x;
        CGPoint lastPositon = CGPointMake(btnX, self.mainBtn.center.y);
        //按钮位移的位置
        NSValue *value1 = [NSValue valueWithCGPoint:self.mainBtn.center];
        NSValue *value2 = [NSValue valueWithCGPoint:CGPointMake(btnX * 0.5, lastPositon.y)];
        NSValue *value3 = [NSValue valueWithCGPoint:CGPointMake(btnX * 1.1, lastPositon.y)];
        NSValue *value4 = [NSValue valueWithCGPoint:lastPositon];
        
        CAKeyframeAnimation *rotate = [CAKeyframeAnimation animation];
        rotate.keyPath = @"transform.rotation";
        
        if (show) {//显示
            move.values = @[value1, value2, value3, value4];
            rotate.values = @[@0, @(M_PI * 2), @(M_PI * 4), @(M_PI * 2)];
            btn.center = lastPositon;
            
            [UIView animateWithDuration:0.5 animations:^{
                //        此方法从原始的状态上进行变换
                self.mainBtn.transform = CGAffineTransformMakeRotation(M_PI_4);
            }];
            
        }else{//隐藏
            move.values = @[value4, value3,value2, value1];
            rotate.values = @[@0, @(M_PI * 2), @0, @(-M_PI * 2)];
            btn.center = self.mainBtn.center;
            
            [UIView animateWithDuration:0.5 animations:^{
                //        此方法从原始的状态上进行变换
                self.mainBtn.transform = CGAffineTransformIdentity;
            }];
            
        }
        group.duration = XYShowBtnDuration;
        group.animations = @[move, rotate];
        group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [btn.layer addAnimation:group forKey:nil];
        
    }
    
}

- (void)menuBtnClick:(UIButton *)btn{
    
    UIImage *normalImage;
    UIImage *hlImage;
    
    if (btn.tag == 2) {//边框
        if ([btn.currentTitle isEqualToString:@"有边框"]) {
            [btn setTitle:@"无边框" forState:UIControlStateNormal];
            normalImage = [UIImage imageNamed:@"tool_btn_bord_none__default"];
        }else{
            [btn setTitle:@"有边框" forState:UIControlStateNormal];
            normalImage = [UIImage imageNamed:@"tool_btn_bore_rectangle__default"];
        }
        [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
        [btn setBackgroundImage:hlImage forState:UIControlStateHighlighted];
        //发出通知，切换模板边框
        [[NSNotificationCenter defaultCenter] postNotificationName:XYSwitchBorderStyle object:self userInfo:@{XYSwitchBorderStyle: btn.currentTitle}];
        
    }else if (btn.tag == 3){//比例
        if ([btn.currentTitle isEqualToString:@"1:1"]) {
            [btn setTitle:@"4:3" forState:UIControlStateNormal];
            normalImage = [UIImage imageNamed:@"tool_btn_scale_btn_4_3default"];
            hlImage = [UIImage imageNamed:@"tool_btn_scale_btn_4_3pressed"];
        }else if ([btn.currentTitle isEqualToString:@"4:3"]){
            [btn setTitle:@"3:4" forState:UIControlStateNormal];
            normalImage = [UIImage imageNamed:@"tool_btn_scale_btn_3_4default"];
            hlImage = [UIImage imageNamed:@"tool_btn_scale_btn_3_4pressed"];
        }else{
            [btn setTitle:@"1:1" forState:UIControlStateNormal];
            normalImage = [UIImage imageNamed:@"tool_btn_scale_btn_1_1pressed"];
            hlImage = [UIImage imageNamed:@"tool_btn_scale_btn_1_1pressed"];
        }
        [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
        [btn setBackgroundImage:hlImage forState:UIControlStateHighlighted];
        //发出修改模板比例的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:XYTemplateChangeScale object:self userInfo:@{XYTemplateChangeScale:btn.currentTitle}];
    }else if (btn.tag == 1){
        
    }
    
    
    //响应代理时间
    if ([self.delegate respondsToSelector:@selector(toolOptionsView:didClickBtn:)]) {
        [self.delegate toolOptionsView:self didClickBtn:btn];
    }
}



@end
