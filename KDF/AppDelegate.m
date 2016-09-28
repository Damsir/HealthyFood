//
//  AppDelegate.m
//  KDF
//
//  Created by qianfeng on 16/1/6.
//  Copyright © 2016年 kongdefu. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//     [NSThread sleepForTimeInterval:0.5];//设置启动页面时间
    /**
     *  申请qq，微信的id，key
     */
//    [UMSocialData setAppKey:@"5618d24ee0f55aefc20014ca"];
//    //设置微信AppID
//    [UMSocialWechatHandler setWXAppId:@"wxf44eb217b658111a" appSecret:@"1d21603ed15ef71ce5bd210be46e6286" url:@"http://www.sfd.com"];
//    //qq的AppID
//    [UMSocialQQHandler setQQWithAppId:@"1104824127" appKey:@"o5S8Q3MGrk6ubPv8" url:@"http://www.sfd.com"];
//    
//    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline]];
    return YES;
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

//-(BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options{
//    return [UMSocialSnsService handleOpenURL:url];
//}
@end
