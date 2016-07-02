//
//  XYReachabilityTool.h
//  XYNetEasyNews
//
//  Created by 李小亚 on 16/5/24.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Reachability;


//typedef enum : NSInteger {
//    XYNotReachable = 0,
//    XYReachableViaWiFi,
//    XYReachableViaWWAN
//} XYNetworkStatus;
//
@interface XYReachabilityTool : NSObject

+ (NSInteger)netWorkStatus;

@end
