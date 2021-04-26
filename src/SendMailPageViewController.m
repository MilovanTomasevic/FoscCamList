//
//  SendMailPageViewController.m
//  MTcams
//
//  Created by Milovan Tomasevic on 5/26/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "SendMailPageViewController.h"
#import "MasterForgotPasswordViewController.h"

@interface SendMailPageViewController (){
    MasterForgotPasswordViewController *masterFPVC;
    UITextView *textView;

}

@end

@implementation SendMailPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    masterFPVC = (MasterForgotPasswordViewController*)self.parentViewController;
    [self loadTextView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.pControl setFrame:CGRectMake(0, 55, self.view.frame.size.width, 55)];
    [self.pControl setCurrentPage:2];
    //[self.pControl setCurrentPage:2 animated:YES];
    [self loadLeftRightButton];
}

- (void)loadTextView{
    
    CGFloat sirinaPolja = self.view.frame.size.width * 0.7;
    int visinaPolja = 70;
    int visina = 100;

    textView = [[UITextView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - sirinaPolja/2, visina, sirinaPolja, visinaPolja)];
    textView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    textView.text = NSLocalizedString(@"warning_send_mail",nil);
    [textView sizeToFit];
    textView.scrollEnabled = YES;
    textView.editable = NO;
    [self.view addSubview:textView];
    
}

- (void)loadLeftRightButton{
    
    masterFPVC.navigationItem.leftBarButtonItem= [[UIBarButtonItem alloc] initWithTitle:@"<"
                                                                                style:UIBarButtonItemStylePlain
                                                                               target:self
                                                                               action:@selector(customBackButtonPressed)];
    
    
    masterFPVC.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"done",nil)
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
    LogI(@"Next button clicked 3 SendMail view");
    
    [masterFPVC sendMail];

}

-(void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    switch(orientation)
    {
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
        {
            CGFloat sirinaPolja = self.view.frame.size.width * 0.6;
            int visinaPolja = 70;
            int visina = 100;
            
            [textView setFrame:CGRectMake(self.view.frame.size.width/2 - sirinaPolja/2, visina, sirinaPolja, visinaPolja)];
            textView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
            [textView sizeToFit];
            break;
        }
            
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown:
        {
            CGFloat sirinaPolja = self.view.frame.size.width * 0.7;
            int visinaPolja = 70;
            int visina = 100;
            
            [textView setFrame:CGRectMake(self.view.frame.size.width/2 - sirinaPolja/2, visina, sirinaPolja, visinaPolja)];
            textView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
            [textView sizeToFit];
            break;
        }
        default: {
            break;
        }
    }
}




@end
