//
//  TabBarViewController
//  MTcams
//
//  Created by Milovan Tomasevic on 11/10/2017.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBarViewController : UITabBarController <UITabBarControllerDelegate>

@property (strong, nonatomic) UITabBarController *tabBarController;
- (void) setupTabBarItems;
- (void) setBarItemsEnabledTo:(BOOL)enabled;


//@property (strong, nonatomic) UIWindow *window;

@end
