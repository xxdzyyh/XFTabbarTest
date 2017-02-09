//
//  NumberViewController.m
//  XFTabbarTest
//
//  Created by wangxuefeng on 17/2/9.
//  Copyright © 2017年 wangxuefeng. All rights reserved.
//

#import "NumberViewController.h"
#import "UIViewController+TabBar.h"

@interface NumberViewController ()

@end

@implementation NumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    if (![self isEqual:self.navigationController.viewControllers[0]]) {
        [self hideTabbar];
    } else {
        [self showTabbar];
    }
}
- (IBAction)push:(id)sender {
    
    NumberViewController *c = [NumberViewController new];
    
    c.label.text = @"push";
    
    [self.navigationController pushViewController:c animated:YES];
}

@end
