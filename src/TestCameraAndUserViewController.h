//
//  TestCameraAndUserViewController.h
//  MTcams
//
//  Created by Milovan Tomasevic on 6/1/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataManager.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "MTTextField.h"

@interface TestCameraAndUserViewController : UIViewController <UITextFieldDelegate>


@property (nonatomic, strong)CoreDataManager *coreDataManager;


@property (strong, nonatomic) IBOutlet MTTextField *uid;
@property (strong, nonatomic) IBOutlet MTTextField *ip;
@property (strong, nonatomic) IBOutlet MTTextField *port;
@property (strong, nonatomic) IBOutlet MTTextField *username;
@property (strong, nonatomic) IBOutlet MTTextField *password;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) IBOutlet MTTextField *emailField;
@property (nonatomic, strong) IBOutlet MTTextField *passwordField;
@property (nonatomic, strong) IBOutlet MTTextField *passwordRepeatField;
@property (nonatomic, strong) IBOutlet MTTextField *firstNameField;
@property (nonatomic, strong) IBOutlet MTTextField *lastNameField;
@property (nonatomic, strong) IBOutlet MTTextField *middleNameField;
@property (nonatomic, strong) IBOutlet MTTextField *dateOfBirthField;
@property (nonatomic, strong) IBOutlet MTTextField *townField;
@property (nonatomic, strong) IBOutlet MTTextField *postalCodeField;
@property (nonatomic, strong) IBOutlet MTTextField *adressField;
@property (nonatomic, strong) IBOutlet MTTextField *countryField;
@property (nonatomic, strong) IBOutlet MTTextField *phoneField;
@property (nonatomic, strong) IBOutlet MTTextField *role;




@end
