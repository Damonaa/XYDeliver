//
//  XYPreview.m
//  Deliver
//
//  Created by 李小亚 on 16/6/22.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYPreview.h"
#import "XYFilter.h"
#import "GPUImage.h"

#import "ImageUtil.h"
#import "ColorMatrix.h"

@interface XYPreview ()

/**
 *  滤镜后的图片预览
 */
@property (nonatomic, weak) UIImageView *previewImageView;
/**
 *  滤镜的名称
 */
@property (nonatomic, weak) UILabel *previewName;

@end

@implementation XYPreview

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupChildView];
    }
    return self;
}
//添加子控件
- (void)setupChildView{
    UIImageView *previewImageView = [[UIImageView alloc] init];
    [self addSubview:previewImageView];
    self.previewImageView = previewImageView;
    previewImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPreviewImageView:)];
    [previewImageView addGestureRecognizer:tap];
    
    
    UILabel *previewName = [[UILabel alloc] init];
    [self addSubview:previewName];
    self.previewName = previewName;
    previewName.textColor = [UIColor blackColor];
    previewName.font = [UIFont systemFontOfSize:12];
}

- (void)setFilterItem:(XYFilter *)filterItem{
    _filterItem = filterItem;
    //布局滤镜名称标签
    _previewName.text = filterItem.title;
    [_previewName sizeToFit];
    _previewName.x = (self.width - _previewName.width) / 2;
    _previewName.y = self.height - _previewName.height;
    
    //布局过滤后图片的frame
    _previewImageView.x = 0;
    _previewImageView.y = 0;
    _previewImageView.width = self.width;
    _previewImageView.height = self.height - _previewName.height - 5;
    //过滤图片
    UIImage *preImage;// = filterItem.originalImage;
    if ([filterItem.title isEqualToString:@"原图"]) {
        preImage = filterItem.originalImage;
    }else if ([filterItem.title isEqualToString:@"素描"]){
        GPUImageSketchFilter *filter = [[GPUImageSketchFilter alloc] init];
        preImage = [filter imageByFilteringImage:filterItem.originalImage];
        
    }else if ([filterItem.title isEqualToString:@"怀旧"]){
        GPUImageMonochromeFilter *filter = [[GPUImageMonochromeFilter alloc] init];
//        GPUImageSepiaFilter *filter = [[GPUImageSepiaFilter alloc] init];
        preImage = [filter imageByFilteringImage:filterItem.originalImage];
    }else if ([filterItem.title isEqualToString:@"哥特"]){
        
        GPUImageContrastFilter *filter = [[GPUImageContrastFilter alloc] init];
        filter.contrast = 2.5;
        preImage = [filter imageByFilteringImage:filterItem.originalImage];
        
//        GPUImageRGBFilter *filter2 = [[GPUImageRGBFilter alloc] init];
//        filter2.red = 0.1;
//        filter2.green = 0.1;
//        filter2.blue = 0.1;
//        preImage = [filter imageByFilteringImage:temp1];

    }else if ([filterItem.title isEqualToString:@"锐化"]){
//        GPUImageSharpenFilter *filter1 = [[GPUImageSharpenFilter alloc] init];
        
//        GPUImageRGBFilter *filter = [[GPUImageRGBFilter alloc] init];
//        filter.red = 1.0;
//        filter.green = 0.9;
//        filter.blue = 0.9;
//        preImage = [filter imageByFilteringImage:filterItem.originalImage];
        
        
        UIImage *inputImage = filterItem.originalImage;
        //1,创建图片处理类 GPUImagePicture， 把图片传进去
        GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:inputImage];
        //2, 创建多个滤镜的对象
        //对比度
        GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
        contrastFilter.contrast = 2.5;
        [stillImageSource addTarget:contrastFilter];
        [contrastFilter useNextFrameForImageCapture];
        [stillImageSource processImage];
        
        //褐色
        GPUImageMonochromeFilter *monochromeFilter = [[GPUImageMonochromeFilter alloc] init];
        [contrastFilter addTarget:monochromeFilter];
        [monochromeFilter useNextFrameForImageCapture];
        [stillImageSource processImage];
        
        //3,把多个滤镜对象放到数组中
        NSMutableArray *filtersM = [NSMutableArray array];
        [filtersM addObject:contrastFilter];
        [filtersM addObject:monochromeFilter];
        
        //4, 创建GPUImageFilterPipeline, 初始化使用
        GPUImageView * outputView = [[GPUImageView alloc] initWithFrame:_previewImageView.frame];
        
        GPUImageFilterPipeline *pipeline = [[GPUImageFilterPipeline alloc] initWithOrderedFilters:filtersM input:stillImageSource output:outputView];
        //6, 获取图片
        preImage = [pipeline currentFilteredFrame];
        XYLog(@"");
    }else if ([filterItem.title isEqualToString:@"淡雅"]){
//        GPUImageRGBFilter *filter = [[GPUImageRGBFilter alloc] init];
//        filter.red = 0.8;
//        filter.green = 1;
//        filter.blue = 1;
//        preImage = [filter imageByFilteringImage:filterItem.originalImage];
        GPUImageFilter *customFilter = [[GPUImageFilter alloc] initWithFragmentShaderFromFile:@"CustomFilter"];
        preImage = [customFilter imageByFilteringImage:filterItem.originalImage];
        
       
        
        XYLog(@"");
    }
    _previewImageView.image = preImage;
    
}

//布局子控件位置
- (void)layoutSubviews{
    [super layoutSubviews];
}

- (void)tapPreviewImageView:(UITapGestureRecognizer *)gesture{
    if ([self.delegate respondsToSelector:@selector(preview:didTapImage:)]) {
        [self.delegate preview:self didTapImage:_previewImageView.image];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:XYTapPreviewImage object:self userInfo:@{XYTapPreviewImage:_previewImageView.image}];
}


- (void)setSelected:(BOOL)selected{
    _selected = selected;
    if (selected) {
        _previewName.textColor = [UIColor orangeColor];
    }else{
        _previewName.textColor = [UIColor blackColor];
    }
}

- (void)dealloc{
    _previewImageView.image = nil;
    XYLog(@"XYPreview.h 销毁");
}
/**
 GPUImage
 *  if ([filterItem.imageFilter isKindOfClass:[GPUImageRGBFilter class]]) {//reb
 GPUImageRGBFilter *filter = [[GPUImageRGBFilter alloc] init];
 filter.red = filterItem.red;
 filter.green = filterItem.green;
 filter.blue = filterItem.blue;
 _previewImageView.image = [filter imageByFilteringImage:filterItem.originalImage];
 }else if ([filterItem.imageFilter isKindOfClass:[GPUImageMonochromeFilter class]]){//黑白照
 GPUImageMonochromeFilter *filter = [[GPUImageMonochromeFilter alloc] init];
 _previewImageView.image = [filter imageByFilteringImage:filterItem.originalImage];
 }else if ([filterItem.imageFilter isKindOfClass:[GPUImageSketchFilter class]]){//素描
 GPUImageSketchFilter *filter = [[GPUImageSketchFilter alloc] init];
 _previewImageView.image = [filter imageByFilteringImage:filterItem.originalImage];
 }else{//原图
 _previewImageView.image = filterItem.originalImage;
 }
 */

/**
 CIFilter
 *  //        CIContext *content = [CIContext contextWithOptions:nil];
 //
 //        CIImage *inputImage = [CIImage imageWithCGImage:filterItem.originalImage.CGImage];
 //
 //        CIFilter *filter = [CIFilter filterWithName:@"CIColorMonochrome"];
 //        [filter setValue:inputImage forKey:kCIInputImageKey];
 //
 //        CIImage *outputImage = [filter outputImage];
 //        //[filter valueForKey:kCIOutputImageKey];
 //        CGImageRef cgImage = [content createCGImage:outputImage fromRect:[outputImage extent]];
 //        preImage = [UIImage imageWithCGImage:cgImage];
 //        CGImageRelease(cgImage);
 
 //        preImage = filterItem.originalImage;
 */

/**
 *   if ([filterItem.title isEqualToString:@"原图"]) {
 preImage = filterItem.originalImage;
 }else if ([filterItem.title isEqualToString:@"LOMO"]){
    preImage = [ImageUtil imageWithImage:filterItem.originalImage withColorMatrix:colormatrix_lomo];
 }else if ([filterItem.title isEqualToString:@"黑白"]){
preImage = [ImageUtil imageWithImage:filterItem.originalImage withColorMatrix:colormatrix_heibai];
 }else if ([filterItem.title isEqualToString:@"复古"]){
 preImage = [ImageUtil imageWithImage:filterItem.originalImage withColorMatrix:colormatrix_huajiu];
 }else if ([filterItem.title isEqualToString:@"哥特"]){
 preImage = [ImageUtil imageWithImage:filterItem.originalImage withColorMatrix:colormatrix_gete];
 }else if ([filterItem.title isEqualToString:@"锐化"]){
 preImage = [ImageUtil imageWithImage:filterItem.originalImage withColorMatrix:colormatrix_ruise];
 }else if ([filterItem.title isEqualToString:@"淡雅"]){
 preImage = [ImageUtil imageWithImage:filterItem.originalImage withColorMatrix:colormatrix_danya];
 }else if ([filterItem.title isEqualToString:@"酒红"]){
 preImage = [ImageUtil imageWithImage:filterItem.originalImage withColorMatrix:colormatrix_jiuhong];
 }else if ([filterItem.title isEqualToString:@"清宁"]){
 preImage = [ImageUtil imageWithImage:filterItem.originalImage withColorMatrix:colormatrix_qingning];
 }
 */

/**
 *   //1,创建图片处理类 GPUImagePicture， 把图片传进去
 GPUImagePicture *staticPicture = [[GPUImagePicture alloc] initWithImage:filterItem.originalImage smoothlyScaleOutput:YES];
 //2, 创建多个滤镜的对象
 //RGB滤镜
 GPUImageRGBFilter *RGBFilter = [[GPUImageRGBFilter alloc] init];
 RGBFilter.red = 0.5;
 //卡通滤镜
 GPUImageToonFilter *toonFilter = [[GPUImageToonFilter alloc] init];
 
 //3,把多个滤镜对象放到数组中
 NSMutableArray *filtersM = [NSMutableArray array];
 [filtersM addObject:RGBFilter];
 [filtersM addObject:toonFilter];
 
 //4, 创建GPUImageFilterPipeline, 初始化使用
 //        GPUImageInput *output;
 //        id <GPUImageInput> output;
 
 GPUImageFilterPipeline *pipeline = [[GPUImageFilterPipeline alloc] initWithOrderedFilters:filtersM input:staticPicture output:nil];
 //(GPUImageView*)self.previewImageView];
 
 //5，渲染图片
 
 [staticPicture processImage];
 
 //6, 获取图片
 preImage = [pipeline currentFilteredFrame];
 */
@end
