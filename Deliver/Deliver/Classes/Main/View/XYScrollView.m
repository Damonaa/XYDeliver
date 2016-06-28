//
//  XYScrollView.m
//  Deliver
//
//  Created by 李小亚 on 16/5/31.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#define XYMaxScale 2.5
#define XYMinScale 0.5

#import "XYScrollView.h"
#import "XYImageView.h"
#import "XYTextView.h"
#import "XYVerticalTextView.h"

@interface XYScrollView ()<UIScrollViewDelegate>

/**
 *  放置图片的容器
 */
@property (nonatomic, weak) UIScrollView *containScrollView;
/**
 *  展示图片
 */
@property (nonatomic, weak) XYImageView *imageView;


@end

@implementation XYScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupAllChildView];
        
    }
    return self;
}

#warning background color
- (void)setupAllChildView{
    UIScrollView *containScrollView = [[UIScrollView alloc] init];
    [self addSubview:containScrollView];
    self.containScrollView = containScrollView;

//    containScrollView.backgroundColor = [UIColor magentaColor];
    
    containScrollView.delegate = self;
    containScrollView.maximumZoomScale = XYMaxScale;
    containScrollView.minimumZoomScale = XYMinScale;
    containScrollView.zoomScale = 1.0;
    containScrollView.bounces = NO;
    
    XYImageView *imageView = [[XYImageView alloc] init];
    self.imageView = imageView;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [containScrollView addSubview:imageView];
    imageView.userInteractionEnabled = YES;
    imageView.hidden = YES;
//    imageView.backgroundColor = [UIColor orangeColor];
    
    XYTextView *textView = [[XYTextView alloc] init];
    self.textView = textView;
    [self addSubview:textView];
//    textView.backgroundColor = [UIColor brownColor];
    textView.hidden = YES;
    textView.textViewResopne = ^(XYTextView *textView){
        if (_currentSV) {
            _currentSV(self);
        }
    };
    
    XYVerticalTextView *verticalTextView = [[XYVerticalTextView alloc] init];
    self.verticalTextView = verticalTextView;
//    verticalTextView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:verticalTextView];
    verticalTextView.hidden = YES;
    verticalTextView.verticalTV = ^(XYVerticalTextView *verticalTV){
        if (_currentSV) {
            _currentSV(self);
        }
    };
}

//布局子控件位置
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat svMargin = 5 + XYBoundaryMarignLine;
    self.containScrollView.frame = CGRectMake(svMargin, svMargin, self.width - svMargin * 2, self.height - svMargin * 2);
    _imageView.frame = _containScrollView.bounds;

    
    CGFloat textMagin = 10 + XYBoundaryMarignLine;
    CGRect textRect = CGRectMake(textMagin, textMagin, self.width - textMagin * 2, self.height - textMagin * 2);
    _textView.frame = textRect;
    _verticalTextView.frame = textRect;
}

//为图片赋值
- (void)setImage:(UIImage *)image{
    _image = image;
    _imageView.image = image;

    if (image == nil) {
        _imageView.hidden = YES;
    }else{
        _imageView.hidden = NO;
        //图片视图置顶
        [self bringSubviewToFront:_imageView];
    }
    
}


#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}
// 让UIImageView在UIScrollView缩放后居中显示
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    _imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                    scrollView.contentSize.height * 0.5 + offsetY);
}

@end
