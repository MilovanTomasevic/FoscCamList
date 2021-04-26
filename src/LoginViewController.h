//
//  LoginViewController.h
//  MTcams
//
//  Created by administrator on 5/19/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasePageViewController.h"
#import "MTTextField.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate>


@property (nonatomic, strong) IBOutlet MTTextField *emailLoginField;
@property (nonatomic, strong) IBOutlet MTTextField *passwordLoginField;

@property (nonatomic, strong) IBOutlet UIButton *buttonLogin;
@property (nonatomic, strong) IBOutlet UIButton *buttonRegistar;

@property (nonatomic, strong) IBOutlet UIButton *forgotPassword;


@end
