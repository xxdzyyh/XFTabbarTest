//
//  MainViewController.m
//  XYProject
//
//  Created by wangxuefeng on 16/10/8.
//  Copyright © 2016年 wangxuefeng. All rights reserved.
//

#import "MainViewController.h"

#import "NumberViewController.h"
#import <Aspects/Aspects.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <RDVTabBarItem.h>
#import "UIViewController+TabBar.h"
#import "XYTabBar.h"
#import <Masonry.h>


@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupViewControllers];
    [self setupTabBar:[self tabBar]];
}


- (void)setupViewControllers {

    NumberViewController * zore = [NumberViewController new];
    zore.label.text = @"0";
    
    NumberViewController * one = [NumberViewController new];
    one.label.text = @"1";
    
    NumberViewController * two = [NumberViewController new];
    two.label.text = @"0";
    
    NumberViewController * three = [NumberViewController new];
    three.label.text = @"1";


    NSArray *viewCtrs = @[zore, one, two, three];
    
    NSMutableArray *navigations = [[NSMutableArray alloc] init];
    
    for (UIViewController * obj in viewCtrs) {
        UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:obj];
        

        navigation.navigationBar.barTintColor = [UIColor whiteColor];
        navigation.navigationBar.tintColor = [UIColor blackColor];
        navigation.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18],
                                                          NSForegroundColorAttributeName:[UIColor blackColor]};
        
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
    
    [tabBar setFrame:CGRectMake(0, 0, 320, 49)];
    
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
                                           NSForegroundColorAttributeName:[UIColor blackColor],
                                           };
    }

}

- (void)aspect_viewDidLoad:(UIViewController *)controller {
    
    controller.automaticallyAdjustsScrollViewInsets = NO;

    controller.falseTabBar = [[XYTabBar alloc] initWithFrame:CGRectMake(0, 320-64-49, 320, 49)];

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

- (void)aspect_ViewWillDidAppear:(UIViewController *)controller {
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
