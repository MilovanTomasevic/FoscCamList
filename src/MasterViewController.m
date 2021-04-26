//
//  MasterViewController.m
//  MTcams
//
//  Created by administrator on 4/20/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "MasterViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "LoginViewController.h"


@interface MasterViewController ()

@end


@implementation MasterViewController{
    AppDelegate *appDelegate;
    int currentPage;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.coreDataManager = [[CoreDataManager alloc]init];
    self.user = [self.coreDataManager getNewUser];

    currentPage = 0;
    
    [self loadScrollView];

    [self addChildViewController:[[FirstPageViewController alloc]init]];
    [self addChildViewController:[[SecondPageViewController alloc]init]];
    [self addChildViewController:[[ThirdPageViewController alloc]init]];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.view addSubview:[self.childViewControllers objectAtIndex:currentPage].view];
}

- (void)loadScrollView{
    CGRect frame = CGRectMake( 0, 0, self.view.frame.size.width, self.view.frame.size.height-1);
    //CGRect frame = CGRectMake( 30, 30, 300, 300);
    self.scrollView= [[UIScrollView alloc] initWithFrame:frame];
    _scrollView.contentSize=CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    [_scrollView setBackgroundColor: [UIColor blackColor]];
    [_scrollView setUserInteractionEnabled:YES];
    [_scrollView setScrollEnabled:YES];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    
    [self.view addSubview:_scrollView];
}


-(void)customBackButtonPressed{
    [self.view endEditing:YES];
    
    int page = currentPage;
    
    if (page == 0){

        [self.navigationController popViewControllerAnimated:YES];
    }else {
    
    [[self.childViewControllers objectAtIndex:page].view removeFromSuperview];
    [self.view addSubview:[self.childViewControllers objectAtIndex:page-1].view];
    currentPage = page-1;
    }
}

- (void)nextButtonPressed {
    int page = currentPage;

    CGRect frame = _scrollView.frame;
    frame.origin.x = frame.size.width * (page+1);
    frame.origin.y = 0;

    [_scrollView scrollRectToVisible:frame animated:YES];

    [[self.childViewControllers objectAtIndex:page].view removeFromSuperview];
    [self.view addSubview:[self.childViewControllers objectAtIndex:page+1].view];
    currentPage = page+1;
}

- (void)addAccountSaveDone
{
    [self.coreDataManager addOrUpdateUserEmail:self.user.email password:self.user.password firstName:self.user.firstName middleName:self.user.middleName lastName:self.user.lastName dateOfBirth:self.user.dateOfBirth phone:self.user.phone address:self.user.adress town:self.user.town postal:self.user.postalCode country:self.user.country role:self.user.role];

    [appDelegate saveContext];
    [self progressDone];
}

- (void)progressDone{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    hud.square = YES;
    hud.label.text = NSLocalizedString(@"account_created", nil);
    [hud hideAnimated:YES afterDelay:1.f];
}


@end
