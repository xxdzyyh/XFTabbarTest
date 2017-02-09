//
//  XYTabBar.m
//  XYProject
//
//  Created by wangxuefeng on 16/11/21.
//  Copyright © 2016年 wangxuefeng. All rights reserved.
//

#import "XYTabBar.h"
#import <RDVTabBarItem.h>

@implementation XYTabBar

- (void)layoutSubviews {
    CGSize frameSize = self.frame.size;
    CGFloat minimumContentHeight = [self minimumContentHeight];
    
    [[self backgroundView] setFrame:CGRectMake(0, frameSize.height - minimumContentHeight,
                                               frameSize.width, frameSize.height)];
    
    float itemWidth = roundf((frameSize.width - [self contentEdgeInsets].left -
                              [self contentEdgeInsets].right) / ([[self items] count]+1));
    
    NSInteger index = 0;
    
    // Layout items
    
    for (RDVTabBarItem *item in [self items]) {
        CGFloat itemHeight = [item itemHeight];
        
        if (!itemHeight) {
            itemHeight = frameSize.height;
        }
        
        [item setFrame:CGRectMake(self.contentEdgeInsets.left + (index * itemWidth),
                                  roundf(frameSize.height - itemHeight) - self.contentEdgeInsets.top,
                                  itemWidth, itemHeight - self.contentEdgeInsets.bottom)];
        [item setNeedsDisplay];
        
        index++;
        
        // 直接跳到三
        if (index == 2) {
            
            if (self.btnAdd.superview != self) {
                [self.btnAdd removeFromSuperview];
                [self addSubview:self.btnAdd];
            }
            
            [self.btnAdd setFrame:CGRectMake(self.contentEdgeInsets.left + (index * itemWidth),
                                            roundf(frameSize.height - itemHeight) - self.contentEdgeInsets.top,
                                            itemWidth, itemHeight - self.contentEdgeInsets.bottom)];
            
            index ++;
        }
    }
}

- (UIButton *)btnAdd {
    if (_btnAdd == nil) {
        _btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_btnAdd setImage:[UIImage imageNamed:@"tab_add_select"] forState:UIControlStateNormal];
    }
    return _btnAdd;
}

@end
