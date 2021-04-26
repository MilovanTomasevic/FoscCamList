//
//  AccountInfoViewController.h
//  MTcams
//
//  Created by administrator on 5/22/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CoreDataManager.h"
#import "MTTextField.h"

@interface AccountInfoViewController : UIViewController <UITextFieldDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

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
