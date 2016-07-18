//
//  XYFilterViewController.m
//  Deliver
//
//  Created by 李小亚 on 16/6/22.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYFilterViewController.h"
#import "XYFilter.h"
#import "GPUImageSketchFilter.h"
#import "GPUImageMonochromeFilter.h"
#import "GPUImageRGBFilter.h"

#import "XYFilterToolBar.h"
#import "XYPreviewsView.h"
#import "XYCoverView.h"
#import "XYPreview.h"

#import "UMSocialSinaSSOHandler.h"
#import "UMSocial.h"

#import "XYShareTool.h"
#import "GPUImage.h"

#import "MBProgressHUD+CZ.h"


@interface XYFilterViewController ()<XYFilterToolBarDelegate, XYCoverViewDelegate, UMSocialUIDelegate>
/**
 *  预览模型
 */
@property (nonatomic, strong) NSMutableArray *previews;

/**
 *  预览视图
 */
@property (nonatomic, weak) XYPreviewsView *previewsView;
/**
 *  展示的效果图
 */
@property (nonatomic, weak) UIImageView *displayImageView;

@property (nonatomic, weak) UIImageView *bgImageView;
/**
 *  分享界面
 */
//@property (nonatomic, weak) XYCoverView *coverView;



@end

@implementation XYFilterViewController

- (UIImage *)originalImage{
    if (!_originalImage) {
        _originalImage = [UIImage imageWithData:_originalImageData];
    }
    return  _originalImage;
}

#pragma mark - 懒加载
- (NSMutableArray *)previews{
    if (!_previews) {
        _previews = [NSMutableArray array];
        
        XYFilter *filter0 = [XYFilter filterWithOriginalImage:self.originalImage title:@"原图"];
        [_previews addObject:filter0];

        XYFilter *filter1 = [XYFilter filterWithOriginalImage:self.originalImage title:@"素描"];
        [_previews addObject:filter1];

        XYFilter *filter2 = [XYFilter filterWithOriginalImage:_originalImage title:@"怀旧"];
        [_previews addObject:filter2];

        XYFilter *filter3 = [XYFilter filterWithOriginalImage:_originalImage title:@"哥特"];
        [_previews addObject:filter3];

        XYFilter *filter4 = [XYFilter filterWithOriginalImage:_originalImage title:@"锐化"];
        [_previews addObject:filter4];
 
        XYFilter *filter6 = [XYFilter filterWithOriginalImage:_originalImage title:@"淡雅"];
        [_previews addObject:filter6];
        
        
        //        XYFilter *filter5 = [XYFilter filterWithOriginalImage:_originalImage title:@"锐化"];
        //        [_previews addObject:filter5];
        
//        XYFilter *filter7 = [XYFilter filterWithOriginalImage:_originalImage title:@"酒红"];
//        [_previews addObject:filter7];
        
//        XYFilter *filter8 = [XYFilter filterWithOriginalImage:_originalImage title:@"清宁"];
//        [_previews addObject:filter8];

 
    }
    return _previews;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    //监听图片的点击
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeDisplayImage:) name:XYTapPreviewImage object:nil];
    //监听分享成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareSucceed) name:XYShareSucceed object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupChildView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [MBProgressHUD showSuccess:@"OK"];
    [MBProgressHUD hideHUD];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.previews removeAllObjects];
    self.previews = nil;
    _originalImage = nil;
    //清空图片
    for (XYPreview *preview in _previewsView.subviews) {
        for (UIImageView *iv in preview.subviews) {
            if ([iv isKindOfClass:[UIImageView class]]) {
                iv.image = nil;
            }
        }
    }
    _displayImageView.image = nil;
}

- (void)setupChildView{
    //添加背景图
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:bgImageView];
    self.bgImageView = bgImageView;
    
    GPUImageGaussianBlurFilter *gaussianFilter = [[GPUImageGaussianBlurFilter alloc] init];
    gaussianFilter.blurRadiusInPixels = 15;
    UIImage *gaussianImage = [gaussianFilter imageByFilteringImage:self.originalImage];
    bgImageView.image = gaussianImage;
    
    //展示的ImageView
    UIImageView *displayImageView = [[UIImageView alloc] init];
    [self.view addSubview:displayImageView];
    self.displayImageView = displayImageView;
    displayImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    displayImageView.width = XYScreenWidth - 20;
    displayImageView.height = displayImageView.width * 4 / 3;
    displayImageView.x = 10;
    displayImageView.y = 25;
    displayImageView.image = self.originalImage;
    
    
    //底部工具条
    XYFilterToolBar *filterToolBar = [[XYFilterToolBar alloc] init];
    [self.view addSubview:filterToolBar];
    filterToolBar.height = 35;
    filterToolBar.width = XYScreenWidth;
    filterToolBar.x = 0;
    filterToolBar.y = XYScreenHeight - filterToolBar.height;
    filterToolBar.delegate = self;
    
    //预览视图
    XYPreviewsView *previewsView = [[XYPreviewsView alloc] init];
    [self.view addSubview:previewsView];
    self.previewsView = previewsView;
    //frame
    previewsView.width = XYScreenWidth;
    previewsView.height = 100;
    previewsView.x = 0;
    previewsView.y = CGRectGetMinY(filterToolBar.frame) - 10 - previewsView.height;
    //赋值
    previewsView.previews = self.previews;

}


#pragma Mark - 修改预览图片图片
- (void)changeDisplayImage:(NSNotification *)noti{
    UIImage *image = noti.userInfo[XYTapPreviewImage];
    self.displayImageView.image = image;
}

#pragma mark - XYFilterToolBarDelegate
- (void)filterToolBarDidClickDoneBtn:(XYFilterToolBar *)filterToolBar{
    XYCoverView *coverView = [XYCoverView show];
    coverView.delegate = self;
}

- (void)filterToolBarDidClickCancelBtn:(XYFilterToolBar *)filterToolBar{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - XYCoverViewDelegate
- (void)coverView:(XYCoverView *)coverView didClickShareBtnWithIndex:(NSInteger)index{
    //    保存到相册
    UIImageWriteToSavedPhotosAlbum(self.displayImageView.image, nil, nil, nil);
    if (index == 3) {//相册
        //
    }else if (index == 2){//微博
        [XYShareTool shareToAppWingName:@"sina" image:_displayImageView.image text:@"来自小亚的私人订制" viewController:self];
    }else if (index == 1){//空间 qzone
        [XYShareTool shareToAppWingName:@"qzone" image:_displayImageView.image text:@"分享图片" viewController:self];
    }else{//朋友圈 wxtimeline
        [XYShareTool shareToAppWingName:@"wxtimeline" image:_displayImageView.image text:nil viewController:self];
    }
}

#pragma mark - 分享成功
- (void)shareSucceed{
    [XYCoverView hiden];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    XYLog(@"XYFilterViewController.h 销毁");
}


/**
 *  XYFilter *filter0 = [XYFilter filterWithOriginalImage:_originalImage filter:nil red:0 green:0 blue:0 title:@"原图"];
 [_previews addObject:filter0];
 
 GPUImageSketchFilter *sketchFilter = [[GPUImageSketchFilter alloc] init];
 XYFilter *filter1 = [XYFilter filterWithOriginalImage:_originalImage filter:sketchFilter red:0 green:0 blue:0 title:@"素描"];
 [_previews addObject:filter1];
 
 GPUImageMonochromeFilter *monochromeFilter = [[GPUImageMonochromeFilter alloc] init];
 XYFilter *filter2 = [XYFilter filterWithOriginalImage:_originalImage filter:monochromeFilter red:0 green:0 blue:0 title:@"黑白照片"];
 [_previews addObject:filter2];
 
 GPUImageRGBFilter *rgbFilter = [[GPUImageRGBFilter alloc] init];
 XYFilter *filter3 = [XYFilter filterWithOriginalImage:_originalImage filter:rgbFilter red:0.8 green:1.0 blue:1.0 title:@"滤镜3"];
 [_previews addObject:filter3];
 
 XYFilter *filter4 = [XYFilter filterWithOriginalImage:_originalImage filter:rgbFilter red:1.0 green:0.8 blue:1.0 title:@"滤镜4"];
 [_previews addObject:filter4];
 
 XYFilter *filter5 = [XYFilter filterWithOriginalImage:_originalImage filter:rgbFilter red:1.0 green:1.0 blue:0.8 title:@"滤镜5"];
 [_previews addObject:filter5];
 
 XYFilter *filter6 = [XYFilter filterWithOriginalImage:_originalImage filter:rgbFilter red:0.9 green:0.9 blue:0.9 title:@"滤镜6"];
 [_previews addObject:filter6];
 */
@end
