//
//  XYFilter.m
//  Deliver
//
//  Created by 李小亚 on 16/6/22.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYFilter.h"

@implementation XYFilter

+ (instancetype)filterWithOriginalImage:(UIImage *)originalImage filter:(GPUImageFilter *)imageFilter red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue title:(NSString *)title{
    XYFilter *filter = [[self alloc] init];
    filter.originalImage = originalImage;
    filter.imageFilter = imageFilter;
    filter.red = red;
    filter.green = green;
    filter.blue = blue;
    filter.title = title;
    return filter;
}


+ (instancetype)filterWithOriginalImageData:(NSData *)imageData title:(NSString *)title{
    XYFilter *filter = [[self alloc] init];
    filter.imageData = imageData;
    filter.title = title;
    return filter;
}

+ (instancetype)filterWithOriginalImage:(UIImage *)originalImage title:(NSString *)title{
    XYFilter *filter = [[self alloc] init];
    filter.originalImage = originalImage;
    filter.title = title;
    return filter;
}
@end
