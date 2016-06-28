//
//  XYFontTool.h
//  Deliver
//
//  Created by 李小亚 on 16/6/18.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XYTextView, XYFont;

@interface XYFontTool : NSObject

@property (nonatomic, strong) XYFont *fontItem;
/**
 *  是否是粗体， 默认NO
 */
@property (nonatomic, assign, getter=isBoldFont) BOOL boldFont;
/**
 *  是否是繁体字，默认NO
 */
@property (nonatomic, assign, getter=isTraditionalFont) BOOL traditionalFont;


+ (instancetype)shareFontTool;

+ (XYFont *)standardUserDefultFont;

/**
 *  设置textView的字体
 *
 *  @param textView 
 *  @param fontName 字体代码
 */
+ (void)setTextView:(XYTextView *)textView fontName:(NSString *)fontName;


+ (void)setLabel:(UILabel *)label fontName:(NSString *)fontName;
@end
