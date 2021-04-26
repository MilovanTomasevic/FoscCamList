//
//  Page3ViewController.m
//  MTcams
//
//  Created by administrator on 4/3/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "Page3ViewController.h"
#import "PreferenceDefines.h"
#import <ZXingObjC/ZXingObjC.h>
#import "Settings.h"
#include <arpa/inet.h>
#import "AppDelegate.h"
#import "fossdk.h"


@interface Page3ViewController ()

@end

@implementation Page3ViewController{
    MBProgressHUD *hud, *hud2, *hud3;
    Settings *sharedInstance;
    AppDelegate *appDelegate;
    NSString *mySSID;
}

typedef void(^RunFun)(void* param);

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mySSID = [[NSString alloc]init];
    mySSID = [MTSupport getCurrentWifiSSID];
    
    float topMargin = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
    //float topMargin = [[UIApplication sharedApplication] statusBarFrame].size.height;

    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.coreDataManager = [[CoreDataManager alloc]init];

    CGRect frame = CGRectMake(0, topMargin, self.view.frame.size.width, 3.0f);
    progressView = [[GradientProgressView alloc] initWithFrame:frame];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    progressView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:progressView];
    
    [progressView release];
    
    [progressView setProgress:0];
    [self startProgress];
//    _textView.editable = NO;
    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor orangeColor]}];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //[self.pControl setCurrentPage:2];
    [self.pControl setCurrentPage:2 animated:YES];

    sharedInstance = APP_SETTINGS;
    
    [progressView startAnimating];
    [self simulateProgress];
    
    [self performSelectorInBackground:@selector(configureWIFI) withObject:nil];
}

- (void)startProgress{
    
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = NSLocalizedString(@"please_wait",nil);
    hud.detailsLabel.text = NSLocalizedString(@"config_cam_2_min",nil);
}

- (void)checkWiConfig
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (![self CheckIPAddress: sharedInstance.sIPFC]){
            
            [progressView setProgress:1];
            [progressView stopAnimating];
            FOS_StopEZlink();
            [hud hideAnimated:YES];
            
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);

            
            [ALERT_PRESENTER presentAlertControllerWithConfigurationHandler:^(MTAlertDescriptor * descriptor) {
                descriptor.priority = MTAlertPriorityNormal;
                descriptor.title = NSLocalizedString(@"login_problem", nil);
                descriptor.message = NSLocalizedString(@"please_try_again", nil);
                descriptor.cancelTitle = NSLocalizedString(@"cancel", nil);
                descriptor.otherTitles = @[NSLocalizedString(@"retry", nil)];
                [descriptor setTapBlock:^(UIAlertController *controller, UIAlertAction *action, NSInteger buttonIndex) {
                    if (buttonIndex != MTAlertBlocksCancelButtonIndex) {
                        [progressView setProgress:0];
                        [self startProgress];
                        [self simulateProgress];
                        [progressView startAnimating];
                        [self performSelectorInBackground:@selector(configureWIFI) withObject:nil];
                    }else{
                        [progressView setProgress:0];
                        [self goToHomeView];
                    }
                }];
            }];
        }else{
            
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            [progressView setProgress:1];
            [progressView stopAnimating];

            [hud hideAnimated:YES];
            
            sharedInstance.sConfigured = YES;
            hud3 = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            
            // Set the custom view mode to show any view.
            hud3.mode = MBProgressHUDModeCustomView;
            // Set an image view with a checkmark.
            UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            hud3.customView = [[UIImageView alloc] initWithImage:image];
            // Looks a bit nicer if we make it square.
            hud3.square = YES;
            // Optional label text.
            hud3.label.text = NSLocalizedString(@"cam_configured", nil);
            
            [hud3 hideAnimated:YES afterDelay:2.f];
            
            [self saveData];
            [self performSelector:@selector(goToHomeView) withObject:NULL afterDelay:2.f];
        }
    });
}

- (void)goToHomeView{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (BOOL)CheckIPAddress:(NSString*)url{
    
    //NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(^127\\.)|(^192\\.168\\.)|(^10\\.)|(^172\\.1[6-9]\\.)|(^172\\.2[0-9]\\.)|(^172\\.3[0-1]\\.)|(^::1$)|(^[fF][cCdD])" options:0 error:nil];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(^192\\.168\\.)" options:0 error:nil];
    NSArray *matches = [regex matchesInString:url options:0 range:NSMakeRange(0, url.length)];
    if (matches.count > 0)
        return YES;
    return NO;
}

-(void) configureWIFI{

    FOSCMD_RESULT ret = 0;
    FOSDISCOVERY_NODE getNode;
    
    NSString *phoneIP = [[NSString alloc] init];
    phoneIP = [self getIPAddress];
    LogI(@"phoneIP:%@",phoneIP);
    struct in_addr phoneAddr;
    inet_aton([phoneIP UTF8String], &phoneAddr);
    LogI(@"phoneAddr:%d",phoneAddr.s_addr);
    
    sharedInstance.sIPIP = phoneIP;

    char *uid = (char *)[sharedInstance.sUID UTF8String];
    char *ssid = (char *)[sharedInstance.sSSID UTF8String];
    char *pass = (char *)[sharedInstance.sSSIDpass UTF8String];

    LogI(@"PAGE 3 ingleton kreiran sa vrednostima ssid  i password %@, %@" ,sharedInstance.sSSID, sharedInstance.sSSIDpass);
    
    LogI(@"FOS_StartEZlink2 start!!");
    ret = FOS_StartEZlink2(uid, ssid, pass, phoneAddr.s_addr, &getNode, 12000, 0);
    
    LogI(@"FOS_StartEZlink2 return is %d",ret);
    
    struct in_addr addr = {getNode.ip};
    char ipStr[128] = {0};
    strcpy(ipStr, inet_ntoa(addr));

    char ip[128] = {0};
    int port;
    char usr[64];
    char pwd[64];
    
    strcpy(ip,ipStr);
    port = 88;
    sprintf(usr, "admin");
    sprintf(pwd, "");
    
    LogI(@"Find ip through ezlink~~~~~~~~ip:%s",ip);
    
    NSString *ipFOSCAM =  [[NSString alloc] initWithCString: ip encoding:NSASCIIStringEncoding];
    sharedInstance.sIPFC = ipFOSCAM;
    
    NSString *defUsername =  [[NSString alloc] initWithCString: usr encoding:NSASCIIStringEncoding];
    sharedInstance.sUSERNAME = defUsername;
    
    NSString *defPass =  [[NSString alloc] initWithCString: pwd encoding:NSASCIIStringEncoding];
    sharedInstance.sPASSWORD = defPass;

    LogI(@"PAGE 3  ip kamere je ~~~~~~~~ip:%@",sharedInstance.sIPFC);
    
    LogI(@"PAGE 3  DEFAULT username and password for loginFOSCAM:  ~~~~~~~~: ->%@<- and ->%@<-",sharedInstance.sUSERNAME, sharedInstance.sPASSWORD);
    
   [self checkWiConfig];
}


- (NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}

-(void)saveData{

    sharedInstance = APP_SETTINGS;

    [self.coreDataManager addOrUpdateCamera:sharedInstance.sUID ssid:mySSID ssidPassword:sharedInstance.sSSIDpass ipPhone:sharedInstance.sIPIP ipCamera:sharedInstance.sIPFC username:sharedInstance.sUSERNAME password:sharedInstance.sPASSWORD port:sharedInstance.sPort];
    
    [appDelegate saveContext];
}

- (void)RunInThread :(RunFun) fun{
    fun(NULL);
}

- (IBAction)next3:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

    //line progress
- (void)simulateProgress {

        CGFloat increment = (arc4random() % 3)  *0.005+ 0.0015;
        //CGFloat increment = 0.025;
        CGFloat progress  = [progressView progress] + increment;
        [progressView setProgress:progress];
    
        LogI(@"Vrednost  ---  progress:%f i inkrement %f", progress, increment);
    
        if (progress < 0.65) {
            [self performSelector:@selector(simulateProgress) withObject:self afterDelay:0.5 ];
        }
        if (progress >= 0.65 && progress < 1) {
            [self performSelector:@selector(simulateProgress) withObject:self afterDelay:3.0 ];
        }
        if ( progress >= 1) {
            LogI(@"Konfiguracija zavrsena.");
        }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}
-(void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    switch(orientation)
    {
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown:
        {
            float topMargin = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;           
            CGRect frame = CGRectMake(0, topMargin, self.view.frame.size.width, 3.0f);
            [progressView setFrame:frame];
        
            break;
        }  
        default: {
            break;
        }
    }
}


@end
