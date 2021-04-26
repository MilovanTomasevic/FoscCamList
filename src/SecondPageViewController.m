//
//  SecondPageViewController.m
//  MTcams
//
//  Created by administrator on 4/20/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "SecondPageViewController.h"
#import "ThirdPageViewController.h"
#import "MasterViewController.h"

@interface SecondPageViewController (){
    MasterViewController *masterVC;
}


@end

@implementation SecondPageViewController{
    NSString* errorMSG;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    masterVC = (MasterViewController*)self.parentViewController;
    [self loadPageView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.pControl setFrame:CGRectMake(0, 55, self.view.frame.size.width, 55)];
    [self.pControl setCurrentPage:1];
    //[self.pControl setCurrentPage:1 animated:YES];
    [self loadLeftRightButton];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [masterVC.user setFirstName:_firstNameField.text];
    [masterVC.user setLastName:_lastNameField.text];
    [masterVC.user setMiddleName:_middleNameField.text];
    [masterVC.user setDateOfBirth:_dateOfBirthField.text];
}

- (void)loadLeftRightButton{
    masterVC.navigationItem.leftBarButtonItem= [[UIBarButtonItem alloc] initWithTitle:@"<"
                                                                                style:UIBarButtonItemStylePlain
                                                                               target:self
                                                                               action:@selector(customBackButtonPressed)];
    
    
    masterVC.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@">"
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(nextPage)];
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor orangeColor]}];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)loadPageView{

    CGFloat sirinaPolja = self.view.frame.size.width * 0.7;
    int margina = 10;
    int visinaPolja = 40;
    int visina = 100;
    
    self.firstNameField =   [[MTTextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - sirinaPolja/2, visina, sirinaPolja, visinaPolja)];
    self.lastNameField =    [[MTTextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - sirinaPolja/2, visina + visinaPolja + margina , sirinaPolja, visinaPolja)];
    self.middleNameField =  [[MTTextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - sirinaPolja/2, visina + 2*visinaPolja + 2*margina , sirinaPolja, visinaPolja)];
    self.dateOfBirthField = [[MTTextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - sirinaPolja/2, visina + 3*visinaPolja + 3*margina , sirinaPolja, visinaPolja)];

    [_firstNameField customizeField:_firstNameField withView:self.view andPlaceholder:NSLocalizedString(@"plsh_3",nil)];
    [_lastNameField customizeField:_lastNameField withView:self.view andPlaceholder:NSLocalizedString(@"plsh_4",nil)];
    [_middleNameField customizeField:_middleNameField withView:self.view andPlaceholder:NSLocalizedString(@"plsh_5",nil)];
    [_dateOfBirthField customizeField:_dateOfBirthField withView:self.view andPlaceholder:NSLocalizedString(@"plsh_6",nil)];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
}

-(void)customBackButtonPressed
{
    [masterVC customBackButtonPressed];
}

-(void)nextPage
{
        LogI(@"Next button clicked 2 Page view");
        //next page
    
    _firstNameField.text = [_firstNameField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    _lastNameField.text = [_lastNameField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    _middleNameField.text = [_middleNameField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    _dateOfBirthField.text = [_dateOfBirthField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];

   errorMSG = @"";

    if ([_firstNameField.text isEqualToString:@""]){
        [ALERT_PRESENTER presentAlertWithTitle:NSLocalizedString(@"error",nil) message:NSLocalizedString(@"msg_3",nil)];
        return;
    }
    if([_lastNameField.text isEqualToString:@""]){
        [ALERT_PRESENTER presentAlertWithTitle:NSLocalizedString(@"error",nil) message:NSLocalizedString(@"msg_4",nil)];
        return;
    }
    if ([_middleNameField.text isEqualToString:@""]) {
        [ALERT_PRESENTER presentAlertWithTitle:NSLocalizedString(@"error",nil) message:NSLocalizedString(@"msg_5",nil)];
        return;
    }
    if ([_dateOfBirthField.text isEqualToString:@""]) {
        [ALERT_PRESENTER presentAlertWithTitle:NSLocalizedString(@"error",nil) message:NSLocalizedString(@"msg_6",nil)];
        return;
    }

    [masterVC.user setFirstName:_firstNameField.text];
    [masterVC.user setLastName:_lastNameField.text];
    [masterVC.user setMiddleName:_middleNameField.text];
    [masterVC.user setDateOfBirth:_dateOfBirthField.text];
    
    [masterVC nextButtonPressed];

}

@end
