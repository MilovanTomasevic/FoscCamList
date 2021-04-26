//
//  CoreDataManger.h
//  MTcams
//
//  Created by administrator on 5/10/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "Camera+CoreDataClass.h"
#import "User+CoreDataClass.h"
#import "CamUser+CoreDataClass.h"


#define CAMERA_ENTITY_NAME @"Camera"
#define USER_ENTITY_NAME @"User"
#define CAM_AND_USER_ENTITY_NAME @"CamUser"

@interface CoreDataManager : NSObject

@property(nonatomic,retain) NSManagedObjectContext *managedObjectContext;
@property(nonatomic,retain,readonly) NSManagedObjectModel *managedObjectModel;



- (void)deleteDataFromDatabase;


//********************************************************* CAMERA METHOD ************************************//
-(void)addOrUpdateCamera:(NSString*)uid ssid:(NSString*)ssid ssidPassword:(NSString*)ssidPassword ipPhone:(NSString*)ipPhone ipCamera:(NSString*)ipCamera username:(NSString*)username password:(NSString*)password port:(NSString*)port ;
-(Camera*)getCameraWithUid:(NSString*)uid;
-(NSArray*)getAllCams;
-(void)removeCameraWithUid:(NSString*)uid;

//********************************************************* USER METHOD ************************************//
-(void)addOrUpdateUserEmail:(NSString*)email password:(NSString*)pass firstName:(NSString*)first middleName:(NSString*)middle lastName:(NSString*)last dateOfBirth:(NSString*)date phone:(NSString*)phone address:(NSString*)addr town:(NSString*)town postal:(NSString*)postal country:(NSString*)country role:(NSString*)rol;
-(User*)loginUser:(NSString*)email password:(NSString*)pass;
-(User*)getUserWithMail:(NSString*)email;
-(NSArray*)getAllUsers;
-(void)removeUserWithMail:(NSString*)email;
-(User*)getNewUser;

//************************************************* JOIN CAMS & USERS ************************************//
-(void)addJoinCamUsers:(NSString*)uid users:(NSArray*)emails;
-(void)addJoinUserCams:(NSString*)email cams:(NSArray*)uids;

-(NSArray*)getCamsForUser:(NSString*)email;
-(NSArray*)getUsersForCam:(NSString*)uid;

-(void)removeAllSelectedCams:(NSString*)email;
-(void)removeAllSelectedUsers:(NSString*)uid;


@end
