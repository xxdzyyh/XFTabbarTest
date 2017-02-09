//
//  MainViewController.m
//  XYProject
//
//  Created by wangxuefeng on 16/10/8.
//  Copyright © 2016年 wangxuefeng. All rights reserved.
//

#import "MainViewController.h"

#import <XFFoundation/XFFoundation.h>
#import <XFNavigationController.h>

#import "XYXiaoYuanViewController.h"
#import "XYXiaoXiViewController.h"
#import "XYKeTangViewController.h"
#import "XYMeTableViewController.h"
#import "CommonDefines.h"
#import <RDVTabBarItem.h>
#import "ColorDefines.h"
#import "AccountManager.h"
#import "MBProgressHUD.h"
#import "XYChatHelper.h"
#import <Aspects/Aspects.h>
#import "UIViewController+TabBar.h"
#import "AccountManager.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry/Masonry.h>
#import "XYTabBar.h"
#import "XYKeTangAllCategoriesViewController.h"
#import "XYFabuZoreViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupViewControllers];
    [self setupTabBar:[self tabBar]];
}

#pragma mark - event response

// 发布文章
- (void)commitArticle {
    XYFabuZoreViewController *c = [XYFabuZoreViewController new];
    
    c.blurBackgroundImage = [self getImageFromView:self.view];
    
    XFNavigationController *nav = [[XFNavigationController alloc] initWithRootViewController:c];
    
    nav.navigationBar.barTintColor = [UIColor whiteColor];
    nav.navigationBar.tintColor = k1TextColor;
    nav.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18],
                                                     NSForegroundColorAttributeName:k1TextColor};
    
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)setupViewControllers {
    // 晓园
    XYXiaoYuanViewController *t0 = [[XYXiaoYuanViewController alloc] initWithPath:@"article/mySchoolAricleList" params:nil];
    t0.showRightBarItem = YES;
    t0.shouldShowCustomTitleView = YES;
    
    
    // 课堂
    XYKeTangViewController *t3 = [[XYKeTangViewController alloc] init];
    // +
    
    // 消息
    XYXiaoXiViewController *t1 = [XYXiaoXiViewController new];
    [XYChatHelper sharedChatHelper].conversationVC = t1;
    
    // 我的
    XYMeTableViewController *t4 = [[XYMeTableViewController alloc] init];
    
    NSArray *viewCtrs = @[t0,t1, t3, t4];
    
    NSMutableArray *navigations = [[NSMutableArray alloc] init];
    
    for (UIViewController * obj in viewCtrs) {
        XFNavigationController *navigation = [[XFNavigationController alloc] initWithRootViewController:obj];
        
        [XFLineHelper addBottomLineToView:navigation.navigationBar];
        
        navigation.navigationBar.barTintColor = [UIColor whiteColor];
        navigation.navigationBar.tintColor = k1TextColor;
        navigation.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18],
                                                          NSForegroundColorAttributeName:k1TextColor};
        
        [navigations addObject:navigation];
        
        [obj aspect_hookSelector:@selector(viewDidLoad) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo>aspectInfo) {
            
            [self aspect_viewDidLoad:[aspectInfo instance]];
        } error:NULL];
        
        [obj aspect_hookSelector:@selector(viewDidAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo>aspectInfo) {
        
            [self aspect_ViewWillDidAppear:[aspectInfo instance]];
        } error:NULL];
    }
    
    self.viewControllers = navigations;
}

- (void)setupTabBar:(RDVTabBar *)tabBar {
    NSArray *titles = @[@"晓园", @"消息", @"课堂", @"我"];
    
    [tabBar setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49)];
    
    for (int index=0; index<tabBar.items.count;index++) {
        RDVTabBarItem *item = tabBar.items[index];
        
        item.title = titles[index];
        
        item.imagePositionAdjustment = UIOffsetMake(0, -3);
        item.titlePositionAdjustment = UIOffsetMake(0, 3);
        
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"tab_%d_select",index]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"tab_%d_normal",index]];
        
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];

        item.selectedTitleAttributes = @{
                                         NSFontAttributeName: [UIFont systemFontOfSize:11],
                                         NSForegroundColorAttributeName:[UIColor colorWithRed:0.169 green:0.224 blue:0.278 alpha:1.00],
                                         };
        item.unselectedTitleAttributes = @{
                                           NSFontAttributeName: [UIFont systemFontOfSize:11],
                                           NSForegroundColorAttributeName:k1TextColor,
                                           };
    }
    
    [XFLineHelper addTopLineToView:tabBar];
}

- (void)showInfoWithStatus:(NSString *)status {
    if (status.length ==0) {
        return;
    }
    
    float h = [UIScreen mainScreen].bounds.size.height;
    
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;
    hud.labelText = status;
    hud.margin = 10.f;
    hud.yOffset = h/2 - 100;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:1.5];
}

- (BOOL)tabBar:(RDVTabBar *)tabBar shouldSelectItemAtIndex:(NSInteger)index {
    BOOL isLogin = [AccountManager shareManager].isLogin;
    
    if (isLogin == NO) {
        [[AccountManager shareManager] showLoginView];
    }
    
    return isLogin;
}

- (void)aspect_viewDidLoad:(XFViewController *)controller {
    
    controller.automaticallyAdjustsScrollViewInsets = NO;

    controller.falseTabBar = [[XYTabBar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64-49, SCREEN_WIDTH, 49)];

    NSMutableArray *temp = [NSMutableArray array];
    
    for (int i=0; i<[self tabBar].items.count; i++) {
        RDVTabBarItem *item = [RDVTabBarItem new];
        
        [temp addObject:item];
    }
    
    controller.falseTabBar.items = temp;
    
    [self setupTabBar:controller.falseTabBar];
    
    [controller.view addSubview:controller.falseTabBar];
    
    [controller.falseTabBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.equalTo(controller.view);
        make.height.mas_equalTo(49);
    }];
    
    [RACObserve(controller.rdv_tabBarController, tabBarHidden) subscribeNext:^(id x) {
        
        [controller.falseTabBar mas_updateConstraints:^(MASConstraintMaker *make) {
            
            float h = [x boolValue] ? 49 : 0;
            
            make.height.mas_equalTo(h);
        }];
    }];
    
    [RACObserve(controller.rdv_tabBarController, selectedIndex) subscribeNext:^(id x) {
        
        controller.falseTabBar.selectedItem = controller.falseTabBar.items[[x integerValue]];
    }];
}

- (void)aspect_ViewWillDidAppear:(XFViewController *)controller {
    [controller showTabbar];
}

//将UIView转成UIImage
-(UIImage *)getImageFromView:(UIView *)theView {
    //UIGraphicsBeginImageContext(theView.bounds.size);
    UIGraphicsBeginImageContextWithOptions(theView.bounds.size, YES, theView.layer.contentsScale);
    
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark -  setter & getter

- (RDVTabBar *)tabBar {
    RDVTabBar *tabbar = [super tabBar];
    
    if ([tabbar isKindOfClass:[XYTabBar class]] == NO || tabbar == nil) {
        tabbar = [XYTabBar new];
        
        [tabbar setBackgroundColor:[UIColor clearColor]];
        [tabbar setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|
                                      UIViewAutoresizingFlexibleTopMargin|
                                      UIViewAutoresizingFlexibleLeftMargin|
                                      UIViewAutoresizingFlexibleRightMargin|
                                      UIViewAutoresizingFlexibleBottomMargin)];
        [tabbar setDelegate:self];
        
        [[(XYTabBar *)tabbar btnAdd] addTarget:self action:@selector(commitArticle) forControlEvents:UIControlEventTouchUpInside];
        
        [self setValue:tabbar forKey:@"tabBar"];
    }
    
    return tabbar;
}

@end
