//
//  AppDelegate.m
//  Deliver
//
//  Created by 李小亚 on 16/5/29.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "AppDelegate.h"
#import "XYMainViewController.h"
#import "XYMainNavigationController.h"
#import "UMSocial.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    XYMainViewController *mainVC = [[XYMainViewController alloc] init];
    XYMainNavigationController *mainNav = [[XYMainNavigationController alloc] initWithRootViewController:mainVC];
    self.window.rootViewController = mainNav;
    [self.window makeKeyAndVisible];
    
    //友盟APP Key
    [UMSocialData setAppKey:XYUMengAppKey];
    //新浪微博
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:XYWeiboAppKey secret:XYWeiboSecret RedirectURL:@"https://www.baidu.com"];
    //微信朋友圈
    [UMSocialWechatHandler setWXAppId:XYWeChatAppID appSecret:XYWeChatAppSecret url:@"http://www.baidu.com"];
    
    //QQ空间
    [UMSocialQQHandler setQQWithAppId:XYQZoneAppID appKey:XYQZoneAppKey url:@"http://www.baidu.com"];
    
    return YES;
}

//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
//    BOOL result = [UMSocialSnsService handleOpenURL:url];
//    XYLog(@"%@ -- %@ -- %@", app, url, options);
//    if (result == FALSE) {
//        XYLog(@"shiabi");
//    }
//    return result;
//}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    /**
     *  com.sina.weibo sourceApplication
     */
    
    XYLog(@"~~~~~%@ -- %@ -- %@ -- %@", application, url, sourceApplication, annotation);
    BOOL result = [UMSocialSnsService handleOpenURL:url];

    if (result) {
        XYLog(@"success");
        [[NSNotificationCenter defaultCenter] postNotificationName:XYShareSucceed object:self];
    }
    
    return result;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
