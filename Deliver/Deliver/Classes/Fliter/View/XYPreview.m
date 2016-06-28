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
    if ([filterItem.imageFilter isKindOfClass:[GPUImageRGBFilter class]]) {//reb
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
@end
