//
//  MTThemeManager.h
//  MTcams
//
//  Created by Milovan Tomasevic on 11/10/2017.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTBaseTheme.h"

@interface MTThemeManager : NSObject


+ (MTThemeManager *)sharedInstance;
@property (nonatomic,strong)MTBaseTheme *theme;


@end
