//
//  SettingsViewController.h
//  MTcams
//
//  Created by administrator on 4/3/17.
//  Copyright © 2017 administrator. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreImage/CoreImage.h>
#import <UIKit/UIKitDefines.h>
#import <UIKit/UIColor.h>
#import <UIKit/UIGeometry.h>

#import "FosCom.h"
#import "FosDef.h"
#import "FosNvrDef.h"
#import "fosnvrsdk.h"
#import "fossdk.h"


#import <SystemConfiguration/CaptiveNetwork.h>
#import <ifaddrs.h>
#import <arpa/inet.h>


#import <UIKit/UIKit.h>



@interface SettingsViewController : UIViewController <UITextFieldDelegate>



@property (weak, nonatomic) IBOutlet UILabel *uidLabel;
@property (weak, nonatomic) IBOutlet UITextField *uidText;


@property (weak, nonatomic) IBOutlet UILabel *ipLabel;
@property (weak, nonatomic) IBOutlet UITextField *ipText;

@property (weak, nonatomic) IBOutlet UILabel *portLabel;
@property (weak, nonatomic) IBOutlet UITextField *portText;

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UITextField *usernameText;

@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;


@property (weak, nonatomic) IBOutlet UIButton *local;
@property (weak, nonatomic) IBOutlet UIButton *cloud;



- (IBAction)btnLocal:(id)sender;
- (IBAction)btnCloud:(id)sender;





@end
