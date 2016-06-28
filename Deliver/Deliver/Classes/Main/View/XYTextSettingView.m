//
//  XYTextSettingView.m
//  Deliver
//
//  Created by 李小亚 on 16/6/20.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYTextSettingView.h"

@interface XYTextSettingView ()
/**
 *  对齐方式标签
 */
@property (nonatomic, weak) UILabel *alignmnetLabel;
/**
 *  左对齐按钮
 */
@property (nonatomic, weak) UIButton *alignLeft;
/**
 *  居中对齐按钮
 */
@property (nonatomic, weak) UIButton *alignMiddle;
/**
 *  右对齐按钮
 */
@property (nonatomic, weak) UIButton *alignRight;
/**
 *  字体类型标签
 */
@property (nonatomic, weak) UILabel *fontTypeLabel;
/**
 *  常规字体
 */
@property (nonatomic, weak) UIButton *normalFont;
/**
 *  加粗字体
 */
@property (nonatomic, weak) UIButton *boldFont;
/**
 *  简体字
 */
@property (nonatomic, weak) UIButton *simplifiedFont;
/**
 *  繁体字
 */
@property (nonatomic, weak) UIButton *traditionalFont;


@property (nonatomic, weak) UIButton *selectedAlignBtn;
@property (nonatomic, weak) UIButton *selectedFontSizeBtn;
@property (nonatomic, weak) UIButton *selectedFontBtn;
@end

@implementation XYTextSettingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupChildView];
    }
    return self;
}
//添加子控件
- (void)setupChildView{
    //对齐方式
    self.alignmnetLabel = [self setupOneLabelWithText:@"对齐方式"];
    self.alignLeft = [self setupOneAlignWithTitle:@"左对齐" action:@selector(clickAligmentBtn:)];
    _alignLeft.tag = 0;
    _alignLeft.selected = YES;
    self.selectedAlignBtn = _alignLeft;
    
    self.alignMiddle = [self setupOneAlignWithTitle:@"居中" action:@selector(clickAligmentBtn:)];
    _alignMiddle.tag = 1;
    self.alignRight = [self setupOneAlignWithTitle:@"右对齐" action:@selector(clickAligmentBtn:)];
    _alignRight.tag = 2;
    
    //字体类型
    self.fontTypeLabel = [self setupOneLabelWithText:@"字体样式"];
    self.normalFont = [self setupOneAlignWithTitle:@"常规体" action:@selector(clickFontTypeSizeBtn:)];
    _normalFont.tag = 3;
    self.boldFont = [self setupOneAlignWithTitle:@"粗体" action:@selector(clickFontTypeSizeBtn:)];
    _boldFont.tag = 4;
    //选中
    _normalFont.selected = YES;
    self.selectedFontSizeBtn = _normalFont;
    
    self.simplifiedFont = [self setupOneAlignWithTitle:@"简体" action:@selector(clickFontTypeBtn:)];
    _simplifiedFont.tag = 5;
    self.traditionalFont = [self setupOneAlignWithTitle:@"繁体" action:@selector(clickFontTypeBtn:)];
    _traditionalFont.tag = 6;
    _simplifiedFont.selected = YES;
    self.selectedFontBtn = _simplifiedFont;
    
}

- (UILabel *)setupOneLabelWithText:(NSString *)text{
    UILabel *alignmnetLabel = [[UILabel alloc] init];
    [self addSubview:alignmnetLabel];
    alignmnetLabel.text = text;
    alignmnetLabel.font = [UIFont systemFontOfSize:15];
    [alignmnetLabel sizeToFit];
    
    return alignmnetLabel;
}

- (UIButton *)setupOneAlignWithTitle:(NSString *)title action:(SEL)action{
    UIButton *alignLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    [alignLeft setTitle:title forState:UIControlStateNormal];
    [alignLeft setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [alignLeft setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [self addSubview:alignLeft];
    
    [alignLeft sizeToFit];
    
    alignLeft.layer.cornerRadius = 2;
    alignLeft.layer.masksToBounds = YES;
    alignLeft.layer.borderColor = [UIColor blackColor].CGColor;
    alignLeft.layer.borderWidth = 1.0;
    
    [alignLeft addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return alignLeft;
}

//布局子控件位置
- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat cellH = (self.height - 40 ) / 4;
    CGFloat margin = 20;
    _alignmnetLabel.x = margin;
    _alignmnetLabel.y = margin;
    
    _alignLeft.x = margin;
    _alignLeft.y = margin + cellH;
    
    _alignMiddle.x = margin + CGRectGetMaxX(_alignLeft.frame);
    _alignMiddle.y = _alignLeft.y;
    
    _alignRight.x = margin + CGRectGetMaxX(_alignMiddle.frame);
    _alignRight.y = _alignLeft.y;
    
    _fontTypeLabel.x = margin;
    _fontTypeLabel.y = margin + cellH * 2;
    
    _normalFont.x = margin;
    _normalFont.y = margin + cellH * 3;
    
    _boldFont.x = margin + CGRectGetMaxX(_normalFont.frame);
    _boldFont.y = _normalFont.y;
    
    _simplifiedFont.x = margin + CGRectGetMaxX(_boldFont.frame) + 10;
    _simplifiedFont.y = _normalFont.y;
    
    _traditionalFont.x = margin + CGRectGetMaxX(_simplifiedFont.frame);
    _traditionalFont.y = _normalFont.y;
    
    
}


//处理对齐方式按钮的点击
- (void)clickAligmentBtn:(UIButton *)btn{
    _selectedAlignBtn.selected = NO;
    btn.selected = YES;
    _selectedAlignBtn = btn;
    
    if ([self.delegate respondsToSelector:@selector(textSettingView:didChangeAligment:)]) {
        [self.delegate textSettingView:self didChangeAligment:btn.tag];
    }
}
//常规体 or 粗体
- (void)clickFontTypeSizeBtn:(UIButton *)btn{
    _selectedFontSizeBtn.selected = NO;
    btn.selected = YES;
    _selectedFontSizeBtn = btn;
    
    if ([self.delegate respondsToSelector:@selector(textSettingView:didChangeFontSize:)]) {
        [self.delegate textSettingView:self didChangeFontSize:btn.tag];
    }
}
//点击处理字体类型的按钮 简体 or 繁体
- (void)clickFontTypeBtn:(UIButton *)btn{
    _selectedFontBtn.selected = NO;
    btn.selected = YES;
    _selectedFontBtn = btn;
    
    if ([self.delegate respondsToSelector:@selector(textSettingView:didChangeFont:)]) {
        [self.delegate textSettingView:self didChangeFont:btn.tag];
    }
}
@end
