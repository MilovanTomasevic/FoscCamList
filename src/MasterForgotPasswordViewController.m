//
//  ForgotPasswordViewController.m
//  MTcams
//
//  Created by administrator on 5/25/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "MasterForgotPasswordViewController.h"
#import "MBProgressHUD.h"
#import "MailPageViewController.h"
#import "DataPhonePageViewController.h"
#import "SendMailPageViewController.h"

@interface MasterForgotPasswordViewController (){
    NSString  *mail, *dateOfB, *iPhone;
     int currentPage;
}

@end

@implementation MasterForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.coreDataManager = [[CoreDataManager alloc]init];
    self.user = [self.coreDataManager getNewUser];

    currentPage = 0;
    
    [self loadScrollView];
    
    [self addChildViewController:[[MailPageViewController alloc]init]];
    [self addChildViewController:[[DataPhonePageViewController alloc]init]];
    [self addChildViewController:[[SendMailPageViewController alloc]init]];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.view addSubview:[self.childViewControllers objectAtIndex:currentPage].view];
}

- (void)loadScrollView{
    CGRect frame = CGRectMake( 0, 0, self.view.frame.size.width, self.view.frame.size.height-1);
    //CGRect frame = CGRectMake( 30, 30, 300, 300);
    self.scrollView= [[UIScrollView alloc] initWithFrame:frame];
    _scrollView.contentSize=CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    [_scrollView setBackgroundColor: [UIColor blackColor]];
    [_scrollView setUserInteractionEnabled:YES];
    [_scrollView setScrollEnabled:YES];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    
    [self.view addSubview:_scrollView];
}


-(void)customBackButtonPressed{
    [self.view endEditing:YES];
    
    int page = currentPage;
    
    if (page == 0){
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        
        [[self.childViewControllers objectAtIndex:page].view removeFromSuperview];
        [self.view addSubview:[self.childViewControllers objectAtIndex:page-1].view];
        currentPage = page-1;
    }
}

- (void)nextButtonPressed {
    int page = currentPage;
    
    CGRect frame = _scrollView.frame;
    frame.origin.x = frame.size.width * (page+1);
    frame.origin.y = 0;
    
    [_scrollView scrollRectToVisible:frame animated:YES];
    
    [[self.childViewControllers objectAtIndex:page].view removeFromSuperview];
    [self.view addSubview:[self.childViewControllers objectAtIndex:page+1].view];
    currentPage = page+1;
}


-(void)sendMail {

    LogI(@"Send mail  MASTER button clicked");

    // From within your active view controller
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;        // Required to invoke mailComposeController when send
        
        [mailCont setSubject:@"Password for FosCam iOS app"];
        [mailCont setToRecipients:[NSArray arrayWithObject:self.user.email]];
        //[mailCont setMessageBody:@"This is your password to login to the application. Please do update information for the protection and security of information." isHTML:NO];
        [mailCont setMessageBody:[NSString stringWithFormat:NSLocalizedString(@"msg_20" , nil), self.user.password ] isHTML:NO];
        [self presentViewController:mailCont animated:YES completion:nil];
    }
    [self progressDone];
    //root page
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)progressDone{

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    hud.square = YES;
    hud.label.text = [NSString stringWithFormat:NSLocalizedString(@"mail_sent", nil), self.user.email ];
    [hud hideAnimated:YES afterDelay:1.f];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)validateEmail:(NSString *)candidate{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
