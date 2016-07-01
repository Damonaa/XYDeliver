//
//  XYShareTool.m
//  Deliver
//
//  Created by 李小亚 on 16/6/29.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYShareTool.h"
#import "UMSocial.h"

@implementation XYShareTool

+ (void)shareToAppWingName:(NSString *)name image:(UIImage *)image text:(NSString *)text viewController:(UIViewController *)viewController{
    [[UMSocialControllerService defaultControllerService] setShareText:text shareImage:image socialUIDelegate:nil];
    
    //如果是朋友圈的分享
    if ([name isEqualToString:@"wxtimeline"]) {//朋友圈支持纯文本
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
//        [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"微信朋友圈分享";
    }else if ([name isEqualToString:@"qzone"]){//QQ空间， 微博，图文缺一不可
        [UMSocialData defaultData].extConfig.qzoneData.title = @"QQ空间分享";
    }
    
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:name];
    snsPlatform.snsClickHandler(viewController,[UMSocialControllerService defaultControllerService],YES);
}

@end
