//
//  FirstViewController.m
//  MTTabBar
//
//  Created by Milovan Tomasevic on 23/10/2017.
//  Copyright © 2017 Milovan Tomasevic. All rights reserved.
//

#import "FirstViewController.h"
#import "MBProgressHUD.h"
#import "SWRevealViewController.h"
#import "MasterViewController.h"
#import "TestViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController{
    NSIndexPath *selectedIndex;
    UICollectionViewCell *expandedCell;
    NSMutableArray *gatewayList;
    BOOL startFromDevicePage,addButtonPressed,isSelectedCam;

    /*refresh control - spiner on top of collection view*/
    UIRefreshControl *refreshControl;
    MBProgressHUD *HUD;
    UICollectionView *camsCollectionView;
    MTBaseTheme *theme;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self navigationController] tabBarItem].badgeValue = @"";
    [[super.tabBarController.viewControllers objectAtIndex:2] tabBarItem].badgeValue = @"1";

    [self.navigationController.navigationBar setBarTintColor:[THEME_MANAGER getFooterColor]];

    UIBarButtonItem *addButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBtnPress:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController tapGestureRecognizer];
    [revealController.view addGestureRecognizer:revealController.panGestureRecognizer];
    revealController.rightViewRevealWidth = 0;
    revealController.rightViewRevealDisplacement = 0;
    revealController.rightViewRevealOverdraw = 0;
    revealController.rearViewRevealWidth = self.view.frame.size.width - kDefRearViewRevealOverdraw;
    revealController.rearViewRevealDisplacement = kDefRearViewRevealDisplacement;
    revealController.rearViewRevealOverdraw = kDefRearViewRevealOverdraw;
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"] style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    revealController.title = NSLocalizedString(@"nav_bar_title_home_setup", nil);
    
}

-(void)addBtnPress:(UIBarButtonItem*)item{
    
    TestViewController *mvc = [[TestViewController alloc] init];
    [mvc setTitle:[NSString stringWithFormat:@"Test"]];
    [self.navigationController pushViewController:mvc animated:YES];
}


/*
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"logout", nil)
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(logout)];
    
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor orangeColor]}];
    self.navigationController.navigationBar.translucent = YES;


    theme = THEME_MANAGER;

    UICollectionViewFlowLayout *layout=  [[UICollectionViewFlowLayout alloc]init];
    camsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kMarginDefault/2, self.view.frame.size.width, self.view.frame.size.height - kMarginDefault/2) collectionViewLayout:layout];
    camsCollectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    camsCollectionView.delegate = self;
    camsCollectionView.dataSource = self;
    camsCollectionView.alwaysBounceVertical = YES;
    [self.view addSubview:camsCollectionView];
    
    //init collection view
    // color background set
    self.view.backgroundColor = [theme getBackgroundColor];
    camsCollectionView.backgroundColor = [theme getBackgroundColor];
    
    camsCollectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    camsCollectionView.showsVerticalScrollIndicator = YES;
    
    //Add refresh controll to collection view
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [theme getStepsSelectionColor];
    [self setRefreshControlAttributedTitle:NSLocalizedString(@"pull_to_refresh", nil)];
    [refreshControl addTarget:self action:@selector(refershCollectionView:) forControlEvents:UIControlEventValueChanged];
    [camsCollectionView addSubview:refreshControl];
    
    //add background label to collection view
    UILabel *noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, camsCollectionView.bounds.size.width, camsCollectionView.bounds.size.height)];
    noDataLabel.text = NSLocalizedString(@"pull_down", nil);
    noDataLabel.textColor = [theme getTextColor];
    noDataLabel.numberOfLines = 0;
    //noDataLabel.styleName = MTFontStyleRegular;
    noDataLabel.lineBreakMode = NSLineBreakByWordWrapping;
    noDataLabel.textAlignment = NSTextAlignmentCenter;
    [noDataLabel setAlpha:kAlphaComponent];
    camsCollectionView.backgroundView = noDataLabel;
    //register custom collection cell class
    //[camsCollectionView registerClass:[OCWizardCollectionSectionCell class] forCellWithReuseIdentifier:@"customGatewayCell"];

    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController tapGestureRecognizer];
    [revealController.view addGestureRecognizer:revealController.panGestureRecognizer];
    revealController.rightViewRevealWidth = 0;
    revealController.rightViewRevealDisplacement = 0;
    revealController.rightViewRevealOverdraw = 0;
    revealController.rearViewRevealWidth = self.view.frame.size.width - kDefRearViewRevealOverdraw;
    revealController.rearViewRevealDisplacement = kDefRearViewRevealDisplacement;
    revealController.rearViewRevealOverdraw = kDefRearViewRevealOverdraw;
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"] style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    
    revealController.navigationItem.leftBarButtonItem = revealButtonItem;
    revealController.title = NSLocalizedString(@"nav_bar_title_home_setup", nil);
    
}


-(void)logout{
    
}

-(void)setRefreshControlAttributedTitle:(NSString *)titleMsg
{
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:titleMsg
                                                                attributes: @{NSForegroundColorAttributeName:[theme getTextColor]}];
    refreshControl.attributedTitle = title;
}

-(void)refershCollectionView:(UIRefreshControl *)refresh
{
    [self setRefreshControlAttributedTitle:NSLocalizedString(@"refreshing_gateway_data", nil)];
    
}
*/



@end
