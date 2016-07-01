//
//  XYPreviewsView.m
//  Deliver
//
//  Created by 李小亚 on 16/6/22.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYPreviewsView.h"
#import "XYPreview.h"
#import "XYFilter.h"

@interface XYPreviewsView ()<XYPreviewDelegate>
/**
 *  选中的预览图
 */
@property (nonatomic, weak) XYPreview *selectedPreview;

@end

@implementation XYPreviewsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupChildView];
        self.showsHorizontalScrollIndicator = NO;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
//添加子控件
- (void)setupChildView{
    
}
//创建子控件，赋值 布局
- (void)setPreviews:(NSArray *)previews{
    _previews = previews;
    
    CGFloat previewW = 66;
    CGFloat margin = 10;
    
    NSInteger count = previews.count;
    for (NSInteger i = 0; i < count; i ++) {
        XYPreview *preview = [[XYPreview alloc] init];
        [self addSubview:preview];
        preview.delegate = self;
        if (i == 0) {
            preview.selected = YES;
        }
        
        //frame
        preview.width = previewW;
        preview.height = self.height;
        preview.y = 0;
        preview.x = margin + (previewW + margin) * i;
        //赋值
        XYFilter *filter = previews[i];
        preview.filterItem = filter;
    }
    
    CGFloat maxSizeW = (previewW + margin) * previews.count + margin;
    self.contentSize = CGSizeMake(maxSizeW, 0);
}


#pragma mark - XYPreviewDelegate
- (void)preview:(XYPreview *)preview didTapImage:(UIImage *)image{
    
    if (self.selectedPreview == nil) {
        self.selectedPreview = self.subviews[0];
    }
    
    self.selectedPreview.selected = NO;
    preview.selected = YES;
    self.selectedPreview = preview;
}

- (void)dealloc{
    XYLog(@"XYPreviewsView.h 销毁");
}
@end
