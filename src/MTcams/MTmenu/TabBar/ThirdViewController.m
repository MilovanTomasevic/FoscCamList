//
//  ThirdViewController.m
//  MTTabBar
//
//  Created by Milovan Tomasevic on 23/10/2017.
//  Copyright © 2017 Milovan Tomasevic. All rights reserved.
//

#import "ThirdViewController.h"
#import "UITabBar+CustomBadge.h"

@interface ThirdViewController ()

@end

@implementation ThirdViewController{
    NSInteger number;
    CustomBadgeType type;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 300, 200, 100)];
    [button setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [button setTitle:@"change badge" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(changeBadge:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    number = 100;
    type = kCustomBadgeStyleNone;
}

-(void)changeBadge:(UIButton *)btn{
    NSInteger index = [self.tabBarController.tabBar.items indexOfObject:self.tabBarItem];
    
    if(type == kCustomBadgeStyleNone){
        type = kCustomBadgeStyleNumber;
    }else if(type  == kCustomBadgeStyleNumber){
        if(number == 100){
            number = 1;
        }else if(number == 1){
            number = 10;
        }else if(number == 10){
            number = 100;
            type = kCustomBadgeStyleDot;
        }
    }else if(type == kCustomBadgeStyleDot){
        type = kCustomBadgeStyleNone;
    }
    [self.tabBarController.tabBar setBadgeStyle:type value:number atIndex:index];
}

@end
