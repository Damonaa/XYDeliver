//
//  NSString+XY.m
//  Deliver
//
//  Created by 李小亚 on 16/6/18.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "NSString+XY.h"

@implementation NSString (XY)

+ (NSString *)fontArrayDir{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fontDir = [path stringByAppendingPathComponent:@"fontArray.acr"];
    return fontDir;
}

@end
