//
//  MTThemeManager.m
//  MTcams
//
//  Created by Milovan Tomasevic on 11/10/2017.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "MTThemeManager.h"
#import "MTTheme.h"

@implementation MTThemeManager

+ (MTThemeManager *)sharedInstance
{
    static MTThemeManager *sharedInstance = nil;
    if (sharedInstance == nil)
    {
        sharedInstance = [[MTThemeManager alloc] init];
    }
    return sharedInstance;
}

-(id)init
{
    if (self = [super init]) {
        self.theme = [[MTTheme alloc]init];
    }
    
    return self;
}

@end
