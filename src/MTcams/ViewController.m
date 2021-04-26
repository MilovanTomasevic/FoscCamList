//
//  ViewController.m
//  MTcams
//
//  Created by administrator on 4/3/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "ViewController.h"
#import "fossdk.h"
#import "Settings.h"
#import "SettingsViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear: animated];

    
    Settings *sharedInstance = APP_SETTINGS;
    
    if (sharedInstance.sConfigured) {

        SettingsViewController *svc =[self.storyboard instantiateViewControllerWithIdentifier:@"list"];
        [self.navigationController pushViewController:svc animated:YES];
        
        sharedInstance.sConfigured = NO;
        
    }

}



@end
