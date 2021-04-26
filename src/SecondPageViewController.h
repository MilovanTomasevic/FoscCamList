//
//  SecondPageViewController.h
//  MTcams
//
//  Created by administrator on 4/20/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasePageViewController.h"
#import "MTTextField.h"

@interface SecondPageViewController : BasePageViewController


@property (nonatomic, strong) IBOutlet MTTextField *firstNameField;
@property (nonatomic, strong) IBOutlet MTTextField *lastNameField;
@property (nonatomic, strong) IBOutlet MTTextField *middleNameField;
@property (nonatomic, strong) IBOutlet MTTextField *dateOfBirthField;





@end
