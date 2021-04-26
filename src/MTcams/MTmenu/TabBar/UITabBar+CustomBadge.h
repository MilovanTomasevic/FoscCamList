//
//  UITabBar+CustomBadge.h
//  MTcams
//
//  Created by Milovan Tomasevic on 24/10/2017.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CustomBadgeType) {
    kCustomBadgeStyleDot,
    kCustomBadgeStyleNumber,
    kCustomBadgeStyleNone
};

@interface UITabBar (CustomBadge)

-(void)setTabIconWidth:(CGFloat)width;
-(void)setBadgeTop:(CGFloat)top;

-(void)setBadgeStyle:(CustomBadgeType)type value:(NSInteger)badgeValue atIndex:(NSInteger)index;


@end
