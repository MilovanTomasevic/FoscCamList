//
//  ThirdPageViewController.m
//  MTcams
//
//  Created by administrator on 4/20/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "ThirdPageViewController.h"
#import "MasterViewController.h"
#import "LoginViewController.h"

@interface ThirdPageViewController (){
    MasterViewController *masterVC;
}


@end

@implementation ThirdPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    masterVC = (MasterViewController*)self.parentViewController;
    [self loadPageView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.pControl setFrame:CGRectMake(0, 55, self.view.frame.size.width, 55)];
    [self.pControl setCurrentPage:2];
    //[self.pControl setCurrentPage:2 animated:YES];
    [self loadLeftRightButton];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [masterVC.user setTown:_townField.text];
    [masterVC.user setPostalCode:_postalCodeField.text];
    [masterVC.user setAdress:_adressField.text];
    [masterVC.user setCountry:_countryField.text];
    [masterVC.user setPhone:_phoneField.text];
}

- (void)loadLeftRightButton{

    masterVC.navigationItem.leftBarButtonItem= [[UIBarButtonItem alloc] initWithTitle:@"<"
                                                                                style:UIBarButtonItemStylePlain
                                                                               target:self
                                                                               action:@selector(customBackButtonPressed)];
    
    
    masterVC.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"done",nil)
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
    
    self.townField =        [[MTTextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - sirinaPolja/2, visina, sirinaPolja, visinaPolja)];
    self.postalCodeField =  [[MTTextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - sirinaPolja/2, visina + visinaPolja + margina , sirinaPolja, visinaPolja)];
    self.adressField =      [[MTTextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - sirinaPolja/2, visina + 2*visinaPolja + 2*margina , sirinaPolja, visinaPolja)];
    self.countryField =     [[MTTextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - sirinaPolja/2, visina + 3*visinaPolja + 3*margina , sirinaPolja, visinaPolja)];
    self.phoneField =       [[MTTextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - sirinaPolja/2, visina + 4*visinaPolja + 4*margina , sirinaPolja, visinaPolja)];

    [_townField customizeField:_townField withView:self.view andPlaceholder:NSLocalizedString(@"plsh_8",nil)];
    [_postalCodeField customizeField:_postalCodeField withView:self.view andPlaceholder:NSLocalizedString(@"plsh_9",nil)];
    [_adressField customizeField:_adressField withView:self.view andPlaceholder:NSLocalizedString(@"plsh_10",nil)];
    [_countryField customizeField:_countryField withView:self.view andPlaceholder:NSLocalizedString(@"plsh_11",nil)];
    [_phoneField customizeField:_phoneField withView:self.view andPlaceholder:NSLocalizedString(@"plsh_12",nil)];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
}

-(void)customBackButtonPressed
{
    [masterVC customBackButtonPressed];
}

-(void)nextPage
{
    LogI(@"Next button clicked 3 Page view");

    _townField.text = [_townField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    _postalCodeField.text = [_postalCodeField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    _adressField.text = [_adressField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    _countryField.text = [_countryField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    _phoneField.text = [_phoneField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    if ([_townField.text isEqualToString:@""]){
        [ALERT_PRESENTER presentAlertWithTitle:NSLocalizedString(@"error",nil) message:NSLocalizedString(@"msg_7",nil)];
        return;
    }
    if([_postalCodeField.text isEqualToString:@""]){
        [ALERT_PRESENTER presentAlertWithTitle:NSLocalizedString(@"error",nil) message:NSLocalizedString(@"msg_8",nil)];
        return;
    }
    if ([_adressField.text isEqualToString:@""]) {
        [ALERT_PRESENTER presentAlertWithTitle:NSLocalizedString(@"error",nil) message:NSLocalizedString(@"msg_9",nil)];
        return;
    }
    if ([_countryField.text isEqualToString:@""]) {
        [ALERT_PRESENTER presentAlertWithTitle:NSLocalizedString(@"error",nil) message:NSLocalizedString(@"msg_10",nil)];
        return;
    }
    if ([_phoneField.text isEqualToString:@""]) {
        [ALERT_PRESENTER presentAlertWithTitle:NSLocalizedString(@"error",nil) message:NSLocalizedString(@"msg_11",nil)];
        return;
    }

    [masterVC.user setTown:_townField.text];
    [masterVC.user setPostalCode:_postalCodeField.text];
    [masterVC.user setAdress:_adressField.text];
    [masterVC.user setCountry:_countryField.text];
    [masterVC.user setPhone:_phoneField.text];
    
    [masterVC addAccountSaveDone];
    
    //root page
    //[self.navigationController popToRootViewControllerAnimated:YES];
    
    //login
    LoginViewController *lvc = [[LoginViewController alloc] init];
    [lvc setTitle:[NSString stringWithFormat:NSLocalizedString(@"log_and_reg",nil)]];
    [self.navigationController pushViewController:lvc animated:YES];
    
}

@end
