//
//  SettingsViewController.m
//  MTcams
//
//  Created by administrator on 4/3/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "SettingsViewController.h"
#import "LIveViewController.h"
#import "Sesija.h"
#import "PreferenceDefines.h"
#import "Settings.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController{
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    Settings *sharedInstance = APP_SETTINGS;
    
    _uidText.text      = sharedInstance.sUID;
    _ipText.text       = sharedInstance.sIPFC;
    _portText.text     = sharedInstance.sPort;
    _usernameText.text = sharedInstance.sUSERNAME;
    _passwordText.text = sharedInstance.sPASSWORD;
    
    LogI(@"Vrednost sPort %@", sharedInstance.sPort);
    
    _uidText.delegate      = self;
    _ipText.delegate       = self;
    _portText.delegate     = self;
    _usernameText.delegate = self;
    _passwordText.delegate = self;
    
    [_uidText setReturnKeyType:UIReturnKeyDone];
    [_ipText setReturnKeyType:UIReturnKeyDone];
    [_portText setReturnKeyType:UIReturnKeyDone];
    [_usernameText setReturnKeyType:UIReturnKeyDone];
    [_passwordText setReturnKeyType:UIReturnKeyDone];



}


- (IBAction)btnLocal:(id)sender{
    
    Sesija *s = [[Sesija alloc] init];
    
    s.sUID           = _uidText.text;
    s.sIp            = _ipText.text;
    s.sPort          = _portText.text;
    s.sUn            = _usernameText.text;
    s.sPass          = _passwordText.text;
    s.connectionType = local;

    LIveViewController *live = (LIveViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"myBord"];
    live.sesija = s;
    [self.navigationController pushViewController:live animated:YES];
    
    LogI(@"s.ip=%@, live.sesija.ip %@", s.sIp, live.sesija.sIp);


}
- (IBAction)btnCloud:(id)sender{
    
    Sesija *s = [[Sesija alloc] init];
    
    s.sUID           = _uidText.text;
    s.sIp            = _ipText.text;
    s.sPort          = _portText.text;
    s.sUn            = _usernameText.text;
    s.sPass          = _passwordText.text;
    s.connectionType = cloud;
    
    LIveViewController *live = (LIveViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"myBord"];
    live.sesija = s;
    [self.navigationController pushViewController:live animated:YES];
    
    LogI(@"s.ip=%@, live.sesija.ip %@", s.sIp, live.sesija.sIp);

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
