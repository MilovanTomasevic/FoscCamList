//
//  CircleMenuViewController.m
//  KYCircleMenuDemo
//
//  Created by Kjuly on 7/18/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "CircleMenuViewController.h"
#import "fossdk.h"
#import "Settings.h"
#import "SettingsViewController.h"
#import "Page1ViewController.h"
#import "ListCamsViewController.h"
#import "LoginViewController.h"
#import "AccountInfoViewController.h"
#import "PreferenceDefines.h"
#import "TestCameraAndUserViewController.h"
#import "Page0ViewController.h"
#import "JoinCamUserViewController.h"
#import "SplashViewController.h"


@implementation CircleMenuViewController


- (id)init
{
  if (self = [super init]) {
    [self setTitle:@""];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
    
//     NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
//    
//    if ([preferences objectForKey:PREF_USER_EMAIL] == nil && [preferences objectForKey:PREF_USER_PASSWORD] == nil){
//        
//        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:PREF_USER_LOGIN];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        
//        LoginViewController *lvc = [[LoginViewController alloc] init];
//        [lvc setTitle:[NSString stringWithFormat:@"Login & Registar "]];
//        [self.navigationController pushViewController:lvc animated:YES];
//    }
//    
//    //[[NSUserDefaults standardUserDefaults] setBool:YES forKey:PREF_USER_LOGIN];
//    //[[NSUserDefaults standardUserDefaults] synchronize];
    
  
    if([[NSUserDefaults standardUserDefaults] boolForKey:PREF_USER_LOGIN]) {
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Logout"
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(logout)];
        
        
        self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
        self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor orangeColor]}];
        self.navigationController.navigationBar.translucent = YES;
        
        
    } else{
        
        [self logout];
        
    }

  // Modify buttons' style in circle menu
  for (UIButton * button in [self.menu subviews]) {
    [button setAlpha:.95f];
  }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear: animated];

    
    self.title = NSLocalizedString(@"app_menu_name", nil);
    
    Settings *sharedInstance = APP_SETTINGS;
    
    if (sharedInstance.sConfigured) {
        
        //SettingsViewController *svc =[self.storyboard instantiateViewControllerWithIdentifier:@"svc"];
        //[self.navigationController pushViewController:svc animated:YES];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        ListCamsViewController *listCams =[storyboard instantiateViewControllerWithIdentifier:@"list"];
        [self.navigationController pushViewController:listCams animated:YES];
        
        sharedInstance.sConfigured = NO;
        
    }
    
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:PREF_USER_LOGIN]) {
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"logout", nil)
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(logout)];
        
        
        self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
        self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor orangeColor]}];
        self.navigationController.navigationBar.translucent = YES;
        
        
    } else{
        
        [self logout];
        
    }
    
}
#pragma mark - KYCircleMenu Button Action

// Run button action depend on their tags:
//
// TAG:        1       1   2      1   2     1   2     1 2 3     1 2 3
//            \|/       \|/        \|/       \|/       \|/       \|/
// COUNT: 1) --|--  2) --|--   3) --|--  4) --|--  5) --|--  6) --|--
//            /|\       /|\        /|\       /|\       /|\       /|\
// TAG:                             3       3   4     4   5     4 5 6
//



- (void)runButtonActions:(id)sender
{
  [super runButtonActions:sender];
  
  // Configure new view & push it with custom |pushViewController:| method
  UIViewController * viewController = [[UIViewController alloc] init];
  [viewController.view setBackgroundColor:[UIColor blackColor]];
  [viewController setTitle:[NSString stringWithFormat:@"View %ld", (long)[sender tag]]];
  // Use KYCircleMenu's |-pushViewController:| to push vc
  //[self pushViewController:viewController];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    if ((long)[sender tag] == 1){
        ListCamsViewController *listCams =[storyboard instantiateViewControllerWithIdentifier:@"list"];
        [self.navigationController pushViewController:listCams animated:YES];
    }
    if ((long)[sender tag] == 2){
        Page0ViewController *p0vc = [[Page0ViewController alloc]init];
        [p0vc setTitle:[NSString stringWithFormat:NSLocalizedString(@"choice_conf", nil)]];
        [self.navigationController pushViewController:p0vc animated:YES];
    }
    if ((long)[sender tag] == 3){
        TestCameraAndUserViewController *tcvc = [[TestCameraAndUserViewController alloc] init];
        [tcvc setTitle:[NSString stringWithFormat:NSLocalizedString(@"manual_add",nil)]];
        [self.navigationController pushViewController:tcvc animated:YES];
    }
    if ((long)[sender tag] == 4){
        AccountInfoViewController *aivc = [[AccountInfoViewController alloc]init];
        [aivc setTitle:[NSString stringWithFormat:NSLocalizedString(@"account_info", nil)]];
        [self.navigationController pushViewController:aivc animated:YES];
    }
    if ((long)[sender tag] == 5){
        JoinCamUserViewController *jcuvc = [[JoinCamUserViewController alloc]init];
        [self.navigationController pushViewController:jcuvc animated:YES];
    }
    if ((long)[sender tag] == 6){
        SplashViewController *svc = [[SplashViewController alloc]init];
        [self.navigationController pushViewController:svc animated:YES];
    }
}

- (void)logout{

    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:PREF_USER_EMAIL];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:PREF_USER_PASSWORD];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:PREF_USER_LOGIN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    LoginViewController *lvc = [[LoginViewController alloc] init];
    [lvc setTitle:[NSString stringWithFormat:NSLocalizedString(@"log_and_reg",nil)]];
    [self.navigationController pushViewController:lvc animated:YES];
}

@end
