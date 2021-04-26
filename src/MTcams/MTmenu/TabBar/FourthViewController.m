//
//  FourthViewController.m
//  MTTabBar
//
//  Created by Milovan Tomasevic on 23/10/2017.
//  Copyright © 2017 Milovan Tomasevic. All rights reserved.
//

#import "FourthViewController.h"

@interface FourthViewController ()

@end

@implementation FourthViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationBar* navbar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    UINavigationItem* navItem = [[UINavigationItem alloc] initWithTitle:@"Text"];
    [navbar setBarTintColor:[THEME_MANAGER getFooterColor]];
    
    UIBarButtonItem* cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onTapCancel:)];
    navItem.leftBarButtonItem = cancelBtn;
    
    UIBarButtonItem* doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onTapDone:)];
    navItem.rightBarButtonItem = doneBtn;
    
    [navbar setItems:@[navItem]];
    [self.view addSubview:navbar];
    
}


-(void)onTapDone:(UIBarButtonItem*)item{
    
}

-(void)onTapCancel:(UIBarButtonItem*)item{
    
}
    




@end
