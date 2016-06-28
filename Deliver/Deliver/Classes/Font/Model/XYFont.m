//
//  XYFont.m
//  Deliver
//
//  Created by 李小亚 on 16/6/17.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYFont.h"
#import <objc/runtime.h>

@implementation XYFont

+ (instancetype)fontWithName:(NSString *)fontName simplifiedNormalfaced:(NSString *)simplifiedNormalfaced simplifiedBoldfaced:(NSString *)simplifiedBoldfaced traditionalNormalfaced:(NSString *)traditionalNormalfaced traditionalBoldfaced:(NSString *)traditionalBoldfaced  typeCount:(int)typeCount fontTag:(int)fontTag{
    XYFont *font = [[self alloc] init];
    font.fontName = fontName;
    font.simplifiedNormalfaced = simplifiedNormalfaced;
    font.simplifiedBoldfaced = simplifiedBoldfaced;
    font.traditionalNormalfaced = traditionalNormalfaced;
    font.traditionalBoldfaced = traditionalBoldfaced;
    font.typeCount = [NSNumber numberWithInt:typeCount];
    font.fontTag = [NSNumber numberWithInt:fontTag];
    return font;
}


- (NSArray *)ignoredNames{
    return nil;
}

#pragma mark - 归档&解档
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
//    if (self = [super initWithCoder:aDecoder]) {
        unsigned int outCount = 0;
        Ivar *ivars = class_copyIvarList([self class], &outCount);
        
        for (int i = 0; i < outCount; i ++) {
            Ivar ivar = ivars[i];
            
            //将成员变量名转换为NSSting对象
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            //忽略不需要解档的属性
            if ([[self ignoredNames] containsObject:key]) {
                continue;
            }
            //根据变量名解档取值，无论是什么类型
            id value = [aDecoder decodeObjectForKey:key];
            //取出来的值再给属性赋值
            [self setValue:value forKey:key];
            
        }
        free(ivars);
        
//    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)aCoder{
    unsigned int outCount = 0;
    Ivar *ivars = class_copyIvarList([self class], &outCount);
    
    for (int i = 0; i < outCount; i ++) {
        Ivar ivar = ivars[i];
        //
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        
        if ([[self ignoredNames] containsObject:key]) {
            continue;
        }
        
        id value = [self valueForKey:key];
        
        [aCoder encodeObject:value forKey:key];
    }
    
    free(ivars);
    
}

@end
