//
//  XYTemplateViewController.m
//  Deliver
//
//  Created by 李小亚 on 16/6/3.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYTemplateViewController.h"
#import "UIButton+XY.h"

@implementation XYTemplateViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //添加子视图
    [self setupChildView];
}


//添加子视图
- (void)setupChildView{
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"home_toolbar_btn_close_default"] highlightedImage:[UIImage imageNamed:@"home_toolbar_btn_close_pressed"] target:self selcetor:@selector(backToMainVC) controlEvent:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
//    [backBtn setBackgroundColor:[UIColor redColor]];
    backBtn.x = 0;
    backBtn.y = 20;
    
    NSMutableArray *templates = [NSMutableArray array];
    //添加模板样式
    //添加到视图上
    for (int i = 0; i < 9; i ++) {
        NSString *tempName = [NSString stringWithFormat:@"collagel_template%d",i];
        UIImageView *templateIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:tempName]];
        [self.view addSubview:templateIV];
        templateIV.tag = i;
        templateIV.userInteractionEnabled = YES;
        [templates addObject:templateIV];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [templateIV addGestureRecognizer:tap];
    }
    //布局控件位置
    UIImageView *iv0 = templates[0];
    CGFloat ivWH = iv0.width;
    CGFloat margin = (XYScreenWidth - 3 * ivWH) / 4;
    int totalColum = 3;
    for (int i = 0 ; i < 9; i ++) {
        UIImageView *iv = templates[i];
        int column = i % totalColum;
        int row = i / totalColum;
        iv.x = margin + (ivWH + margin) * column;
        iv.y = 85 + (ivWH + margin) * row;
    }
    
}

//选中模板，返回主界面，发出通知，切换模板
- (void)tapImageView:(UITapGestureRecognizer *)gesture{
    UIImageView *iv = (UIImageView *)gesture.view;
    
    XYLog(@"%ld", iv.tag);
    [[NSNotificationCenter defaultCenter] postNotificationName:XYSelectedTemplate object:self userInfo:@{XYSelectedTemplate:[NSNumber numberWithInteger:iv.tag]}];
    
    [self backToMainVC];
}

- (void)backToMainVC{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
