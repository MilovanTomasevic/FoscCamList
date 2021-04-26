//
//  SecoundViewController.m
//  MTTabBar
//
//  Created by Milovan Tomasevic on 23/10/2017.
//  Copyright © 2017 Milovan Tomasevic. All rights reserved.
//

#import "SecoundViewController.h"
#import "TestViewController.h"

@interface SecoundViewController ()

@end

@implementation SecoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"+"
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(addBtnPress)];
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor orangeColor]}];
    
}


-(void)addBtnPress{
    
    TestViewController *mvc = [[TestViewController alloc] init];
    [mvc setTitle:[NSString stringWithFormat:@"Test"]];
    [self.navigationController pushViewController:mvc animated:YES];
}

@end
