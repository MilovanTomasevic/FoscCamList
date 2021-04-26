//
//  MainMenuViewController.m
//  MTcams
//
//  Created by Milovan Tomasevic on 11/10/2017.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "TabBarViewController.h"
#import "ViewControllerFancy.h"
#import "ViewControllerSimple.h"
#import "ViewControllerMultiple.h"

static const CGFloat kImageHeight = 49;

@interface TabBarViewController ()

@end

@implementation TabBarViewController{
    UITabBarItem *tabBarItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.delegate = self;


    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 1.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    UIImage *transparentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.tabBar setBackgroundImage:transparentImage];
    [self.tabBar setShadowImage:transparentImage];
    
    
    
    [self.tabBar setTintColor:[THEME_MANAGER getTextColor]];
    [self.tabBar setBarTintColor:[THEME_MANAGER getFooterColor]];
    NSMutableDictionary* normalItemAttributes = [NSMutableDictionary dictionaryWithObject:[THEME_MANAGER fontWithStyleName:OCFontStyleRegular size:13.0f] forKey:NSFontAttributeName];
    // selected text color
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [THEME_MANAGER getTextColor], NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    // set color of unselected text
    [normalItemAttributes setValue:[THEME_MANAGER getTextColorWithAlpha:kAlternativeColorAlpha] forKey:NSForegroundColorAttributeName];
    
    [[UITabBarItem appearance] setTitleTextAttributes:normalItemAttributes forState:UIControlStateNormal];
    
    NSMutableArray *controllers = [NSMutableArray arrayWithArray:self.viewControllers];
    [self setupTabBarItems];
    [self setSelectedIndex:controllers.count-1];
    
    UIImage* tabBarBackground;
    tabBarBackground = [self tabImageColor:tabBarBackground];
    
    [[UITabBar appearance] setSelectionIndicatorImage:tabBarBackground];
    
    [self.view addSubview:_tabBarController.view];
    
    
    //tabbar.viewControllers=[NSArray arrayWithObjects:fvc,svc,tvc,fvc2,nil];
}

-(UIImage *)tabImageColor:(UIImage *)img{
    UIImage *image =  [MTSupport imageWithColor:[THEME_MANAGER getAccentColor] andSize:CGSizeMake( self.view.frame.size.width/4,kImageHeight)];
    return image;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

-(void)setBarItemsEnabledTo:(BOOL)enabled
{
    for (int i = 0; i < kLastTabBarItemIndex; i++) {
        UITabBarItem *tabBarItem = [[self.tabBar items] objectAtIndex:i];
        [tabBarItem setEnabled:enabled];
    }
}

- (void) setupTabBarItems{
    

    [[[self.tabBar items] objectAtIndex:0] setTitle:NSLocalizedString(@"nav_bar_title_location", nil)];
    [[[self.tabBar items] objectAtIndex:1] setTitle:NSLocalizedString(@"nav_bar_title_type", nil)];
    [[[self.tabBar items] objectAtIndex:2] setTitle:NSLocalizedString(@"nav_bar_title_scenes", nil)];
    [[[self.tabBar items] objectAtIndex:3] setTitle:NSLocalizedString(@"nav_bar_title_home_setup", nil)];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if(item.tag==1)
    {
        //your code
    }
    else
    {
        //your code
    }
    
    
  /*
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.rootViewController = ({
        UITabBarController *tabController = [[UITabBarController alloc] init];
        
        NSMutableArray *controllers = [NSMutableArray new];
        
        {
            ViewControllerSimple *c = [[ViewControllerSimple alloc] init];
            c.title = @"Simple";
            [controllers addObject: c];
        }
        
        {
            ViewControllerMultiple *c = [[ViewControllerMultiple alloc] init];
            c.title = @"Multiple";
            [controllers addObject: c];
        }
        
        {
            ViewControllerFancy *c = [[ViewControllerFancy alloc] init];
            c.title = @"Fancy";
            [controllers addObject: c];
        }
        
        tabController.viewControllers = controllers;
        
        tabController;
    });
    
    [self.window makeKeyAndVisible];
   
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}
   */
    
    

   
 
}

@end
