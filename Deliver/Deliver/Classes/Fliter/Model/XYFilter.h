//
//  XYFilter.h
//  Deliver
//
//  Created by 李小亚 on 16/6/22.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GPUImageFilter;

@interface XYFilter : NSObject
/**
 *  滤镜名称
 */
@property (nonatomic, copy) NSString *title;
/**
 *  原始图片
 */
@property (nonatomic, strong) UIImage *originalImage;

/**
 *  过滤方式
 */
@property (nonatomic, strong) GPUImageFilter* imageFilter;


// Normalized values by which each color channel is multiplied. The range is from 0.0 up, with 1.0 as the default.
@property (readwrite, nonatomic) CGFloat red;
@property (readwrite, nonatomic) CGFloat green;
@property (readwrite, nonatomic) CGFloat blue;

+ (instancetype)filterWithOriginalImage:(UIImage *)originalImage filter:(GPUImageFilter *)imageFilter red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue title:(NSString *)title;

@end
