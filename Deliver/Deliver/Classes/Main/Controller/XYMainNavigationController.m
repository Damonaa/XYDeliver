//
//  XYMainNavigationController.m
//  XYWeiBoThird
//
//  Created by 李小亚 on 16/4/24.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYMainNavigationController.h"
//#import "UIBarButtonItem+Category.h"
//#import "XYTabBar.h"

@interface XYMainNavigationController ()<UINavigationControllerDelegate>

@property (nonatomic, strong) id popDelegate;

@end

@implementation XYMainNavigationController


+ (void)initialize{
    //设置标题属性
    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedIn:self, nil];
    
    NSMutableDictionary *attrNav = [NSMutableDictionary dictionary];
    attrNav[NSFontAttributeName] = [UIFont systemFontOfSize:18];
    attrNav[NSForegroundColorAttributeName] = [UIColor blackColor];
    [navBar setTitleTextAttributes:attrNav];
    
    //设置UIBarButtonItem属性
//    UIBarButtonItem *barBtnItem = [UIBarButtonItem appearanceWhenContainedIn:self, nil];
//    
//    NSMutableDictionary *attrBar = [NSMutableDictionary dictionary];
//    attrBar[NSForegroundColorAttributeName] = [UIColor colorWithWhite:0.386 alpha:1.000];
//    attrBar[NSFontAttributeName] = [UIFont systemFontOfSize:15];
//    [barBtnItem setTitleTextAttributes:attrBar forState:UIControlStateNormal];
}


-(id)initWithRootViewController:(UIViewController *)rootViewController{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        //设置透明的导航条
        CGRect frame = self.navigationBar.frame;
        UIView *alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height+20)];
        alphaView.backgroundColor = [UIColor clearColor];
        [self.view insertSubview:alphaView belowSubview:self.navigationBar];
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"bigShadow.png"] forBarMetrics:UIBarMetricsCompact];
        self.navigationBar.layer.masksToBounds = YES;

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //手势代理
    self.delegate = self;
    self.popDelegate = self.interactivePopGestureRecognizer.delegate;
    self.interactivePopGestureRecognizer.delegate = nil;
}



//设置手势代理
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (viewController == self.viewControllers[0]) {//是第一个控制器。则还原手势代理
        self.interactivePopGestureRecognizer.delegate = self.popDelegate;
    }else{
        self.interactivePopGestureRecognizer.delegate = nil;
    }
}
@end
