//
//  Page2ViewController.h
//  MTcams
//
//  Created by administrator on 4/3/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import "BasePageViewController.h"
#import "MTTextField.h"

@interface Page2ViewController : BasePageViewController <UITextFieldDelegate>


@property (nonatomic, strong) IBOutlet MTTextField *wifiSSID;
@property (nonatomic, strong) IBOutlet MTTextField *passwordWiFi;

- (IBAction)next2:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *next2Button;
@property (weak, nonatomic) IBOutlet UILabel *descriptionlabel;


@end
