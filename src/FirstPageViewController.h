//
//  FirstPageViewController.h
//  MTcams
//
//  Created by administrator on 4/20/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasePageViewController.h"
#import "MTTextField.h"

@interface FirstPageViewController : BasePageViewController


@property (nonatomic, strong) IBOutlet MTTextField *emailField;
@property (nonatomic, strong) IBOutlet MTTextField *passwordField;
@property (nonatomic, strong) IBOutlet MTTextField *passwordRepeatField;



@end
