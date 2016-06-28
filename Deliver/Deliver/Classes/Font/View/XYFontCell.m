//
//  XYFontCell.m
//  Deliver
//
//  Created by 李小亚 on 16/6/17.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYFontCell.h"
#import "XYFont.h"
#import <CoreText/CoreText.h>
#import "XYReachabilityTool.h"
#import "XYCircleProgress.h"
#import "XYFontTool.h"
#import "NSString+XY.h"

@interface XYFontCell ()
/**
 *  字体名称
 */
@property (nonatomic, weak) UILabel *nameLabel;
/**
 *  字体状态，已下载，未下载
 */
@property (nonatomic, weak) UIButton *conditionBtn;
/**
 *  圆形进度条
 */
@property (nonatomic, weak) XYCircleProgress *circleProgress;

/**
 *  总的下载进度
 */
@property (nonatomic, assign) float totalProgress;

@end

@implementation XYFontCell

+ (instancetype)fontCellWithTableView:(UITableView *)tableView{
    static NSString *reusedCell = @"eventCell";
    XYFontCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedCell];
    
    if (!cell) {
        cell = [[XYFontCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedCell];
    }
    return cell;
}


//自定义布局cell的控件
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //设置子控件
        [self setupAllChildView];

    }
    return self;
}
//设置子控件
- (void)setupAllChildView{
    //name lable
    UILabel *nameLabel = [[UILabel alloc] init];
    self.nameLabel = nameLabel;
    [self.contentView addSubview:nameLabel];
    
    //字体状态按钮，已下载，未下载
    UIButton *conditionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.conditionBtn = conditionBtn;
    [self.contentView addSubview:conditionBtn];
    [conditionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [conditionBtn addTarget:self action:@selector(clickConditionBtn) forControlEvents:UIControlEventTouchUpInside];
    //进度条
    XYCircleProgress *circleProgress = [[XYCircleProgress alloc] init];
    [self.contentView addSubview:circleProgress];
    self.circleProgress = circleProgress;
    circleProgress.backgroundColor = [UIColor lightGrayColor];
    circleProgress.hidden = YES;
}

//赋值，布局
- (void)setFont:(XYFont *)font{
    _font = font;
    
    _nameLabel.text = font.fontName;
    //设置字体,若已经下载，则应用
    if ([font.hasDownloaded boolValue]) {
        [self asynchronouslySetFontName:font.simplifiedNormalfaced];
//        [XYFontTool setLabel:_nameLabel fontName:font.simplifiedNormalfaced];
    }
    
    [_nameLabel sizeToFit];
    _nameLabel.x = 10;
    _nameLabel.y = (self.contentView.height - _nameLabel.height) / 2;;
    
    BOOL isDownloaded = [font.hasDownloaded boolValue];
    NSString *conditionStr = isDownloaded ? @"应用" : @"下载";
    [_conditionBtn setTitle:conditionStr forState:UIControlStateNormal];
    [_conditionBtn sizeToFit];
    _conditionBtn.x = XYScreenWidth - _conditionBtn.width - 10;
    _conditionBtn.y = (self.contentView.height - _conditionBtn.height) / 2;
    
    _circleProgress.width = 30;
    _circleProgress.height = 30;
    _circleProgress.x = _conditionBtn.x;
    _circleProgress.y = (self.contentView.height - _circleProgress.height) / 2;
}

#pragma mark - 下载应用按钮的点击
- (void)clickConditionBtn{
    if (self.font.hasDownloaded) {//应用
        
        //保存当前设置的字体 到单例中
//        [XYFontTool shareFontTool].fontItem = _font;
        //发出通知，修改字体
        [[NSNotificationCenter defaultCenter] postNotificationName:XYChangeFont object:self userInfo:@{XYChangeFont:_font}];
        
        //保存到偏好设置字体
        [[NSUserDefaults standardUserDefaults] setObject:_font.fontTag forKey:XYFontTag];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{//下载
        
        //检测网络
        NSInteger status = [XYReachabilityTool netWorkStatus];
        
        if (status == 0) {//无网络
            XYLog(@"无网络");
            return;
        }
        if (_font.simplifiedNormalfaced) {//简体常规体
            [self asynchronouslySetFontName:_font.simplifiedNormalfaced];
        }
        if (_font.simplifiedBoldfaced) {//简体粗体
            [self asynchronouslySetFontName:_font.simplifiedBoldfaced];
        }
        if (_font.traditionalNormalfaced) {//繁体常规体
            [self asynchronouslySetFontName:_font.traditionalNormalfaced];
        }
        if (_font.traditionalBoldfaced) {//繁体粗体
            [self asynchronouslySetFontName:_font.traditionalBoldfaced];
        }
    }
}

//异步下载字体
- (void)asynchronouslySetFontName:(NSString *)fontName
{
    UIFont* aFont = [UIFont fontWithName:fontName size:15.];
    //如果字体已经被下载
    if (aFont && ([aFont.fontName compare:fontName] == NSOrderedSame || [aFont.familyName compare:fontName] == NSOrderedSame)) {
        // 直接展示示例,应用
        _nameLabel.font = aFont;
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
        
        //NSLog( @"state %d - %@", state, progressParameter);
        
        double progressValue = [[(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingPercentage] doubleValue];
        
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
                    //累加总下载的进度
//                    _totalProgress += 1 / [_font.typeCount intValue] * 1.0;
                    _nameLabel.font = [UIFont fontWithName:fontName size:15.];
                    [_conditionBtn setTitle:@"应用" forState:UIControlStateNormal];
                    self.font.hasDownloaded = [NSNumber numberWithBool:YES];

                }
            });
        } else if (state == kCTFontDescriptorMatchingWillBeginDownloading) {//即将开始下载
            dispatch_async( dispatch_get_main_queue(), ^ {
                _circleProgress.hidden = NO;
                _conditionBtn.hidden = YES;
                NSLog(@"Begin Downloading开始下载");
            });
        } else if (state == kCTFontDescriptorMatchingDidFinishDownloading) {//下载结束
            dispatch_async( dispatch_get_main_queue(), ^ {
                _conditionBtn.hidden = NO;
                _circleProgress.hidden = YES;
                NSLog(@"Finish downloading结束下载");
            });
        } else if (state == kCTFontDescriptorMatchingDownloading) {//下载中ing
            dispatch_async( dispatch_get_main_queue(), ^ {
                _circleProgress.progress = progressValue / 100.0;
                NSLog(@"Downloading %.0f%% complete", progressValue);
            });
        } else if (state == kCTFontDescriptorMatchingDidFailWithError) {//下载出错
            NSError *error = [(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingError];
            if (error != nil) {
                //                _errorMessage = [error description];
            } else {
                //                _errorMessage = @"ERROR MESSAGE IS NOT AVAILABLE!";
            }
            // Set our flag
            errorDuringDownload = YES;
            
            dispatch_async( dispatch_get_main_queue(), ^ {
                //                _fProgressView.hidden = YES;
                NSLog(@"下载出错Download error: %@", error);
            });
        }
        
        return (bool)YES;
    });
}
@end
