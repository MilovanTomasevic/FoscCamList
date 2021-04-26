//
//  Page0ViewController.m
//  MTcams
//
//  Created by Milovan Tomasevic on 6/8/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "Page0ViewController.h"
#import "AppDelegate.h"
#import "Page1ViewController.h"
#import "Settings.h"

@interface Page0ViewController ()

@end

@implementation Page0ViewController{
    AppDelegate *appDelegate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    [self loadPageView];
}


- (void)loadPageView{

    CGFloat sirinaDugmeta = self.view.frame.size.width * 0.4;
    int margina = 10;
    int visinaPolja = 40;
    float kButtonDefCornerRadius = 7;

    self.wiredConf = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - sirinaDugmeta/2, self.view.frame.size.height/3 - 3*margina , sirinaDugmeta, visinaPolja)];
    self.wifiConf  = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - sirinaDugmeta/2, self.view.frame.size.height/3 + 3*margina , sirinaDugmeta, visinaPolja)];

    [_wiredConf setTitle: NSLocalizedString(@"wired",nil) forState:UIControlStateNormal];
    _wiredConf.layer.cornerRadius = kButtonDefCornerRadius;
    [_wiredConf addTarget:self action:@selector(setConfigWired) forControlEvents:UIControlEventTouchUpInside];
    [_wiredConf setBackgroundColor: [ UIColor orangeColor]];
    
    [_wifiConf setTitle: NSLocalizedString(@"wifi",nil) forState:UIControlStateNormal];
    _wifiConf.layer.cornerRadius = kButtonDefCornerRadius;
    [_wifiConf addTarget:self action:@selector(setConfigWifi) forControlEvents:UIControlEventTouchUpInside];
    [_wifiConf setBackgroundColor: [ UIColor orangeColor]];

    _wiredConf.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    _wifiConf.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    
    [self.view addSubview:_wiredConf];
    [self.view addSubview:_wifiConf];

    [self.view setBackgroundColor:[UIColor blackColor]];
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor orangeColor]}];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)setConfigWifi{
    
    appDelegate.configurationType = wifi;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    Page1ViewController *p1 =[storyboard instantiateViewControllerWithIdentifier:@"page1"];
    [self.navigationController pushViewController:p1 animated:YES];
}

- (void)setConfigWired{
    
    Settings *sharedInstance = APP_SETTINGS;
    sharedInstance.sSSIDpass = NSLocalizedString(@"no_pass_for_conf", nil);
    
    appDelegate.configurationType = wired;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    Page1ViewController *p1 =[storyboard instantiateViewControllerWithIdentifier:@"page1"];
    [self.navigationController pushViewController:p1 animated:YES];
}

@end
