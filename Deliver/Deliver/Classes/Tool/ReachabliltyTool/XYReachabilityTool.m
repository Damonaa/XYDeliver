//
//  XYReachabilityTool.m
//  XYNetEasyNews
//
//  Created by 李小亚 on 16/5/24.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYReachabilityTool.h"
#import "Reachability.h"

@interface XYReachabilityTool ()

//@property (nonatomic) Reachability *hostReachability;

@end

@implementation XYReachabilityTool

//static Reachability *hostReachability;
//static NetworkStatus netStatus;
//
//+ (void)initialize{
////    NSString *remoteHostName = @"www.baidu.com";
////    hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
////    [hostReachability startNotifier];
////    netStatus = [hostReachability currentReachabilityStatus];
////    [self updateInterfaceWithReachability:hostReachability];
//}

+ (NSInteger)netWorkStatus{
    
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];  // 测试服务器状态
    switch ([reachability currentReachabilityStatus])
    {
        case NotReachable:{
            return 0;
            break;
        }
            
        case ReachableViaWWAN:{
            return 1;
            break;
        }
        case ReachableViaWiFi:{
            return 2;
            break;
        }
    }
    return 0;
}

@end
