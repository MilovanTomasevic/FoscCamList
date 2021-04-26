//
//  ForgotPasswordViewController.h
//  MTcams
//
//  Created by administrator on 5/25/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "CoreDataManager.h"


@interface MasterForgotPasswordViewController : UIViewController <MFMailComposeViewControllerDelegate, UITextFieldDelegate>


@property (nonatomic, strong)CoreDataManager *coreDataManager;
@property (nonatomic, strong)User *user;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

- (void)nextButtonPressed;
-(void)customBackButtonPressed;

-(void) sendMail;



@end
