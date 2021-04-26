//
//  ThirdPageViewController.h
//  MTcams
//
//  Created by administrator on 4/20/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasePageViewController.h"
#import "MTTextField.h"

@interface ThirdPageViewController : BasePageViewController

@property (nonatomic, strong) IBOutlet MTTextField *townField;
@property (nonatomic, strong) IBOutlet MTTextField *postalCodeField;
@property (nonatomic, strong) IBOutlet MTTextField *adressField;
@property (nonatomic, strong) IBOutlet MTTextField *countryField;
@property (nonatomic, strong) IBOutlet MTTextField *phoneField;


@end
