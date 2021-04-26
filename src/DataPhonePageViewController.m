//
//  DataPhonePageViewController.m
//  MTcams
//
//  Created by Milovan Tomasevic on 5/26/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "DataPhonePageViewController.h"
#import "MasterForgotPasswordViewController.h"

@interface DataPhonePageViewController (){
    MasterForgotPasswordViewController *masterFPVC;
    NSString  *dateOfB, *iPhone;
}


@end

@implementation DataPhonePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    masterFPVC = (MasterForgotPasswordViewController*)self.parentViewController;
    [self loadViewPage];
}



- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.pControl setFrame:CGRectMake(0, 55, self.view.frame.size.width, 55)];
    [self.pControl setCurrentPage:1];
    //[self.pControl setCurrentPage:1 animated:YES];
    
    [self loadLeftRightButton];
}

- (void)loadLeftRightButton{
    
    masterFPVC.navigationItem.leftBarButtonItem= [[UIBarButtonItem alloc] initWithTitle:@"<"
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(customBackButtonPressed)];
    
    masterFPVC.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@">"
                                                                                   style:UIBarButtonItemStylePlain
                                                                                  target:self
                                                                                  action:@selector(nextPage)];
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor orangeColor]}];
    self.navigationController.navigationBar.translucent = YES;
}


-(void)customBackButtonPressed
{
    [masterFPVC customBackButtonPressed];
}

-(void)nextPage
{
    LogI(@"Next button clicked 2 DataPhone view");
    

    dateOfB = _date.text;
    iPhone  = _phone.text;
    
    dateOfB = [dateOfB stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    iPhone  = [iPhone stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];

    if (![dateOfB isEqualToString:masterFPVC.user.dateOfBirth]) {
        [ALERT_PRESENTER presentAlertWithTitle:NSLocalizedString(@"error",nil) message:NSLocalizedString(@"msg_6",nil)];
        return;
    }
    if (![iPhone isEqualToString:masterFPVC.user.phone]) {
        [ALERT_PRESENTER presentAlertWithTitle:NSLocalizedString(@"error",nil) message:NSLocalizedString(@"msg_11",nil)];
        return;
    }
    [masterFPVC nextButtonPressed];
}

- (void)loadViewPage{
    
    CGFloat sirinaPolja = self.view.frame.size.width * 0.7;
    int margina = 10;
    int visinaPolja = 40;
    int visina = 100;

    self.date =  [[MTTextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - sirinaPolja/2, visina, sirinaPolja, visinaPolja)];
    self.phone = [[MTTextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - sirinaPolja/2, visina + visinaPolja + margina , sirinaPolja, visinaPolja)];

    [self.date customizeField:_date withView:self.view andPlaceholder:NSLocalizedString(@"plsh_6",nil)];
    [self.phone customizeField:_phone withView:self.view andPlaceholder:NSLocalizedString(@"plsh_11",nil)];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
}


@end
