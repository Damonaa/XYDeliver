//
//  XYContainerView.m
//  Deliver
//
//  Created by 李小亚 on 16/5/29.
//  Copyright © 2016年 李小亚. All rights reserved.
//


#define XYMinScrollView 40

//#warning 修改边界线的位置

//#define XYBoundaryMarignLine 7

#import "XYContainerView.h"
#import "XYScrollView.h"
#import "XYMenuView.h"
#import "XYLine.h"
#import "XYImageView.h"
#import "XYTextView.h"
#import "XYVerticalTextView.h"
#import "UITextView+XY.h"
#import "XYFont.h"
#import "XYFontTool.h"

//模板边框样式，有无边框
typedef enum{
    TemplateBorderStyleNone,
    TemplateBorderStyleRectangle
}TemplateBorderStyle;

@interface XYContainerView ()
/**
 *  存放全部的scrollView模块
 */
@property (nonatomic, strong) NSMutableArray *scrollViews;
/**
 *  模板边框样式
 */
@property (nonatomic, assign) TemplateBorderStyle templateBorderStyle;

/**
 *  存放全部的需要画线的
 */
@property (nonatomic, strong) NSMutableArray *lines;
/**
 *  当前选中的宽度
 */
@property (nonatomic, assign) CGFloat currentWidth;
/**
 *  当前选中的颜色
 */
@property (nonatomic, strong) UIColor *currentColor;

/**
 *  选取的第一张图的View的index
 */
//@property (nonatomic, assign) NSInteger firstIVIndex;



@property (nonatomic, strong) XYScrollView *scrollView1;
@property (nonatomic, strong) XYScrollView *scrollView2;
@property (nonatomic, strong) XYScrollView *scrollView3;

/**
 *  存放（XYMatchImage）？？？？
 */
//@property (nonatomic, strong) NSMutableArray *matchItems;
/**
 *  键盘的frame
 */
@property (nonatomic, assign) CGRect keyboardLastRect;

@end

@implementation XYContainerView

@synthesize images = _images;

#pragma mark - 懒加载
- (NSMutableArray *)scrollViews{
    if (!_scrollViews) {
        _scrollViews = [NSMutableArray array];
    }
    return _scrollViews;
}
- (XYMenuView *)menuView{
    if (!_menuView) {
        XYMenuView *menuView = [[XYMenuView alloc] init];
        _menuView = menuView;
        _menuView.bounds = CGRectMake(0, 0, 150, 150);
        [self addSubview:_menuView];
        _menuView.hidden = YES;
    }
    
    return _menuView;
}

- (NSMutableArray *)lines{
    if (!_lines) {
        _lines = [NSMutableArray array];
    }
    return _lines;
}

- (NSMutableArray *)emptySVs{
    if (!_emptySVs) {
        _emptySVs = [NSMutableArray array];
    }
    return _emptySVs;
}
- (NSMutableArray *)images{
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.995 green:0.996 blue:0.985 alpha:1.000];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panScroll:)];
        [self addGestureRecognizer:pan];
        //模板比例
        self.templateScale = TemplateScaleOneToOne;
        self.templateBorderStyle = TemplateBorderStyleRectangle;
        self.currentWidth = 2;
        self.currentColor = [UIColor blackColor];
//        self.templateIndex = 1;
    
        
        self.scrollView1 = [self addOneScrollView];
        self.scrollView2 = [self addOneScrollView];
        self.scrollView3 = [self addOneScrollView];
        
//        _scrollView1.backgroundColor = [UIColor colorWithRed:1.000 green:0.500 blue:0.000 alpha:0.466];
//        _scrollView2.backgroundColor = [UIColor colorWithRed:1.000 green:0.000 blue:0.000 alpha:0.366];
//        _scrollView3.backgroundColor = [UIColor colorWithRed:1.000 green:0.000 blue:1.000 alpha:0.509];
        
        //监听通知，模板的模型改变
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(templateScaleChange:) name:XYTemplateChangeScale object:nil];
        //模板的边框样式改变
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchBorderStyle:) name:XYSwitchBorderStyle object:nil];
        //监听颜色发生的变化
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchSelectedColor:) name:XYSwitchSelectedColor object:nil];
        //监听选中的线宽的变化
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchSelectedWidth:) name:XYSwitchSelectedWidth object:nil];
        //监听模板模型的变化
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedTemplate:) name:XYSelectedTemplate object:nil];
        //监听点击scroll的菜单选中
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedMenu:) name:XYSelectedMenu object:nil];
        //监听字体的修改
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFont:) name:XYChangeFont object:nil];
        
    }
    return self;
}

//布局子控件位置
- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (_layoutCV) {
        _layoutCV();
    }
    
}
#pragma mark - 根据选择的模板的类型，创建并且布局UIscrollView
- (void)setTemplateIndex:(NSInteger)templateIndex{
    _templateIndex = templateIndex;

    switch (templateIndex) {
        case 0:
            [self templateZero];
            break;
        case 1:
            [self templateOne];
            break;
        case 2:
            [self templateTwo];
            break;
        case 3:
            [self templateThree];
            break;
        case 4:
            [self templateFour];
            break;
        case 5:
            [self templateFive];
            break;
        case 6:
            [self templateSix];
            break;
        case 7:
            [self templateSeven];
            break;
        case 8:
            [self templateEight];
            break;
            
        default:
            [self templateOne];
            break;
    }
    
    
    //计算全部的需要画的线
    [self calculateAllLines];
    
    //重新设置imageview的frame以及scrollView的缩放比
    [self resetImageViewFrame];
    
}
//重新设置 XYScrollView imageview textView的frame
- (void)resetImageViewFrame{
    for (XYScrollView *sv in self.subviews) {
        
        if ([sv isMemberOfClass:[XYScrollView class]]) {
            [sv layoutSubviews];
            UIScrollView *sview = sv.subviews[0];
            
            sview.zoomScale = 1.0;
            
            XYImageView *iv = sview.subviews[0];
            iv.frame = sview.bounds;
//            XYLog(@"%@ -- %@",sview, iv);
        }
    }
}

- (void)templateZero{
    [self addSubview:_scrollView1];
    [_scrollView2 removeFromSuperview];
    [_scrollView3 removeFromSuperview];
    
    self.scrollView1.frame = self.bounds;
}
- (void)templateOne{
    
    [self addSubview:_scrollView1];
    [self addSubview:_scrollView2];
    [_scrollView3 removeFromSuperview];
    
    _scrollView1.frame = CGRectMake(0, 0, self.width, self.height / 2);
    _scrollView2.frame = CGRectMake(0, self.height / 2, self.width,self.height / 2);
}

- (void)templateTwo{
    [self addSubview:_scrollView1];
    [self addSubview:_scrollView2];
    [_scrollView3 removeFromSuperview];
    
    
    _scrollView1.frame = CGRectMake(0, 0, self.width / 2, self.height);
    _scrollView2.frame = CGRectMake(self.width / 2, 0, self.width / 2, self.height);
}
- (void)templateThree{
    
    [self addSubview:_scrollView1];
    [self addSubview:_scrollView2];
    [self addSubview:_scrollView3];
    
    _scrollView1.frame = CGRectMake(0, 0, self.width / 2, self.height / 2);
    _scrollView2.frame = CGRectMake(0, self.height / 2, self.width / 2, self.height / 2);
    _scrollView3.frame = CGRectMake(self.width / 2, 0, self.width / 2, self.height);
}
- (void)templateFour{
    
    
    [self addSubview:_scrollView1];
    [self addSubview:_scrollView2];
    [self addSubview:_scrollView3];
    
    _scrollView1.frame = CGRectMake(0, 0, self.width, self.height / 2);
    _scrollView2.frame = CGRectMake(0, self.height / 2, self.width / 2, self.height / 2);
    _scrollView3.frame = CGRectMake(self.width / 2, self.height / 2, self.width / 2, self.height / 2);
}
- (void)templateFive{
    
    [self addSubview:_scrollView1];
    [self addSubview:_scrollView2];
    [self addSubview:_scrollView3];
    
    _scrollView1.frame = CGRectMake(0, 0, self.width / 2, self.height);
    _scrollView2.frame = CGRectMake(self.width / 2, 0, self.width / 2, self.height  / 2);
    _scrollView3.frame = CGRectMake(self.width / 2, self.height / 2, self.width / 2, self.height / 2);
}
- (void)templateSix{
    
    [self addSubview:_scrollView1];
    [self addSubview:_scrollView2];
    [self addSubview:_scrollView3];
    
    _scrollView1.frame = CGRectMake(0, 0, self.width / 2, self.height / 2);
    _scrollView2.frame = CGRectMake(self.width / 2, 0, self.width / 2, self.height / 2);
    _scrollView3.frame = CGRectMake(0, self.height / 2, self.width, self.height / 2);
}
- (void)templateSeven{
    
    [self addSubview:_scrollView1];
    [self addSubview:_scrollView2];
    [self addSubview:_scrollView3];
    
    _scrollView1.frame = CGRectMake(0, 0, self.width, self.height / 3);
    _scrollView2.frame = CGRectMake(0, self.height / 3, self.width, self.height / 3);
    _scrollView3.frame = CGRectMake(0, self.height * 2 / 3, self.width, self.height / 3);
}
- (void)templateEight{
    
    [self addSubview:_scrollView1];
    [self addSubview:_scrollView2];
    [self addSubview:_scrollView3];
    
    _scrollView1.frame = CGRectMake(0, 0, self.width / 3, self.height);
    _scrollView2.frame = CGRectMake(self.width / 3, 0, self.width / 3, self.height);
    _scrollView3.frame = CGRectMake(self.width * 2 / 3, 0, self.width / 3, self.height);
}
//创建一个UIscrollView
- (XYScrollView *)addOneScrollView{
    XYScrollView *scroll = [[XYScrollView alloc] init];
    scroll.tag = self.scrollViews.count;
    [self.scrollViews addObject:scroll];
//    scroll.delegate = self;
    //添加点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScroll:)];
    tap.numberOfTapsRequired = 1;
    [scroll addGestureRecognizer:tap];
    
    scroll.currentSV = ^(XYScrollView *scrollView){
        self.currentSV = scrollView;
    };
    
    return scroll;
}

#pragma mark - 计算全部的需要画的线
- (void)calculateAllLines{
    //首先移除数组中的全部数据
    [self.lines removeAllObjects];

    CGFloat edgeW = _currentWidth / 2;
    //添加线
    CGFloat margin = XYBoundaryMarignLine;
    //四条线 自身边框
    //左
    XYLine *line1 = [[XYLine alloc] init];
    line1.startPoint = CGPointMake(edgeW + margin, edgeW + margin);
    line1.endPoint = CGPointMake(edgeW + margin, self.height - margin);
    [_lines addObject:line1];
    
    //上
    XYLine *line2 = [[XYLine alloc] init];
    line2.startPoint = CGPointMake(0 + margin, edgeW + margin);
    line2.endPoint = CGPointMake(self.width - margin, edgeW + margin);
    [_lines addObject:line2];
    
    //下
    XYLine *line3 = [[XYLine alloc] init];
    line3.startPoint = CGPointMake(0 + margin, self.height - edgeW - margin);
    line3.endPoint = CGPointMake(self.width - margin, self.height - edgeW - margin);
    [_lines addObject:line3];
    
    //右
    XYLine *line4 = [[XYLine alloc] init];
    line4.startPoint = CGPointMake(self.width - edgeW - margin, self.height - edgeW - margin);
    line4.endPoint = CGPointMake(self.width - edgeW - margin, edgeW + margin);
    [_lines addObject:line4];
    
    //计算内部的线
    for (XYScrollView *sv in self.subviews) {
        if ([sv isKindOfClass:[XYScrollView class]]) {
            
            if (sv.x == 0 && sv.width == self.width && sv.y != 0) {
                //top
                [self insertTopLineWithScroll:sv edgeW:edgeW];
            }else if (CGRectGetMaxY(sv.frame) + 1 > self.height && sv.y != 0 && sv.x == 0) {
                //top //由于屏幕尺寸不同，除以3 不能正常
                [self insertTopLineWithScroll:sv edgeW:edgeW];
            }else if (CGRectGetMaxX(sv.frame) == self.width && sv.x != 0 && sv.y != 0) {
                //top
                [self insertTopLineWithScroll:sv edgeW:edgeW];
            }
            
            if (sv.y == 0 && sv.height == self.height && sv.x != 0) {
                //left
                [self insertLeftLineWithScroll:sv edgeW:edgeW];
            }else if (CGRectGetMaxX(sv.frame) == self.width && sv.x != 0 && sv.y == 0) {
                //left
                [self insertLeftLineWithScroll:sv edgeW:edgeW];
            }else if (CGRectGetMaxY(sv.frame) + 1 > self.height && sv.y != 0 && sv.x != 0) {
                //left
                [self insertLeftLineWithScroll:sv edgeW:edgeW];
            }
        }
    }
    
    [self setNeedsDisplay];
}

//top
- (void)insertTopLineWithScroll:(XYScrollView *)sv edgeW:(CGFloat)edgeW{
    XYLine *line = [[XYLine alloc] init];
    //起点
    CGFloat startX;
    if (sv.x == 0) {//sv的左边与容器View左边一致
        startX = XYBoundaryMarignLine + edgeW / 2;
    }else{
        startX = sv.x - edgeW / 2;
    }
    line.startPoint = CGPointMake(startX, sv.y + edgeW / 2);
    //终点
    CGFloat endX;
    if (CGRectGetMaxX(sv.frame) + XYBoundaryMarignLine + 1 > self.width) {//靠右边缘
        endX = CGRectGetMaxX(sv.frame) - XYBoundaryMarignLine - edgeW;
    }else{
        endX = CGRectGetMaxX(sv.frame) - edgeW / 2;
    }
    line.endPoint = CGPointMake(endX, sv.y + edgeW / 2);
    [_lines addObject:line];
}
//left
- (void)insertLeftLineWithScroll:(XYScrollView *)sv edgeW:(CGFloat)edgeW{
    XYLine *line = [[XYLine alloc] init];
    //起点
    CGFloat startY;
    if (CGRectGetMaxY(sv.frame) + XYBoundaryMarignLine + 1 > self.height) {//靠底部
        if (sv.y == 0) {//顶部与容器View的顶部一致
            startY = XYBoundaryMarignLine;
        }else{
            startY = sv.y;
        }
    }else{
        startY = sv.y + XYBoundaryMarignLine;
    }    line.startPoint = CGPointMake(sv.x  - edgeW / 2, startY);//sv.origin;
    //终点
    CGFloat endY;
    if (sv.y == 0 && CGRectGetMaxY(sv.frame) != self.height) {//顶部与容器View的顶部一致
        endY = CGRectGetMaxY(sv.frame);
    }else{
        endY = CGRectGetMaxY(sv.frame) - XYBoundaryMarignLine;
    }
    
    line.endPoint = CGPointMake(sv.x - edgeW / 2, endY);
    [_lines addObject:line];
}
#pragma mark - 处理手势,修改模板的frame
- (void)panScroll:(UIPanGestureRecognizer *)geature{
    CGPoint loc = [geature locationInView:geature.view];
    CGPoint move = [geature translationInView:geature.view];
//    XYLog(@"%@ - %@", NSStringFromCGPoint(loc), NSStringFromCGPoint(move));
    //手势所在的UIScrollView
    
    if (geature.state == UIGestureRecognizerStateBegan) {
        self.currentSV = [self calculateCurrentScrollViewWithLocation:loc];
    }
    
    
    if (_currentSV.width < XYMinScrollView || _currentSV.height < XYMinScrollView) {
//        currentSV.height -= move.y;
        return;
    }
    
//    XYLog(@"currentSV %@----%d",NSStringFromCGRect(currentSV.frame), currentSV.tapLocation);
    BOOL modifyFrame;
    if (_currentSV == nil) {//为空，则不能修改frame
        modifyFrame = NO;
    }else{
        modifyFrame = YES;
        
    }
    //modifyFrame == YES 去寻找其他需要修改的视图
    if (modifyFrame) {
        //手势靠近的UIScrollView
        [self modifyCloseScrollViewWithCurrentSV:_currentSV move:move];
    }
    
    //修改当前scroll的frame
    [self modifyFrameWithScrollView:_currentSV move:move];
    //重新画线
    [self calculateAllLines];
    [self setNeedsDisplay];
    //移动的点清零
    [geature setTranslation:CGPointZero inView:geature.view];
}
//调整比邻的视图的frame
- (void)modifyCloseScrollViewWithCurrentSV:(XYScrollView *)currentSV move:(CGPoint)move{
    
    if (currentSV.tapLocation == TapLocationTop) {
        //选中视图的顶部，则比邻的视图的最大Y值等于选中视图的y值
        for (XYScrollView *scv in _scrollViews) {
            if ([scv isEqual:currentSV]) {//跳过当前的UIScrollView
                continue;
            }
            if (CGRectGetMaxY(scv.frame) == currentSV.y) {//顶部的View
                //调整frame
                scv.tapLocation = TapLocationBottom;
                [self modifyFrameWithScrollView:scv move:move];
            }else if (currentSV.y == scv.y && scv.height != self.height){//Y轴相等，左右的View
                scv.tapLocation = TapLocationTop;
                [self modifyFrameWithScrollView:scv move:move];
            }
            
            
        }
    }
    if (currentSV.tapLocation == TapLocationBottom) {
        //选中视图的底部，则比邻的视图的y值低于选中的视图的最大Y值
        for (XYScrollView *scv in _scrollViews) {
            if ([scv isEqual:currentSV]) {//跳过当前的UIScrollView
                continue;
            }
            if (CGRectGetMaxY(currentSV.frame) == scv.y) {//底部的View
                //调整frame
                scv.tapLocation = TapLocationTop;
                [self modifyFrameWithScrollView:scv move:move];
            }else if (currentSV.y == scv.y && scv.height != self.height){//Y轴相等，左右的View
                scv.tapLocation = TapLocationBottom;
                [self modifyFrameWithScrollView:scv move:move];
            }
            
            
        }
    }
    if (currentSV.tapLocation == TapLocationLeft) {
        //如果选中视图的左边，则比邻的视图的最大X值等于选中视图的x
        for (XYScrollView *scv in _scrollViews) {
            if ([scv isEqual:currentSV]) {//跳过当前的UIScrollView
                continue;
            }
            if (CGRectGetMaxX(scv.frame) == currentSV.x) {//右边的视图
                //调整frame
                scv.tapLocation = TapLocationRight;
                [self modifyFrameWithScrollView:scv move:move];
            }else if (scv.x == currentSV.x && scv.width != self.width){//x轴相同，顶部或者底部
                scv.tapLocation = TapLocationLeft;
                [self modifyFrameWithScrollView:scv move:move];
            }
            
            
        }
    }
    if (currentSV.tapLocation == TapLocationRight){
        //如果选中视图的右边，则比邻的视图的x值等于选中视图的最大X值
        for (XYScrollView *scv in _scrollViews) {
            if ([scv isEqual:currentSV]) {//跳过当前的UIScrollView
                continue;
            }
            if (CGRectGetMaxX(currentSV.frame) == scv.x) {//右边的View
                //调整frame
                scv.tapLocation = TapLocationLeft;
                [self modifyFrameWithScrollView:scv move:move];
            }else if(currentSV.x == scv.x && scv.width != self.width){//x轴相同，顶部或者底部
                scv.tapLocation = TapLocationRight;
                [self modifyFrameWithScrollView:scv move:move];
            }
        }
    }
    
}

//修改当前scroll的frame
- (void)modifyFrameWithScrollView:(XYScrollView *)currentSV move:(CGPoint)move{
    if (currentSV.tapLocation == TapLocationTop) {//顶部
        //修改Y，Height
        currentSV.y += move.y;
        currentSV.height -= move.y;
    }else if (currentSV.tapLocation == TapLocationRight){//右边
        //修改width
        currentSV.width += move.x;
    }else if (currentSV.tapLocation == TapLocationBottom){//底部
        //修改Height
        currentSV.height += move.y;
        
    }else if (currentSV.tapLocation == TapLocationLeft){//左边
        //修改X， Width
        currentSV.x += move.x;
        currentSV.width -= move.x;
    }
    //重新设置imageview的frame
//    [self resetImageViewFrame];
}

//计算当前手势点击的scrollView
- (XYScrollView *)calculateCurrentScrollViewWithLocation:(CGPoint)loc{
    XYScrollView *currentSV;
    for (XYScrollView *scV in _scrollViews) {
        if (CGRectContainsPoint(scV.frame, loc)) {
            currentSV = scV;
            break;
        }
    }
    //判断点击的位置
    float recognize = 30;
    if ((loc.y - currentSV.y) < recognize) {
        currentSV.tapLocation = TapLocationTop;    //0
    }else if((CGRectGetMaxY(currentSV.frame) - loc.y) < recognize){
        currentSV.tapLocation = TapLocationBottom; //1
    }else if ((loc.x - currentSV.x) < recognize){
        currentSV.tapLocation = TapLocationLeft;   //2
    }else if ((CGRectGetMaxX(currentSV.frame) - loc.x) < recognize){
        currentSV.tapLocation = TapLocationRight;  //3
    }else{
        currentSV.tapLocation = TapLocationMiddle; //4
        return nil;
    }
    
    if (currentSV.x == 0) {
        //左边不能动
        if (currentSV.tapLocation == TapLocationLeft) {
            return nil;
        }
    }
    
    if (currentSV.y == 0){
        //顶部不能动
        if (currentSV.tapLocation == TapLocationTop) {
            return nil;
        }
    }
    
    if (CGRectGetMaxX(currentSV.frame) == self.width){
        //右边不能动
        if (currentSV.tapLocation == TapLocationRight) {
            return nil;
        }
    }
    
    if (CGRectGetMaxY(currentSV.frame) == self.height){
        //底部不能动
        if (currentSV.tapLocation == TapLocationBottom) {
            return nil;
        }
    }
    
    return currentSV;
}


#pragma mark - 修改模板的比例
- (void)templateScaleChange:(NSNotification *)noti{
    NSString *scaleStr = noti.userInfo[XYTemplateChangeScale];
    XYLog(@"%@", scaleStr);
    if ([scaleStr isEqualToString:@"1:1"]) {
        self.templateScale = TemplateScaleOneToOne;
    }else if ([scaleStr isEqualToString:@"4:3"]){
        self.templateScale = TemplateScaleFourToThree;
    }else{
        self.templateScale = TemplateScaleThreeToFour;
    }
    //重画模板
    [self setTemplateIndex:_templateIndex];
    //重新为imageview赋值
    if (_images.count > 0) {
        [self setImages:_images];    
    }
    

}
//设置模板样式比例 frame
- (void)setTemplateScale:(TemplateScale)templateScale{
    _templateScale = templateScale;
    
    CGFloat marginCont;// = 20;
    if (XYScreenWidth == 320) {
        marginCont = 20;
    }else if (XYScreenWidth == 375 || XYScreenWidth == 414){
        marginCont = 15;
    }
    self.width = XYScreenWidth - marginCont;
//    XYLog(@"容器的宽 --- %f", self.width);
    
    if (templateScale == TemplateScaleOneToOne) {//1:1
        self.height = self.width;
    }else if (templateScale == TemplateScaleThreeToFour){//3:4
        self.height = self.width * 3 / 4;
    }else if (templateScale == TemplateScaleFourToThree){//4:3
        self.height = self.width * 4 / 3;
    }
    self.x = marginCont / 2;
    self.y = (XYScreenHeight - self.height) / 2;
}
#pragma mark - 修改模板边框样式
- (void)switchBorderStyle:(NSNotification *)noti{
    NSString *borderStr = noti.userInfo[XYSwitchBorderStyle];
    if ([borderStr isEqualToString:@"有边框"]) {
        _templateBorderStyle = TemplateBorderStyleRectangle;
        
        [self setNeedsDisplay];
    }else{
        _templateBorderStyle = TemplateBorderStyleNone;
        [self setNeedsDisplay];
    }
}

//画线
- (void)drawRect:(CGRect)rect{
    //获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    
    CGContextSetLineWidth(ctx, _currentWidth);
    
    for (XYLine *line in self.lines) {
        
        if (_templateBorderStyle == TemplateBorderStyleNone) {//虚线 or 无边框
            [[UIColor clearColor] set];
//            CGFloat lengths[] = {5, 5};
//            CGContextSetLineDash(ctx, 0, lengths, 2);
        }else{
            [_currentColor set];
        }
        
        CGContextMoveToPoint(ctx, line.startPoint.x, line.startPoint.y);
        CGContextAddLineToPoint(ctx, line.endPoint.x, line.endPoint.y);
        CGContextStrokePath(ctx);
    }

}

#pragma mark - 切换选中的颜色
- (void)switchSelectedColor:(NSNotification *)noti{
    self.currentColor = noti.userInfo[XYSwitchSelectedColor];
    [self setNeedsDisplay];
}

#pragma mark - 切换线宽
- (void)switchSelectedWidth:(NSNotification *)noti{
    self.currentWidth = [noti.userInfo[XYSwitchSelectedWidth] integerValue];
    [self calculateAllLines];
    [self setNeedsDisplay];
}

#pragma mark - 切换模板
- (void)selectedTemplate:(NSNotification *)noti{
    NSInteger templateIndex = [noti.userInfo[XYSelectedTemplate] integerValue];
    if (templateIndex != _templateIndex) {
        [self setTemplateIndex:templateIndex];
    }
    
}

#pragma mark - 处理点击scrollView
- (void)tapScroll:(UITapGestureRecognizer *)gesture{
//隐藏键盘 触发block 复位
    if (_layoutCV) {
        _layoutCV();
    }
    
    XYScrollView *scrollView = (XYScrollView *)gesture.view;
    //添加菜单
    CGPoint loc = [gesture locationInView:gesture.view];
    [self showMenuViewOnScroolView:scrollView location:loc];
    //计算最大的图片选取数量
    [self calculateEmptySV];
}
//添加菜单
- (void)showMenuViewOnScroolView:(XYScrollView *)scrollView location:(CGPoint)loc{
    
    if ([scrollView isEqual:_currentSV]) {//点击同一个scrollView 隐藏
        if (_menuView.isHidden) {
            self.menuView.hidden = NO;
        }else{
            self.menuView.hidden = YES;
        }
    }else{//不同的视图
        self.menuView.hidden = NO;
    }

    loc = [scrollView convertPoint:loc toView:self];
    self.menuView.origin = loc;
    
    if (CGRectGetMaxY(_menuView.frame) > self.height) {//底部超出了模板
        CGFloat deltaY = CGRectGetMaxY(_menuView.frame) - self.height;
        _menuView.y -= deltaY;
    }
    if (CGRectGetMaxX(_menuView.frame) > self.width) {//右边超出了模板
        CGFloat deltaX = CGRectGetMaxX(_menuView.frame) - self.width;
        _menuView.x -= deltaX;
    }
    
    //切换选中的scroll
    self.currentSV = scrollView;
    
    [self bringSubviewToFront:_menuView];
}

#pragma mark - 计算最大的图片选取数量
- (void)calculateEmptySV{
    [self.emptySVs removeAllObjects];
    for (XYScrollView *sv in self.subviews) {
        if ([sv isKindOfClass:[XYScrollView class]]) {
            //取出当前选中的视图
            if ([sv isEqual:_currentSV]) {
                continue;
            }
            
            for (UIView *view in sv.subviews) {
                if ([view isKindOfClass:[UIScrollView class]]) {
                    if (sv.image == nil && sv.textView.isHidden && sv.verticalTextView.isHidden) {
                        [_emptySVs addObject:sv];
                        break;
                    }
                }
            }
            
//            if (sv.subviews.count == 3) {
//                [_emptySVs addObject:sv];
//            }
        }
    }
   
}

#pragma mark - 为模板添加图片
- (void)setImages:(NSMutableArray *)images{
    _images = images;
    if (images.count > 0) {
        int i = 0;
        for (UIImage *image in images) {
            
            if (i == 0) {
                self.currentSV.image = image;
            }
            if (i > 0) {
                XYScrollView *sv = _emptySVs[i - 1];
                sv.image = image;
            }
            i ++;
            XYLog(@"%@", image);
        }
    }
}
#pragma mark - 监听点击scroll菜单点击
- (void)selectedMenu:(NSNotification *)noti{
    NSInteger indexRow = [noti.userInfo[XYSelectedMenu] integerValue];
    if (indexRow == 4) {//删除
        //清空图片
        if (_currentSV.image) {
            //同时需要清空数组中保存的图片
            [_images removeObject:_currentSV.image];
            _currentSV.image = nil;
        }
        
        //清空横文本
        if (!_currentSV.textView.isHidden) {
            _currentSV.textView.text = nil;
            _currentSV.textView.hidden = YES;
        }
        
        //清空竖文本
        if (!_currentSV.verticalTextView.isHidden) {
            _currentSV.verticalTextView.singleWidth = 0;
            _currentSV.verticalTextView.hidden = YES;
            for (XYTextView *textView in _currentSV.verticalTextView.textViews) {
                textView.text = nil;
            }
        }
    }else if (indexRow == 3){//竖排文本
        _currentSV.image = nil;
        _currentSV.textView.hidden = YES;
        
        _currentSV.verticalTextView.hidden  = NO;
        [_currentSV bringSubviewToFront:_currentSV.verticalTextView];
        
        //设置一个textView的宽
//        XYTextView *tv = _currentSV.verticalTextView.textViews[0];
        CGFloat fontSize = [[[NSUserDefaults standardUserDefaults] objectForKey:XYFontSize] floatValue];
        if (fontSize == 0) {
            fontSize = 15.0;
        }
        _currentSV.verticalTextView.singleWidth = fontSize;
        //弹性键盘，第一个textView成为第一响应
        XYTextView *textView = _currentSV.verticalTextView.textViews[0];
        [textView becomeFirstResponder];
        
    }else if (indexRow == 2){//横排文本
        _currentSV.image = nil;
        [_currentSV bringSubviewToFront:_currentSV.textView];
        _currentSV.textView.hidden = NO;
        [_currentSV.textView becomeFirstResponder];
    }else{//图片、相机
        _currentSV.textView.text = nil;
        _currentSV.textView.hidden = YES;
    }
}

#pragma mark - 监听字体的修改
- (void)changeFont:(NSNotification *)noti{
    XYFont *font = noti.userInfo[XYChangeFont];
    
    
    if (!_currentSV.textView.isHidden) {
        [XYFontTool setTextView:_currentSV.textView fontName:font.simplifiedNormalfaced];
        
    }else if (!_currentSV.verticalTextView.isHidden){
        for (XYTextView *tv in _currentSV.verticalTextView.textViews) {
            [XYFontTool setTextView:tv fontName:font.simplifiedNormalfaced];
        }
    }
}

#pragma mark - 销毁
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
