//
//  SplashViewController.m
//  MTcams
//
//  Created by Milovan Tomasevic on 11/10/2017.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "SplashViewController.h"
#import "TabBarViewController.h"
#import "FirstViewController.h"
#import "SecoundViewController.h"
#import "ThirdViewController.h"
#import "FourthViewController.h"
#import "UITabBar+CustomBadge.h"



@interface SplashViewController (){
    UIImageView *imgSplash;
    UIActivityIndicatorView *activityIndicator;
    UILabel *labText;
}

@end

@implementation SplashViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];

    self.view.userInteractionEnabled = YES;
    imgSplash = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    imgSplash.image = [UIImage imageNamed:@"FakeSpash"];
    
    int labelMarginFromBotom = 5*kMarginDefault;
    if(IS_IPAD){
        labelMarginFromBotom = 3*kMarginDefault;
    }
    
    labText = [[UILabel alloc ]initWithFrame:CGRectMake(kMarginDefault, imgSplash.frame.size.height-labelMarginFromBotom, imgSplash.frame.size.width-2*kMarginDefault, kUILabelDefHeight)];
    labText.text = NSLocalizedString(@"ss_message", nil);

    labText.font = [THEME_MANAGER fontWithStyleName:OCFontStyleLight size:kFontSizeMinimum];
    labText.textColor = [THEME_MANAGER getSplashScreenTextColor];
    labText.textAlignment = NSTextAlignmentCenter;
    labText.lineBreakMode = NSLineBreakByWordWrapping;
    labText.numberOfLines = 0;
    [imgSplash addSubview:labText];
    
    //Create and add the Activity Indicator to splashView
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityIndicator setColor:[THEME_MANAGER getAccentColor]];
    activityIndicator.center = CGPointMake(imgSplash.frame.size.width/2, imgSplash.frame.size.height-(labelMarginFromBotom+kMarginDefault));
    [imgSplash addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
    [imgSplash setAlpha:1];
    [self.view addSubview:imgSplash];
    [self.view bringSubviewToFront:imgSplash];
    self.view.userInteractionEnabled = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    
    [self performSelector:@selector(hideSplash) withObject:nil afterDelay:3];
}

-(void)hideSplash{
 //   TabBarViewController *tbvc = [[TabBarViewController alloc]init];
 //   [self.navigationController pushViewController:tbvc animated:YES];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [THEME_MANAGER getBackgroundColor];
    
    UITabBarController *tabController = [UITabBarController new];
    
    FourthViewController *con4 = [[FourthViewController alloc] init];
    UINavigationController *nCon4 = [[UINavigationController alloc]initWithRootViewController:con4];
    
    ThirdViewController *con3 = [[ThirdViewController alloc] init];
    UINavigationController *nCon3 = [[UINavigationController alloc]initWithRootViewController:con3];
    
    SecoundViewController *con2 = [[SecoundViewController alloc] init];
    UINavigationController *nCon2 = [[UINavigationController alloc]initWithRootViewController:con2];
    
    FirstViewController *con1 = [[FirstViewController alloc] init];
    UINavigationController *nCon1 = [[UINavigationController alloc]initWithRootViewController:con1];
    
    tabController.viewControllers = @[nCon4, con3, nCon2, nCon1];
    
   
    
    UITabBarItem *item4 = tabController.tabBar.items[0];
    item4.title = @"4";
    item4.image = [UIImage imageNamed:@"tab_location"];

    UITabBarItem *item3 = tabController.tabBar.items[1];
    item3.title = @"3";
    item3.image = [UIImage imageNamed:@"tab_location"];

    UITabBarItem *item2 = tabController.tabBar.items[2];
    item2.title = @"2";
    item2.image = [UIImage imageNamed:@"tab_location"];

    
    UITabBarItem *item1 = tabController.tabBar.items[3];
    item1.title = @"1";
    item1.image = [UIImage imageNamed:@"tab_home_setup"];
    
    for(UITabBarItem *item in tabController.tabBar.items) {
        item.image = [item.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    //[tabController.tabBar setTabIconWidth:29];
   // [tabController.tabBar setBadgeTop:9];

    
    
   //text tint color
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [THEME_MANAGER getTextColor] }
                                             forState:UIControlStateNormal];
    
    //background tint color
    [[UITabBar appearance] setBarTintColor:[THEME_MANAGER getFooterColor]];

    NSMutableDictionary* normalItemAttributes = [NSMutableDictionary dictionaryWithObject:[THEME_MANAGER fontWithStyleName:OCFontStyleRegular size:13.0f] forKey:NSFontAttributeName];
    // selected text color
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [THEME_MANAGER getTextColor], NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    // set color of unselected text
    [normalItemAttributes setValue:[THEME_MANAGER getTextColorWithAlpha:kAlternativeColorAlpha] forKey:NSForegroundColorAttributeName];
    
    [[UITabBarItem appearance] setTitleTextAttributes:normalItemAttributes forState:UIControlStateNormal];
    
    tabController.delegate =self;
    tabController.selectedIndex = 3;

    self.window.rootViewController = tabController;
    [self.window makeKeyAndVisible];
    

    
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
@end
