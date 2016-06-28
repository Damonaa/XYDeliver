//
//  XYFontTool.m
//  Deliver
//
//  Created by 李小亚 on 16/6/18.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYFontTool.h"
#import <CoreText/CoreText.h>
#import "XYTextView.h"
#import "NSString+XY.h"

@implementation XYFontTool
static XYFontTool *fontTool;
+ (instancetype)shareFontTool{
    if (fontTool == nil) {
        fontTool = [[XYFontTool alloc] init];
    }
    return fontTool;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fontTool = [super allocWithZone:zone];
    });
    return fontTool;
}

+ (XYFont *)standardUserDefultFont{
    NSArray *tempFonts = [NSKeyedUnarchiver unarchiveObjectWithFile:[NSString fontArrayDir]];
    int index = [[[NSUserDefaults standardUserDefaults] objectForKey:XYFontTag] intValue];
    
    return tempFonts[index];
}
//异步下载字体
+ (void)setTextView:(XYTextView *)textView fontName:(NSString *)fontName
{
    CGFloat fontSize = [[[NSUserDefaults standardUserDefaults] objectForKey:XYFontSize] floatValue];
    if (fontSize == 0) {
        fontSize = 15.0;
    }
    UIFont* aFont = [UIFont fontWithName:fontName size:fontSize];
    //如果字体已经被下载
    if (aFont && ([aFont.fontName compare:fontName] == NSOrderedSame || [aFont.familyName compare:fontName] == NSOrderedSame)) {
        // 直接展示示例,应用
        textView.font = aFont;
        return;
    }
    
    //用字体的PostScript名创建一个字典
    NSMutableDictionary *attrs = [NSMutableDictionary dictionaryWithObjectsAndKeys:fontName, kCTFontNameAttribute, nil];
    //创建一个字体描述对象CTFontDescriptorRef
    CTFontDescriptorRef desc = CTFontDescriptorCreateWithAttributes((__bridge CFDictionaryRef)attrs);
    //将字体描述对象放到数组中
    NSMutableArray *descs = [NSMutableArray arrayWithCapacity:0];
    [descs addObject:(__bridge id)desc];
    CFRelease(desc);
    
    __block BOOL errorDuringDownload = NO;
    CTFontDescriptorMatchFontDescriptorsWithProgressHandler( (__bridge CFArrayRef)descs, NULL,  ^(CTFontDescriptorMatchingState state, CFDictionaryRef progressParameter) {
        if (state == kCTFontDescriptorMatchingDidBegin) {//已经开始下载
            dispatch_async( dispatch_get_main_queue(), ^ {
                NSLog(@"Begin Matching，字体已经匹配");
            });
        } else if (state == kCTFontDescriptorMatchingDidFinish) {//下载结束
            dispatch_async( dispatch_get_main_queue(), ^ {
                CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)fontName, 0., NULL);
                CFStringRef fontURL = CTFontCopyAttribute(fontRef, kCTFontURLAttribute);
                //                NSLog(@"%@", (__bridge NSURL*)(fontURL));
                CFRelease(fontURL);
                CFRelease(fontRef);
                
                if (!errorDuringDownload) {
                    NSLog(@"%@ downloaded下载成功", fontName);
                    
                    textView.font = [UIFont fontWithName:fontName size:fontSize];
                    
                }
            });
        }
        
        return (bool)YES;
    });
}

//异步下载字体
+ (void)setLabel:(UILabel *)label fontName:(NSString *)fontName
{
    UIFont* aFont = [UIFont fontWithName:fontName size:15.];
    //如果字体已经被下载
    if (aFont && ([aFont.fontName compare:fontName] == NSOrderedSame || [aFont.familyName compare:fontName] == NSOrderedSame)) {
        // 直接展示示例,应用
        label.font = aFont;
        return;
    }
    
    //用字体的PostScript名创建一个字典
    NSMutableDictionary *attrs = [NSMutableDictionary dictionaryWithObjectsAndKeys:fontName, kCTFontNameAttribute, nil];
    //创建一个字体描述对象CTFontDescriptorRef
    CTFontDescriptorRef desc = CTFontDescriptorCreateWithAttributes((__bridge CFDictionaryRef)attrs);
    //将字体描述对象放到数组中
    NSMutableArray *descs = [NSMutableArray arrayWithCapacity:0];
    [descs addObject:(__bridge id)desc];
    CFRelease(desc);
    
    __block BOOL errorDuringDownload = NO;
    CTFontDescriptorMatchFontDescriptorsWithProgressHandler( (__bridge CFArrayRef)descs, NULL,  ^(CTFontDescriptorMatchingState state, CFDictionaryRef progressParameter) {
        if (state == kCTFontDescriptorMatchingDidBegin) {//已经开始下载
            dispatch_async( dispatch_get_main_queue(), ^ {
                NSLog(@"Begin Matching，字体已经匹配");
            });
        } else if (state == kCTFontDescriptorMatchingDidFinish) {//下载结束
            dispatch_async( dispatch_get_main_queue(), ^ {
                CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)fontName, 0., NULL);
                CFStringRef fontURL = CTFontCopyAttribute(fontRef, kCTFontURLAttribute);
                //                NSLog(@"%@", (__bridge NSURL*)(fontURL));
                CFRelease(fontURL);
                CFRelease(fontRef);
                
                if (!errorDuringDownload) {
                    NSLog(@"%@ downloaded下载成功", fontName);
                    
                    label.font = [UIFont fontWithName:fontName size:15.];
                    
                }
            });
        }
        
        return (bool)YES;
    });
}


@end
