//
//  UIViewController+TabBar.m
//  XYProject
//
//  Created by wangxuefeng on 16/11/8.
//  Copyright © 2016年 wangxuefeng. All rights reserved.
//

#import "UIViewController+TabBar.h"

#import <Aspects/Aspects.h>
#import <Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "CommonDefines.h"
#import <RDVTabBarItem.h>
#import "ColorDefines.h"
#import <objc/runtime.h>

@implementation UIViewController (TabBar)

static char *FalseTabbarKey = "FalseTabbarKey";

@dynamic falseTabBar;

- (void)hideTabbar {
    self.rdv_tabBarController.tabBarHidden = YES;
}

- (void)showTabbar {
    self.rdv_tabBarController.tabBarHidden = NO;
}

#pragma mark - setter & getter

- (void)setFalseTabBar:(RDVTabBar *)falseTabBar {
    [self willChangeValueForKey:@"falseTabBar"];
    
    objc_setAssociatedObject(self, FalseTabbarKey, falseTabBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self didChangeValueForKey:@"falseTabBar"];
}

- (RDVTabBar *)falseTabBar {
    
    return objc_getAssociatedObject(self, FalseTabbarKey);
}

@end
