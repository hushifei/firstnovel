//
//  CKAppDelegate.m
//  firstNovel
//
//  Created by followcard on 1/11/14.
//  Copyright (c) 2014 followcard. All rights reserved.
//

#import "CKAppDelegate.h"
#import "CKRootViewController.h"
#import "BBANetworkManager.h"
#import "CKFileManager.h"
#import "MobClick.h"
#import "CKAppSettings.h"
#import "CKUrlManager.h"
#import "wax.h"
#import "UMFeedback.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation CKAppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initWorks];
    
//    Class uiview = objc_getClass("UIView");
//    unsigned int count = 0;
//    Method*    methods= class_copyMethodList(uiview, &count);
//    NSLog(@"%d", count);
//    for (int i = 0; i < count ; i++)
//    {
//        SEL name = method_getName(methods[i]);
//        NSString *strName = [NSString  stringWithCString:sel_getName(name) encoding:NSUTF8StringEncoding];
//        NSLog(@"%@",strName);
//    }
    
    wax_init();
    wax_run("run.lua");
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.rootViewController = [CKRootViewController sharedInstance];;
    [_window makeKeyAndVisible];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[CKAppSettings sharedInstance] saveAppSettingWithKey:APPSETTINGS_LASTREAD_INDEX Value:[NSNumber numberWithInteger:[[CKAppSettings sharedInstance] lastReadIndex]]];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [MobClick updateOnlineConfig];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)initWorks
{
    [self initUMeng];
    
    // 检查网络
    [[BBANetworkManager sharedInstance] startDetectNetwork];
    
    dispatch_async(GCD_GLOBAL_QUEUQ, ^{
        NSString *userAgent = [[CKUrlManager sharedInstance] composeUserAgentParameter];
        NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:userAgent, @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
        [dictionary release];
    });
}

- (void)initUMeng
{
    [MobClick setCrashReportEnabled:YES];
    //[MobClick setLogEnabled:YES];
    [MobClick setAppVersion:XcodeAppVersion];
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) SEND_INTERVAL channelId:UMENG_APPSTORE];
    [MobClick updateOnlineConfig];  //在线参数配置
    [MobClick setLogSendInterval:600.0f];
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [MobClick checkUpdate];
    });
    [UMFeedback sharedInstance];
}

@end
