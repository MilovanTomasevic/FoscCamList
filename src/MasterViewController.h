//
//  MasterViewController.h
//  MTcams
//
//  Created by administrator on 4/20/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FirstPageViewController.h"
#import "SecondPageViewController.h"
#import "ThirdPageViewController.h"
#import "User+CoreDataClass.h"
#import "CoreDataManager.h"


@interface MasterViewController : UIViewController

@property (nonatomic, strong)CoreDataManager *coreDataManager;
@property (nonatomic, strong)User *user;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

- (void)nextButtonPressed;
-(void)customBackButtonPressed;

-(void) addAccountSaveDone;

@end
