//
//  Settings.h
//  MTcams
//
//  Created by administrator on 4/21/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject{
    NSString *sUID;
    NSString *sSSID;
    NSString *sSSIDpass;
    NSString *sIPIP;
    NSString *sIPFC;
    NSString *sUSERNAME;
    NSString *sPASSWORD;
    NSString *sPort;
    BOOL sConfigured;
}

@property (nonatomic, retain) NSString *sUID;
@property (nonatomic, retain) NSString *sSSID;
@property (nonatomic, retain) NSString *sSSIDpass;
@property (nonatomic, retain) NSString *sIPIP;
@property (nonatomic, retain) NSString *sIPFC;
@property (nonatomic, retain) NSString *sUSERNAME;
@property (nonatomic, retain) NSString *sPASSWORD;
@property (nonatomic, retain) NSString *sPort;
@property BOOL sConfigured;

+ (id) sharedInstance;

@end
