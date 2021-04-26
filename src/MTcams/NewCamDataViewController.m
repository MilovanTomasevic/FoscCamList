//
//  NewCamDataViewController.m
//  MTcams
//
//  Created by Milovan Tomasevic on 6/9/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "NewCamDataViewController.h"
#import "CoreDataManager.h"
#import "Settings.h"
#import "MBProgressHUD.h"
#import <SystemConfiguration/CaptiveNetwork.h>

static NSString* const kSSID_String = @"SSID";

@interface NewCamDataViewController ()

@end

@implementation NewCamDataViewController{
    AppDelegate *appDelegate;
    CoreDataManager *coreDataManager;
    Settings *sharedInstance;
    NSString *mySSID;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mySSID = [[NSString alloc]init];
    mySSID = [MTSupport getCurrentWifiSSID];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    coreDataManager = [[CoreDataManager alloc]init];
    sharedInstance = APP_SETTINGS;
    
    [self loadPageView];
}

- (void)doneButtonClicked{
    
    sharedInstance.sUSERNAME   = [self.userName.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    sharedInstance.sPASSWORD   = [self.password.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    self.userName.text = sharedInstance.sUSERNAME;
    self.password.text = sharedInstance.sPASSWORD;

     if ([sharedInstance.sUSERNAME isEqualToString:@""]){
         [ALERT_PRESENTER presentAlertWithTitle:NSLocalizedString(@"error",nil) message:NSLocalizedString(@"msg_12",nil)];
         return;
    }
    if ([sharedInstance.sUSERNAME isEqualToString:@"admin"]){
        [ALERT_PRESENTER presentAlertWithTitle:NSLocalizedString(@"error",nil) message:NSLocalizedString(@"msg_13",nil)];
        return;
    }
    if ([sharedInstance.sPASSWORD isEqualToString:@""]){
        [ALERT_PRESENTER presentAlertWithTitle:NSLocalizedString(@"error",nil) message:NSLocalizedString(@"msg_14",nil)];
        return;
    }

    char *newName = (char *)[sharedInstance.sUSERNAME UTF8String];
    char *newPwd = (char *)[sharedInstance.sPASSWORD UTF8String];
    int usrPrivilege = 0;

    FOSCMD_RESULT ret = FosSdk_Login(_newHandle, &usrPrivilege, 500);
    LogI(@"stampamo ret %i", ret);
    if (FOSCMDRET_OK != ret) {
        LogI(@"---------------------------LOGIN nije ok");
        [self messagePresent];
    }

    // change data
    
    ret = FosSdk_ChangeUserNameAndPwdTogether(_newHandle, 500, "admin", newName, "", newPwd);
    if (FOSCMDRET_OK != ret) {
        
        LogI(@"---------------------------Change data Problem");
        [self messagePresent];
    }else{
        
        //podaci promenjeni na serveru
        LogI(@"Change data  ok");
        
        //save to database
        [coreDataManager addOrUpdateCamera:sharedInstance.sUID ssid:mySSID ssidPassword:sharedInstance.sSSIDpass ipPhone:sharedInstance.sIPIP ipCamera:sharedInstance.sIPFC username:sharedInstance.sUSERNAME password:sharedInstance.sPASSWORD port:sharedInstance.sPort];
        [appDelegate saveContext];
        
        [_userName resignFirstResponder];
        [_password resignFirstResponder];
        [self.delegate setNewUserNamePass:sharedInstance.sUSERNAME withPass:sharedInstance.sPASSWORD];
        [self progressUpdated];
        [self performSelector:@selector(goToBack) withObject:NULL afterDelay:2.f];
    }
}
    
-(void)messagePresent{
    
    [ALERT_PRESENTER presentAlertControllerWithConfigurationHandler:^(MTAlertDescriptor * descriptor) {
        descriptor.priority = MTAlertPriorityNormal;
        descriptor.title = NSLocalizedString(@"login_problem", nil);
        descriptor.message = NSLocalizedString(@"please_try_again", nil);
        descriptor.cancelTitle = NSLocalizedString(@"cancel", nil);
        descriptor.otherTitles = @[NSLocalizedString(@"retry", nil)];
        [descriptor setTapBlock:^(UIAlertController *controller, UIAlertAction *action, NSInteger buttonIndex) {
            if (buttonIndex != MTAlertBlocksCancelButtonIndex) {
                [self doneButtonClicked];
            }else{
                [self goToBack];
            }
        }];
    }];
}

- (void)progressUpdated{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    hud.square = YES;
    hud.label.text = NSLocalizedString(@"info_updated", nil);
    [hud hideAnimated:YES afterDelay:2.f];
}
- (void)goToBack{
    [self dismissViewControllerAnimated:NO completion:nil];
}


- (void)loadPageView{

    CGFloat sirinaPolja = self.view.frame.size.width * 0.7;
    CGFloat sirinaDugmeta = self.view.frame.size.width * 0.4;
    int margina = 10;
    int visinaPolja = 40;
    int visina = 100;
    
    self.titleHeader =  [[UILabel alloc]initWithFrame:CGRectMake(0, margina, self.view.frame.size.width, visinaPolja)];
    self.userName =  [[MTTextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - sirinaPolja/2, visina, sirinaPolja, visinaPolja)];
    self.password =  [[MTTextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - sirinaPolja/2, visina + visinaPolja + margina , sirinaPolja, visinaPolja)];
    self.done =      [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - sirinaDugmeta/2, visina + 2*visinaPolja + 2*margina , sirinaDugmeta, visinaPolja)];
    
    _titleHeader.text = NSLocalizedString(@"new_data",nil);
    _titleHeader.numberOfLines = 1;
    _titleHeader.baselineAdjustment = UIBaselineAdjustmentAlignCenters; // or UIBaselineAdjustmentAlignCenters, or UIBaselineAdjustmentNone
    _titleHeader.adjustsFontSizeToFitWidth = YES;
    _titleHeader.minimumScaleFactor = 10.0f/12.0f;
    _titleHeader.clipsToBounds = YES;
    _titleHeader.backgroundColor = [UIColor clearColor];
    _titleHeader.textColor = [UIColor orangeColor];
    _titleHeader.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_titleHeader];
    
    [_done setTitle:NSLocalizedString(@"login",nil) forState:UIControlStateNormal];
    _done.layer.cornerRadius = 7;
    [_done addTarget:self action:@selector(doneButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [_done setBackgroundColor: [ UIColor orangeColor]];
    _done.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_done];

    [_userName customizeField:_userName withView:self.view andPlaceholder:NSLocalizedString(@"plsh_13",nil)];
    [_password customizeField:_password withView:self.view andPlaceholder:NSLocalizedString(@"plsh_14",nil)];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
}

@end
