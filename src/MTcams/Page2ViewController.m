//
//  Page2ViewController.m
//  MTcams
//
//  Created by administrator on 4/3/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "Page2ViewController.h"
#import "PreferenceDefines.h"
#import "Settings.h"

static NSString* const kSSID_String = @"SSID";

@interface Page2ViewController ()

@end

@implementation Page2ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self loadViewPage];

}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.pControl setCurrentPage:1];
    //[self.pControl setCurrentPage:1 animated:YES];
    //[self.pControl setFrame:CGRectMake(0, self.view.frame.size.height - 55, self.view.frame.size.width, 55)];
}



- (void)loadViewPage{

    CGFloat sirinaPolja = self.view.frame.size.width * 0.7;
    CGFloat sirinaDugmeta = self.view.frame.size.width * 0.4;
    int margina = 10;
    int visinaPolja = 40;
    
    [self.descriptionlabel setFrame:CGRectMake(self.view.frame.size.width/2 - sirinaPolja/2,   CGRectGetMaxY(self.navigationController.navigationBar.frame)+2*margina, sirinaPolja, visinaPolja)];
    self.wifiSSID =  [[MTTextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - sirinaPolja/2, CGRectGetMaxY(_descriptionlabel.frame)+margina, sirinaPolja, visinaPolja)];
    self.passwordWiFi =  [[MTTextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - sirinaPolja/2, CGRectGetMaxY(_wifiSSID.frame)+margina , sirinaPolja, visinaPolja)];
    [self.next2Button      setFrame:CGRectMake(self.view.frame.size.width/2 - sirinaDugmeta/2, CGRectGetMaxY(_passwordWiFi.frame)+margina , sirinaDugmeta, visinaPolja)];
    
    _descriptionlabel.textAlignment = NSTextAlignmentCenter;
    
    [_wifiSSID customizeField:_wifiSSID withView:self.view andPlaceholder:@"ssid"];
    _wifiSSID.text = [MTSupport getCurrentWifiSSID];
    _wifiSSID.textAlignment = NSTextAlignmentCenter;
    _wifiSSID.enabled = NO;
    _wifiSSID.backgroundColor = [UIColor grayColor];
    [_passwordWiFi customizeField:_passwordWiFi withView:self.view andPlaceholder:NSLocalizedString(@"enter_pass",nil)];
    [_passwordWiFi addRightPasswordButton];

    _passwordWiFi.secureTextEntry = YES;

    [_next2Button setTitle: NSLocalizedString(@"next",nil) forState:UIControlStateNormal];
    _next2Button.layer.cornerRadius = kButtonDefCornerRadius;
    [_next2Button setBackgroundColor: [ UIColor orangeColor]];
    _next2Button.tintColor = [UIColor whiteColor];
    [_next2Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor orangeColor]}];
    self.navigationController.navigationBar.translucent = YES;
}


- (IBAction)next2:(id)sender {

    Settings *sharedInstance = APP_SETTINGS;
    sharedInstance.sSSID = _wifiSSID.text;
    sharedInstance.sSSIDpass = _passwordWiFi.text;
    
    LogI(@"PAGE 2 Singleton kreiran sa vrednostima ssid  i password %@, %@" ,sharedInstance.sSSID, sharedInstance.sSSIDpass);
}

@end
