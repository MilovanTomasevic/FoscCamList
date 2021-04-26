//
//  MailPageViewController.m
//  MTcams
//
//  Created by Milovan Tomasevic on 5/26/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "MailPageViewController.h"
#import "MasterForgotPasswordViewController.h"

@interface MailPageViewController (){
    MasterForgotPasswordViewController *masterFPVC;
    NSString  *mail;
}

@end

@implementation MailPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    masterFPVC = (MasterForgotPasswordViewController*)self.parentViewController;
    [self loadViewPage];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.pControl setFrame:CGRectMake(0, 55, self.view.frame.size.width, 55)];
    [self.pControl setCurrentPage:0];
    //[self.pControl setCurrentPage:0 animated:YES];
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
    LogI(@"Next button clicked 1 Mail view");

    mail    = _email.text;
    mail    = [mail stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];

    
    masterFPVC.user = [masterFPVC.coreDataManager getUserWithMail:mail];
    
    if (![self validateEmail:mail]) {
        [ALERT_PRESENTER presentAlertWithTitle:NSLocalizedString(@"error",nil) message:NSLocalizedString(@"msg_1",nil)];
        return;
    }
    
    if(masterFPVC.user == nil){
        [ALERT_PRESENTER presentAlertWithTitle:NSLocalizedString(@"error",nil) message:NSLocalizedString(@"msg_1b",nil)];
        return;
    }
    [masterFPVC.user setEmail:mail];
    [masterFPVC nextButtonPressed];
}

-(BOOL)validateEmail:(NSString *)candidate{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}

- (void)loadViewPage{
    
    CGFloat sirinaPolja = self.view.frame.size.width * 0.7;
//    int margina = 10;
    int visinaPolja = 40;
    int visina = 100;
    
    self.email = [[MTTextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - sirinaPolja/2, visina, sirinaPolja, visinaPolja)];

    [self.email customizeField:_email withView:self.view andPlaceholder:NSLocalizedString(@"plsh_1",nil)];
    [self.view setBackgroundColor:[UIColor blackColor]];
}

@end
