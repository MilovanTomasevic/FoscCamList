//
//  FirstPageViewController.m
//  MTcams
//
//  Created by administrator on 4/20/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "FirstPageViewController.h"
#import "SecondPageViewController.h"
#import "MasterViewController.h"

@interface FirstPageViewController (){
    MasterViewController *masterVC;
}

@end

@implementation FirstPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    masterVC = (MasterViewController*)self.parentViewController;
    [self loadViewPage];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.pControl setFrame:CGRectMake(0, 55, self.view.frame.size.width, 55)];
    [self.pControl setCurrentPage:0];
    //[self.pControl setCurrentPage:0 animated:YES];
    [self loadLeftRightButton];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [masterVC.user setEmail:_emailField.text];
    [masterVC.user setPassword:_passwordField.text];
    
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void) loadViewPage{
    CGFloat sirinaPolja = self.view.frame.size.width * 0.7;
    int margina = 10;
    int visinaPolja = 40;
    int visina = 100;
    
    self.emailField =          [[MTTextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - sirinaPolja/2, visina, sirinaPolja, visinaPolja)];
    self.passwordField =       [[MTTextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - sirinaPolja/2, visina + visinaPolja + margina , sirinaPolja, visinaPolja)];
    self.passwordRepeatField = [[MTTextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - sirinaPolja/2, visina + 2*visinaPolja + 2*margina , sirinaPolja, visinaPolja)];
    
    [_emailField customizeField:_emailField withView:self.view andPlaceholder:NSLocalizedString(@"plsh_1",nil)];
    [_passwordField customizeField:_passwordField withView:self.view andPlaceholder:NSLocalizedString(@"plsh_2",nil)];
    [_passwordRepeatField customizeField:_passwordRepeatField withView:self.view andPlaceholder:NSLocalizedString(@"plsh_2a",nil)];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
}

-(void)customBackButtonPressed
{
    [masterVC customBackButtonPressed];
}

-(void)nextPage
{
        LogI(@"Next button clicked 1 Page view");
    
    if (![self validateEmail:_emailField.text]) {
        [ALERT_PRESENTER presentAlertWithTitle:NSLocalizedString(@"error",nil) message:NSLocalizedString(@"msg_1",nil)];
        return;
    }
    
    if (![_passwordField.text isEqualToString:_passwordRepeatField.text]) {
        [ALERT_PRESENTER presentAlertWithTitle:NSLocalizedString(@"error",nil) message:NSLocalizedString(@"msg_2a",nil)];
        return;
    }
    
        //trim string from edit text
        _emailField.text = [_emailField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
        _passwordField.text = [_passwordField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
        _passwordRepeatField.text = [_passwordRepeatField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];

    
        [masterVC.user setEmail:_emailField.text];
        [masterVC.user setPassword:_passwordField.text];
    
    LogI(@" setovani mail:   %@ i pass %@", masterVC.user.email, masterVC.user.password);
    
        [masterVC nextButtonPressed];
}

-(BOOL)validateEmail:(NSString *)candidate{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}

@end
