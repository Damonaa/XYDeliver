//
//  XYMainViewController.m
//  Deliver
//
//  Created by 李小亚 on 16/5/29.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYMainViewController.h"
#import "XYContainerView.h"
#import "XYToolOptionsView.h"
#import "XYColorView.h"
#import "UIButton+XY.h"
#import "XYColorBtn.h"
#import "XYTemplateViewController.h"
#import "TZImagePickerController.h"
#import "XYKeyboardToolBarView.h"
#import "XYScrollView.h"
#import "XYTextView.h"
#import "XYVerticalTextView.h"
#import "XYMenuView.h"
#import "XYFontViewController.h"
#import "XYScrollView.h"
#import "XYTextSettingView.h"
#import "XYFont.h"
#import "XYFontTool.h"
#import "XYFilterViewController.h"
#import "XYCoverView.h"
#import "XYShareTool.h"

@interface XYMainViewController ()<XYToolOptionsViewDelegate, XYColorViewDelegate, XYColorBtnDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate, TZImagePickerControllerDelegate,XYKeyboardToolBarViewDelegate, XYTextSettingViewDelegate, XYCoverViewDelegate>
/**
 *  工具菜单视图
 */
@property (nonatomic, weak) XYToolOptionsView *toolView;
/**
 *  颜色线宽选择视图
 */
@property (nonatomic, weak) XYColorView *colorView;
/**
 *  颜色线宽选择按钮
 */
@property (nonatomic, weak) XYColorBtn *colorBtn;
/**
 *  拼图的容器
 */
@property (nonatomic, weak) XYContainerView *containerView;
/**
 *  键盘工具条
 */
@property (nonatomic, weak) XYKeyboardToolBarView *kbToolBar;

/**
 *  键盘的frame
 */
@property (nonatomic, assign) CGRect keyboardLastRect;
/**
 *  最大的容器的初始Y值
 */
@property (nonatomic, assign) CGFloat originalCMaxY;
/**
 *  字体控制器
 */
@property (nonatomic, strong) XYFontViewController *fontVC;
/**
 *  字体参数设置View
 */
@property (nonatomic, weak) XYTextSettingView *textSettingView;
/**
 *  是否是在是设置文字的颜色和size， 默认为NO
 */
//@property (nonatomic, assign, getter=isSettingText) BOOL settingText;


@end

@implementation XYMainViewController

#pragma mark - 懒加载
- (XYFontViewController *)fontVC{
    if (!_fontVC) {
        _fontVC = [[XYFontViewController alloc] init];
    }
    return _fontVC;
}
- (XYColorView *)colorView{
    if (!_colorView) {
        XYColorView *colorView = [[XYColorView alloc] initWithFrame:CGRectMake(50, 0, XYScreenWidth - 50, XYScreenHeight)];
        [self.view addSubview:colorView];
        _colorView = colorView;
        
        _colorView.showBtns = YES;
        _colorView.delegate = self;
    }
    return _colorView;
}

- (XYTextSettingView *)textSettingView{
    if (!_textSettingView) {
        XYTextSettingView *tsv = [[XYTextSettingView alloc] initWithFrame:_keyboardLastRect];
        [self.view addSubview:tsv];
        self.textSettingView = tsv;
        tsv.hidden = YES;
        tsv.delegate = self;
    }
    return _textSettingView;
}
#pragma mark - 声明周期
- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.805 green:0.798 blue:0.755 alpha:1.000];
    self.title = @"标题被吃了";
    
    UILabel *test = [[UILabel alloc] init];
    test.text = @" ";
    [test sizeToFit];
    [self.view addSubview:test];
    test.x= 0;
    test.y = 64;
    
    //添加工具选项按钮
    [self setupChildView];
    
    //监听点击scroll的菜单选中
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedMenu:) name:XYSelectedMenu object:nil];
    
    //监听键盘的弹出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    //监听键盘的隐藏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    //监听文本编辑的当前位置
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentCursorPositionChange:) name:XYCurrentCursorPosition object:nil];
    
    //监听分享成功
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareSucceed) name:XYShareSucceed object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

#pragma mark - 添加工具选项按钮
- (void)setupChildView{
    
    UIButton *shareBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"upload_icon_default"] highlightedImage:[UIImage imageNamed:@"upload_icon_pressed"] target:self selcetor:@selector(shareBtnClick) controlEvent:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    
    //拼图的容器
//    CGFloat marginCont = 15;
    XYContainerView *containerView = [[XYContainerView alloc] init];
    [self.view addSubview:containerView];
    self.containerView = containerView;
    containerView.templateIndex = 0;
    containerView.templateScale = TemplateScaleOneToOne;
    //为初始最大的容器Y赋值
    _originalCMaxY = CGRectGetMaxY(containerView.frame);
    //重新布局的时候，结束编辑
    containerView.layoutCV = ^{
        if (!_kbToolBar.isHidden) {
            [self endEditingAndReset];
        }
    };
    
    
    //工具栏
    XYToolOptionsView *toolView = [[XYToolOptionsView alloc] init];
    [self.view addSubview:toolView];
    self.toolView = toolView;
    toolView.delegate = self;
    toolView.frame = CGRectMake(0, XYScreenHeight - 48, XYScreenWidth, 48);

    //添加展示颜色的按钮
    XYColorBtn *colorBtn = [[XYColorBtn alloc] init];
    [self.view addSubview:colorBtn];
    self.colorBtn = colorBtn;
    colorBtn.width = 38;
    colorBtn.height = 38;
    colorBtn.x = self.view.width - colorBtn.width - 5;
    colorBtn.y = self.view.height - colorBtn.height - 5;
    colorBtn.delegate = self;
    
    XYKeyboardToolBarView *kbToolBar = [[XYKeyboardToolBarView alloc] init];
    [self.view addSubview:kbToolBar];
    self.kbToolBar = kbToolBar;
    
    kbToolBar.frame = CGRectMake(0, XYScreenHeight - 35, XYScreenWidth, 35);
    kbToolBar.delegate = self;
    kbToolBar.hidden = YES;
}

#pragma mark - XYColorBtnDelegate 展示颜色线宽视图
- (void)colorBtnDidClick:(XYColorBtn *)colorBtn{
    //先隐藏工具菜单栏
    if (_toolView.isShowMenu) {
        [_toolView showMenu:NO];
        _toolView.showMenu = NO;
    }
    [self.colorView showColorAndWidth:YES];
}

#pragma mark - XYToolOptionsViewDelegate
- (void)toolOptionsView:(XYToolOptionsView *)toolView didClickBtn:(UIButton *)btn{
    if (btn.tag == 1) {//弹出模板视图
        XYTemplateViewController *templateVC = [[XYTemplateViewController alloc] init];
        [self presentViewController:templateVC animated:YES completion:nil];
    }else if (btn.tag == 4){//滤镜
        XYFilterViewController *filterVC = [[XYFilterViewController alloc] init];
        NSData *temp = UIImagePNGRepresentation([self clipScreen]);
        filterVC.originalImageData = temp;
//        filterVC.originalImage = [self clipScreen];
//        [self.navigationController pushViewController:filterVC animated:YES];
        [self presentViewController:filterVC animated:YES completion:nil];
    }
}
//截取图片
- (UIImage *)clipScreen{
    UIGraphicsBeginImageContextWithOptions(_containerView.frame.size, NO, [UIScreen mainScreen].scale);
    [_containerView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}
//点击菜单主按钮
- (void)toolOptionViewDidClickMainBtn:(XYToolOptionsView *)toolView{
    //隐藏颜色按钮
    if (_colorView.isShowBtns) {
       [_colorView showColorAndWidth:NO];
        [_colorView hidenSelf];
    }
    
}

#pragma mark - XYColorViewDelegate
//设置线宽 size
- (void)colorView:(XYColorView *)colorView selcetedWidth:(CGFloat)width mainBtn:(UIButton *)mainBtn{
    self.colorBtn.btnSize = width;
    if (!_colorView.isSettingText) {//若不是设置文字的颜色，返回
        return;
    }
    XYScrollView *sv = _containerView.currentSV;
    CGFloat fontSize = 8 + width * 3.0;
    //保存到偏好设置
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:fontSize] forKey:XYFontSize];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (!sv.textView.isHidden) {
        UIFont *tempFont = sv.textView.font;
        sv.textView.font = [UIFont fontWithName:tempFont.fontName size:fontSize];
    }else if (!sv.verticalTextView.isHidden){
        sv.verticalTextView.newWidth = fontSize;        
        for (XYTextView *tv in sv.verticalTextView.textViews) {
            tv.font = [UIFont fontWithName:tv.font.fontName size:fontSize];
        }
    }
}
//设置颜色
- (void)colorView:(XYColorView *)colorView selcetedColor:(UIColor *)color mainBtn:(UIButton *)mainBtn{
    self.colorBtn.btnImage = mainBtn.currentImage;
    
    if (!_colorView.isSettingText) {//若不是设置文字的颜色，返回
        return;
    }
    XYScrollView *sv = _containerView.currentSV;
    if (!sv.textView.isHidden) {
        sv.textView.textColor = color;
    }else if (!sv.verticalTextView.isHidden){
        for (XYTextView *tv in sv.verticalTextView.textViews) {
            tv.textColor = color;
        }
    }
    
}

#pragma mark - 监听点击scroll菜单点击
- (void)selectedMenu:(NSNotification *)noti{  
    NSInteger indexRow = [noti.userInfo[XYSelectedMenu] integerValue];
    switch (indexRow) {
        case 0:
            [self openPhotosAlbum];
            break;
        case 1:
            [self openCamera];
            break;
        case 2:
//            [self addText];
            break;
        case 3:
//            [self addText];
            break;
        case 4:
            
            break;
    }
}
//打开相册
- (void)openPhotosAlbum{
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:_containerView.emptySVs.count + 1 delegate:self];
    [self presentViewController:imagePicker animated:YES completion:nil];
}
//打开相机
- (void)openCamera{
    UIImagePickerController *pickerCtr = [[UIImagePickerController alloc] init];
    pickerCtr.delegate = self;
    pickerCtr.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:pickerCtr animated:YES completion:nil];
}

#pragma mark - 监听键盘弹出隐藏
- (void)keyboardWillShow:(NSNotification *)noti{
    
    if ([_containerView.currentSV.textView isFirstResponder]) {
        [self transformKBToolBarWithNoti:noti kbToolBarHidden:NO];
    }else{
        XYVerticalTextView *vTV = _containerView.currentSV.verticalTextView;
        for (XYTextView *tv in vTV.textViews) {
            if ([tv isFirstResponder]) {
                [self transformKBToolBarWithNoti:noti kbToolBarHidden:NO];
                break;
            }
        }
    }
    
    
    //键盘弹出后的位置
    _keyboardLastRect = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
}

- (void)keyboardDidShow:(NSNotification *)noti{
    [self.view addSubview:self.fontVC.view];
    _fontVC.view.frame = _keyboardLastRect;
    _fontVC.view.hidden = YES;
    _textSettingView.hidden = NO;
}
- (void)keyboardWillHide:(NSNotification *)noti{
//    _fontVC.view.hidden = NO;
}
//移动键盘工具栏
- (void)transformKBToolBarWithNoti:(NSNotification *)noti kbToolBarHidden:(BOOL)hidden{
    self.kbToolBar.hidden = hidden;
    CGFloat duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect lastRect = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat moveY = lastRect.origin.y - XYScreenHeight;
    
    [UIView animateWithDuration:duration animations:^{
        self.kbToolBar.transform = CGAffineTransformMakeTranslation(0, moveY);
        if (CGAffineTransformIsIdentity(_kbToolBar.transform)){
            _kbToolBar.alpha = 0;
            _containerView.transform = CGAffineTransformIdentity;
        }else{
            _kbToolBar.alpha = 1;
        }
    }completion:^(BOOL finished) {
        if (CGAffineTransformIsIdentity(_kbToolBar.transform)) {//结束编辑,隐藏工具栏
            _containerView.currentSV.textView.editable = NO;
            _containerView.currentSV.textView.selectable = NO;
        }
    }];
}
//处理文本编辑发出的通知
- (void)currentCursorPositionChange:(NSNotification *)noti{
    if (!_containerView.menuView.isHidden) {
        _containerView.menuView.hidden = YES;
    }
    
    //当前光标的位置
    CGPoint cursorPosition = [noti.userInfo[XYCurrentCursorPosition] CGPointValue];
    CGFloat offsetY = 20;
    //计算需要移动的距离
    CGFloat moveY = _keyboardLastRect.origin.y - 35 - offsetY - cursorPosition.y;
    if (cursorPosition.y > _keyboardLastRect.origin.y - 35 - offsetY) {//光标的Y大于键盘的
        [UIView animateWithDuration:0.1 animations:^{
            _containerView.transform = CGAffineTransformTranslate(_containerView.transform, 0, moveY);
        }];
    }
    
    //删除文本的时候
    BOOL isDel = [noti.userInfo[XYIsDeleteText] boolValue];
    BOOL isNew = [noti.userInfo[XYIsNewRespone] boolValue];
    if (isDel || isNew) {
//        XYLog(@"YES");
        //判断是否移动
        if (_originalCMaxY > CGRectGetMaxY(_containerView.frame) + offsetY) {
            [UIView animateWithDuration:0.1 animations:^{
                _containerView.transform = CGAffineTransformTranslate(_containerView.transform, 0, moveY);
            }];
        }else{
            [UIView animateWithDuration:0.1 animations:^{
                _containerView.transform = CGAffineTransformIdentity;
            }];
        }
        
    }
}

#pragma mark - XYKeyboardToolBarViewDelegate
- (void)toolBarView:(XYKeyboardToolBarView *)toolBarView didClickBtnAtIndex:(NSInteger)index{
    switch (index) {
        case 0:
            //显示键盘
            [self showKeyboard];
            break;
        case 1:
            //设置字体
            [self setupTextFont];
            break;
        case 2:
            //设置颜色
            [self setupTextColor];
            break;
        case 3:
            //设置参数
            [self setupTextSetting];
            break;
        case 4:
            //隐藏键盘，完成编辑
            [self endEditingAndReset];
            break;
        default:
            break;
    }
    
}
//显示键盘
- (void)showKeyboard{
    XYScrollView *sv = _containerView.currentSV;
    if (!sv.textView.isHidden) {
        [sv.textView becomeFirstResponder];
    }else if (!sv.verticalTextView.isHidden){
        XYTextView *tv = sv.verticalTextView.textViews[0];
        [tv becomeFirstResponder];
    }
    
}
//隐藏键盘，完成编辑
- (void)endEditingAndReset{
    [self.view endEditing:YES];
    //复位
    [UIView animateWithDuration:0.25 animations:^{
        self.kbToolBar.transform = CGAffineTransformIdentity;
        self.kbToolBar.alpha = 0;
        _containerView.transform = CGAffineTransformIdentity;
        _fontVC.view.transform = CGAffineTransformMakeTranslation(0, _fontVC.view.height);
        _textSettingView.transform = CGAffineTransformMakeTranslation(0, _textSettingView.height);
    }completion:^(BOOL finished) {
        self.kbToolBar.hidden = YES;
        [_fontVC.view removeFromSuperview];
        _textSettingView.hidden = YES;
        //遍历所有的textView，禁止编辑
        for (XYScrollView *sv in _containerView.subviews) {
            if ([sv isKindOfClass:[XYScrollView class]]) {
                if (!sv.textView.isHidden) {//横文本
                    sv.textView.editable = NO;
                    sv.textView.selectable = NO;
                }
                
                if (!sv.verticalTextView.isHidden) {//竖文本
                    for (XYTextView *textView in sv.verticalTextView.textViews) {
                        textView.editable = NO;
                        textView.selectable = NO;
                    }
                }
            }
        }
    }];

}
//设置字体
- (void)setupTextFont{
    //首先隐藏键盘
    [self.view endEditing:YES];
    if (!_textSettingView.isHidden) {
        _textSettingView.hidden = YES;
    }
    //在展示字体界面
    _fontVC.view.hidden = NO;
}
//设置颜色
- (void)setupTextColor{
    //隐藏键盘，完成编辑
    [self endEditingAndReset];
    [self.colorView showColorAndWidth:YES];
    _colorView.settingText = YES;
    //展示颜色选项
    [self performSelector:@selector(colorBtnDidClick:) withObject:_colorBtn afterDelay:0.1];
}
//设置参数
- (void)setupTextSetting{
    [self.view endEditing:YES];
    _fontVC.view.hidden = YES;
    self.textSettingView.hidden = NO;
    if (!CGAffineTransformIsIdentity(_textSettingView.transform)) {
        [UIView animateWithDuration:0.25 animations:^{
            _textSettingView.transform = CGAffineTransformIdentity;
        }];
    }
}


#pragma mark - XYTextSettingViewDelegate字体样式参数
/**
 *  修改对齐方式
 */
- (void)textSettingView:(XYTextSettingView *)textSettingView didChangeAligment:(NSInteger)aligmentIndex{
    NSTextAlignment textAlignment;
    if (aligmentIndex == 0) {
//        XYLog(@"左对齐");
        textAlignment = NSTextAlignmentLeft;
    }else if (aligmentIndex == 1){
//        XYLog(@"居中");
        textAlignment = NSTextAlignmentCenter;
    }else{
//        XYLog(@"右对齐");
        textAlignment = NSTextAlignmentRight;
    }
    
    XYScrollView *sv = _containerView.currentSV;
    if (!sv.textView.isHidden) {
        sv.textView.textAlignment = textAlignment;
    }else if (!sv.verticalTextView.isHidden){
        for (XYTextView *tv in sv.verticalTextView.textViews) {
            tv.textAlignment = textAlignment;
        }
    }
}
/**
 *  常规体 or 粗体
 */
- (void)textSettingView:(XYTextSettingView *)textSettingView didChangeFontSize:(NSInteger)sizeIndex{
    XYFont *font = [XYFontTool standardUserDefultFont]; //[XYFontTool shareFontTool].fontItem;
    
    NSString *fontName;
    if (sizeIndex == 3) {
        XYLog(@"常规体");
        [XYFontTool shareFontTool].boldFont = NO;
        fontName = [XYFontTool shareFontTool].isTraditionalFont ? font.traditionalNormalfaced : font.simplifiedNormalfaced;
        
    }else{
        XYLog(@"粗体");
        [XYFontTool shareFontTool].boldFont = YES;
        fontName = [XYFontTool shareFontTool].isTraditionalFont ? font.traditionalBoldfaced : font.simplifiedBoldfaced;
    }

    [self setTextViewFontWithName:fontName];
}
//设置文本是常规或者粗体 简体 or 繁体
- (void)setTextViewFontWithName:(NSString *)fontName{
    XYScrollView *sv = _containerView.currentSV;
    if (!sv.textView.isHidden) {
        [XYFontTool setTextView:sv.textView fontName:fontName];
    }else if (!sv.verticalTextView.isHidden){
        for (XYTextView *tv in sv.verticalTextView.textViews) {
            [XYFontTool setTextView:tv fontName:fontName];
        }
    }
}


/**
 *  简体 or 繁体
 */
- (void)textSettingView:(XYTextSettingView *)textSettingView didChangeFont:(NSInteger)fontIndex{
    XYFont *font = [XYFontTool standardUserDefultFont];
    NSString *fontName;
    if (fontIndex == 5) {
        XYLog(@"简体");
        [XYFontTool shareFontTool].traditionalFont = NO;
        
        fontName = [XYFontTool shareFontTool].isBoldFont ? font.simplifiedBoldfaced : font.simplifiedNormalfaced;
        
    }else{
        XYLog(@"繁体");
        [XYFontTool shareFontTool].traditionalFont = YES;
        fontName = [XYFontTool shareFontTool].isBoldFont ? font.traditionalBoldfaced : font.traditionalNormalfaced;
    }
    [self setTextViewFontWithName:fontName];
}

#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets{
    
    _containerView.images = (NSMutableArray *)photos;
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
//    XYLog(@"%@", info);
    
    UIImage *camearImage = info[UIImagePickerControllerOriginalImage];
    _containerView.currentSV.image = camearImage;
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 分享
- (void)shareBtnClick{
    XYCoverView *coverView = [XYCoverView show];
    coverView.delegate = self;
    
//    [_containerView removeFromSuperview];
}

#pragma mark - XYCoverViewDelegate
- (void)coverView:(XYCoverView *)coverView didClickShareBtnWithIndex:(NSInteger)index{
    UIImage *image = [self clipScreen];
    //    保存到相册
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    if (index == 3) {//相册
        //
    }else if (index == 2){//微博
        [XYShareTool shareToAppWingName:@"sina" image:image text:@"来自小亚的私人订制" viewController:self];
    }else if (index == 1){//空间 qzone
        [XYShareTool shareToAppWingName:@"qzone" image:image text:@"分享图片" viewController:self];
    }else{//朋友圈 wxtimeline
        [XYShareTool shareToAppWingName:@"wxtimeline" image:image text:nil viewController:self];
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
