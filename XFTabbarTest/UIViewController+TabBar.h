//
//  UIViewController+TabBar.h
//  XYProject
//
//  Created by wangxuefeng on 16/11/8.
//  Copyright © 2016年 wangxuefeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <RDVTabBarController/RDVTabBarController.h>

@interface UIViewController (TabBar)

- (void)hideTabbar;

- (void)showTabbar;

@property (strong, nonatomic) RDVTabBar *falseTabBar;

@end
