//
//  Settings.m
//  MTcams
//
//  Created by administrator on 4/21/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "Settings.h"
#import "PreferenceDefines.h"

@implementation Settings

@synthesize sUID;
@synthesize sSSID;
@synthesize sSSIDpass;
@synthesize sIPIP;
@synthesize sIPFC;
@synthesize sUSERNAME;
@synthesize sPASSWORD;
@synthesize sPort;
@synthesize sConfigured;

+ (id) sharedInstance{
    static Settings *sharedIstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedIstance = [[self alloc] init];
    });
    return sharedIstance;
}

-(id)init{
    if (self = [super init]){
       
        [self initData];

        NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];

        sUID        = [preferences objectForKey:PREF_UID];
        sSSID       = [preferences objectForKey:PREF_SSID];
        sSSIDpass   = [preferences objectForKey:PREF_SSID_PASSWORD];
        sIPIP       = [preferences objectForKey:PREF_IP_ADDRESS_IPHONE];
        sIPFC       = [preferences objectForKey:PREF_IP_ADDRESS_FOSCAM];
        sUSERNAME   = [preferences objectForKey:PREF_USERNAME_FOR_LOGIN_FOSCAM];
        sPASSWORD   = [preferences objectForKey:PREF_PASSWORD_FOR_LOGIN_FOSCAM];
        sPort       = [preferences objectForKey:PREF_PORT_FOR_FOSCAM];
        sConfigured = NO; //[preferences boolForKey  :PREF_CONFIGURED_FOSCAM];
        
        LogI(@"Vrednost sPorta u settingsu init %@", sPort);
    }
    return self;
}


-(void)initData {
    
    
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    
    if ([preferences objectForKey:PREF_UID]== nil){
        [[NSUserDefaults standardUserDefaults] setValue:@"C7VLBC4MEU9396H6111AAZZZ" forKey:PREF_UID];
    }
    
    if ([preferences objectForKey:PREF_SSID]== nil){
        [[NSUserDefaults standardUserDefaults] setValue:@"rtrk-g" forKey:PREF_SSID];
    }
    
    if ([preferences objectForKey:PREF_SSID_PASSWORD]== nil){
        [[NSUserDefaults standardUserDefaults] setValue:@"F0rGuests" forKey:PREF_SSID_PASSWORD];
    }
    
    if ([preferences objectForKey:PREF_IP_ADDRESS_IPHONE]== nil){
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:PREF_IP_ADDRESS_IPHONE];
    }
    
    if ([preferences objectForKey:PREF_IP_ADDRESS_FOSCAM]== nil){
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:PREF_IP_ADDRESS_FOSCAM];
    }
    
    if ([preferences objectForKey:PREF_USERNAME_FOR_LOGIN_FOSCAM]== nil){
        [[NSUserDefaults standardUserDefaults] setValue:@"admin" forKey:PREF_USERNAME_FOR_LOGIN_FOSCAM];
        
    }
    if ([preferences objectForKey:PREF_PASSWORD_FOR_LOGIN_FOSCAM]== nil){
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:PREF_PASSWORD_FOR_LOGIN_FOSCAM];
    }
    
    if ([preferences objectForKey:PREF_PORT_FOR_FOSCAM]== nil){
        [[NSUserDefaults standardUserDefaults] setValue:@"88" forKey:PREF_PORT_FOR_FOSCAM];
    }
/*
    if ([preferences objectForKey:PREF_CONFIGURED_FOSCAM]== nil){
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:PREF_CONFIGURED_FOSCAM];
    }
*/
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)dealloc{
    
}



@end
