//
//  XYFont.h
//  Deliver
//
//  Created by 李小亚 on 16/6/17.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYFont : NSObject<NSCoding>
/**
 *  字体名称
 */
@property (nonatomic, copy) NSString *fontName;
/**
 *  简体粗体
 */
@property (nonatomic, copy) NSString *simplifiedBoldfaced;
/**
 *  简体常规体
 */
@property (nonatomic, copy) NSString *simplifiedNormalfaced;
/**
 *  繁体粗体
 */
@property (nonatomic, copy) NSString *traditionalBoldfaced;
/**
 *  繁体常规体
 */
@property (nonatomic, copy) NSString *traditionalNormalfaced;
/**
 *  字体是否已经下载，默认NO
 */
//@property (nonatomic, assign, getter=hasDownloaded) BOOL downloaded;
/**
 *  数字型bool
 */
@property (nonatomic, strong) NSNumber *hasDownloaded;
/**
 *  字体类型个数
 */
@property (nonatomic, strong) NSNumber *typeCount;
/**
 *  字体的标签
 */
@property (nonatomic, strong) NSNumber *fontTag;

/**
 *  类方法初始化
 *
 *  @param fontName               字体名称
 *  @param simplifiedNormalfaced  简体常规体
 *  @param simplifiedBoldfaced    简体粗体
 *  @param traditionalNormalfaced 繁体粗体
 *  @param traditionalBoldfaced   繁体常规体
 *
 *  @return 字体
 */
+ (instancetype)fontWithName:(NSString *)fontName simplifiedNormalfaced:(NSString *)simplifiedNormalfaced simplifiedBoldfaced:(NSString *)simplifiedBoldfaced traditionalNormalfaced:(NSString *)traditionalNormalfaced traditionalBoldfaced:(NSString *)traditionalBoldfaced typeCount:(int)typeCount fontTag:(int)fontTag;
@end
