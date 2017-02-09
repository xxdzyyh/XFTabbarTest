//
//  AppDelegate.m
//  XFTabbarTest
//
//  Created by wangxuefeng on 17/2/9.
//  Copyright © 2017年 wangxuefeng. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window.rootViewController = [MainViewController new];
    

    [self.window makeKeyAndVisible];

    return YES;
}


- (UIWindow *)window {
    if (_window == nil) {
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        _window.backgroundColor = [UIColor whiteColor];
    }
    return _window;
}


@end
