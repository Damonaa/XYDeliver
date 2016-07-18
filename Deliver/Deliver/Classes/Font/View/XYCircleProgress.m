//
//  XYCircleProgress.m
//  XYQuartz2dTest03
//
//  Created by 李小亚 on 1/21/16.
//  Copyright © 2016 李小亚. All rights reserved.
//

#import "XYCircleProgress.h"

@implementation XYCircleProgress


- (void)drawRect:(CGRect)rect{
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [[UIColor colorWithRed:1.000 green:0.460 blue:0.380 alpha:0.953] set];
    CGContextSetLineWidth(ctx, 3);
    
    CGFloat centerX = rect.size.width / 2;
    CGFloat centerY = rect.size.height / 2;
    
    CGFloat endAngle = M_PI * 2 * self.progress - M_PI_4;
    
    CGContextAddArc(ctx, centerX, centerY, centerX - 3, - M_PI_4, endAngle, 0);
    CGContextStrokePath(ctx);
    
//    draw string
    
//    CGFloat textW = 30;
//    CGFloat textH = 20;
//    CGFloat textX = (rect.size.width - textW) / 2;
//    CGFloat textY = (rect.size.height - textH) / 2;
//    
//    NSString *text = [NSString stringWithFormat:@"%.02f",self.progress];
//    
//    [text drawInRect:CGRectMake(textX, textY, textW, textH) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]}];
    
}

- (void)setProgress:(float)progress{
    _progress = progress;
    
    [self setNeedsDisplay];
}
@end
