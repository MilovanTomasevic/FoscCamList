//
//  CoreDataManger.m
//  MTcams
//
//  Created by administrator on 5/10/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "CoreDataManager.h"

@implementation CoreDataManager{
    AppDelegate *appDelegate;
}
@synthesize managedObjectContext;


- (id)init{
    self = [super init];
    if (self) {
        appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        managedObjectContext = appDelegate.managedObjectContext;
    }
    return self;
}

//********************************************************* CAMERA METHOD ************************************//

-(void)addOrUpdateCamera:(NSString*)uid ssid:(NSString*)ssid ssidPassword:(NSString*)ssidPassword ipPhone:(NSString*)ipPhone ipCamera:(NSString*)ipCamera username:(NSString*)username password:(NSString*)password port:(NSString*)port{
    
    Camera *cam = [self getCameraWithUid:uid];
    
    if (cam){
        
            cam.uid = uid;
            cam.ssid =ssid;
            cam.ssidPassword = ssidPassword;
            cam.ipPhone = ipPhone;
            cam.ipCamera = ipCamera;
            cam.username = username;
            cam.password = password;
            cam.port = port;
    
    }else {

        Camera *camera = (Camera*) [NSEntityDescription insertNewObjectForEntityForName:CAMERA_ENTITY_NAME inManagedObjectContext:managedObjectContext];

        if (uid != nil) {
            [camera setUid:uid];
        }
        if (ssid != nil) {
            [camera setSsid:ssid];
        }
        if (ssidPassword != nil) {
            [camera setSsidPassword:ssidPassword];
        }
        if (ipPhone != nil) {
            [camera setIpPhone:ipPhone];
        }
        if (ipCamera != nil) {
            [camera setIpCamera:ipCamera];
        }
        if (username != nil) {
            [camera setUsername:username];
        }
        if (password != nil) {
            [camera setPassword:password];
        }
        if (port != nil) {
            [camera setPort:port];
        }
    }
}

-(Camera*)getCameraWithUid:(NSString*)uid{
    NSFetchRequest *fetch = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:CAMERA_ENTITY_NAME inManagedObjectContext:managedObjectContext];
    [fetch setEntity:entity];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"uid == %@",uid];
    [fetch setPredicate:pred];
    NSArray *cams = [managedObjectContext executeFetchRequest:fetch error:nil];
    if (cams.count!=0) {
        return [cams objectAtIndex:0];
    }else{
        return nil;
    }
}



-(NSArray*)getAllCams{
    NSFetchRequest *fetch = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:CAMERA_ENTITY_NAME inManagedObjectContext:managedObjectContext];
    [fetch setEntity:entity];
    NSArray *cams = [managedObjectContext executeFetchRequest:fetch error:nil];
    return cams;
}

-(void)removeCameraWithUid:(NSString*)uid{
    NSFetchRequest *fetch = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:CAMERA_ENTITY_NAME inManagedObjectContext:managedObjectContext];
    [fetch setEntity:entity];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"uid == %@",uid];
    [fetch setPredicate:pred];
    NSArray *cams = [managedObjectContext executeFetchRequest:fetch error:nil];
    for (NSManagedObject *m in cams) {
        [managedObjectContext deleteObject:m];
    }
}


//********************************************************* USER METHOD ************************************//

-(void)addOrUpdateUserEmail:(NSString*)email password:(NSString*)pass firstName:(NSString*)first middleName:(NSString*)middle lastName:(NSString*)last dateOfBirth:(NSString*)date phone:(NSString*)phone address:(NSString*)addr town:(NSString*)town postal:(NSString*)postal country:(NSString*)country role:(NSString*)rol{

    User *user = [self getUserWithMail:email];
    
    if (user){
        
        user.email = email;
        user.password =pass;
        user.firstName = first;
        user.middleName = middle;
        user.lastName = last;
        user.dateOfBirth = date;
        user.phone = phone;
        user.adress = addr;
        user.town = town;
        user.postalCode = postal;
        user.country = country;
        user.role = @"user";
        
    }else {
        
        User *user = (User*) [NSEntityDescription insertNewObjectForEntityForName:USER_ENTITY_NAME inManagedObjectContext:managedObjectContext];
        
        if (email != nil) {
            [user setEmail:email];
        }
        if (pass != nil) {
            [user setPassword:pass];
        }
        if (first != nil) {
            [user setFirstName:first];
        }
        if (middle != nil) {
            [user setMiddleName:middle];
        }
        if (last != nil) {
            [user setLastName:last];
        }
        if (date != nil) {
            [user setDateOfBirth:date];
        }
        if (phone != nil) {
            [user setPhone:phone];
        }
        if (addr != nil) {
            [user setAdress:addr];
        }
        if (town != nil) {
            [user setTown:town];
        }
        if (postal != nil) {
            [user setPostalCode:postal];
        }
        if (country != nil) {
            [user setCountry:country];
        }
            [user setRole:@"user"];
        
    }
}

-(User*)loginUser:(NSString*)email password:(NSString*)pass{
    
    NSFetchRequest *fetch = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:USER_ENTITY_NAME inManagedObjectContext:managedObjectContext];
    [fetch setEntity:entity];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"email == %@ && password == %@",email ,pass];
    [fetch setPredicate:pred];
    NSArray *users = [managedObjectContext executeFetchRequest:fetch error:nil];
    
    if (users.count!=0) {
        return [users objectAtIndex:0];
    }else{
        return nil;
    }
}

-(User*)getUserWithMail:(NSString*)email{
    NSFetchRequest *fetch = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:USER_ENTITY_NAME inManagedObjectContext:managedObjectContext];
    [fetch setEntity:entity];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"email == %@",email];
    [fetch setPredicate:pred];
    NSArray *users = [managedObjectContext executeFetchRequest:fetch error:nil];
    if (users.count!=0) {
        return [users objectAtIndex:0];
    }else{
        return nil;
    }
}


-(User*)getNewUser{
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:USER_ENTITY_NAME inManagedObjectContext:self.managedObjectContext];
    User *newUser = [[User alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];

    return newUser;
}



-(NSArray*)getAllUsers{

    NSFetchRequest *fetch = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:USER_ENTITY_NAME inManagedObjectContext:managedObjectContext];
    [fetch setEntity:entity];
    NSArray *users = [managedObjectContext executeFetchRequest:fetch error:nil];
    return users;
}

-(void)removeUserWithMail:(NSString*)email{

    NSFetchRequest *fetch = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:USER_ENTITY_NAME inManagedObjectContext:managedObjectContext];
    [fetch setEntity:entity];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"email == %@",email];
    [fetch setPredicate:pred];
    NSArray *users = [managedObjectContext executeFetchRequest:fetch error:nil];
    for (NSManagedObject *m in users) {
        [managedObjectContext deleteObject:m];
    }

}

- (void)deleteDataFromDatabase{
    
    NSArray *ent = self.managedObjectModel.entities;
    for (NSEntityDescription *enti in ent) {
        if ([enti.name isEqualToString:CAMERA_ENTITY_NAME]) {
            [self deleteAllObjectsWithEntityName:enti.name inContext:self.managedObjectContext];
        }
    }
}

- (void)deleteAllObjectsWithEntityName:(NSString *)entityName inContext:(NSManagedObjectContext *)context{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    fetchRequest.includesPropertyValues = YES;
    fetchRequest.includesSubentities = YES;
    
    NSError *error;
    NSArray *items = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *managedObject in items) {
        [context deleteObject:managedObject];
    }
}

//************************************************* JOIN CAMS & USERS ************************************//

-(void)addJoinCamUsers:(NSString*)uid users:(NSArray*)emails{

    [self removeAllSelectedUsers:uid];

    for (NSString *email in emails){
        CamUser *cu = (CamUser*) [NSEntityDescription insertNewObjectForEntityForName:CAM_AND_USER_ENTITY_NAME inManagedObjectContext:managedObjectContext];
        cu.cameraUid = uid;
        cu.userEmail= email;
        LogI(@"Add users for cam ----- cam id : %@ user email: %@", cu.cameraUid, cu.userEmail);
    }
}

-(void)addJoinUserCams:(NSString*)email cams:(NSArray*)uids{
    
    [self removeAllSelectedCams:email];
    
    for (NSString *uid in uids){
        CamUser *cu = (CamUser*) [NSEntityDescription insertNewObjectForEntityForName:CAM_AND_USER_ENTITY_NAME inManagedObjectContext:managedObjectContext];
        cu.userEmail= email;
        cu.cameraUid = uid;
         LogI(@"Add cams for users ----- user email : %@ cam id: %@", cu.userEmail, cu.cameraUid);
    }
}

-(NSArray*)getCamsForUser:(NSString*)email{
    
    NSFetchRequest *fetch = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:CAM_AND_USER_ENTITY_NAME inManagedObjectContext:managedObjectContext];
    [fetch setEntity:entity];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"userEmail == %@",email];
    [fetch setPredicate:pred];
    NSArray *listCU = [managedObjectContext executeFetchRequest:fetch error:nil];
    NSMutableArray *res = [[NSMutableArray alloc]init];
    for (CamUser *cu in listCU){
        
        if (cu.cameraUid) {
            LogI(@"get cam  ----- cams");
            [res addObject:cu.cameraUid];
        }
        
    }
    return res;
}

-(NSArray*)getUsersForCam:(NSString*)uid{
    
    NSFetchRequest *fetch = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:CAM_AND_USER_ENTITY_NAME inManagedObjectContext:managedObjectContext];
    [fetch setEntity:entity];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"cameraUid == %@",uid];
    [fetch setPredicate:pred];
    NSArray *listCU = [managedObjectContext executeFetchRequest:fetch error:nil];
    NSMutableArray *res = [[NSMutableArray alloc]init];
    for (CamUser *cu in listCU){
        if (cu.userEmail) {
            LogI(@"get user  ----- users");
            [res addObject:cu.userEmail];
        }
        
    }
    return res;
}

-(void)removeAllSelectedCams:(NSString*)email{

    NSFetchRequest *fetch = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:CAM_AND_USER_ENTITY_NAME inManagedObjectContext:managedObjectContext];
    [fetch setEntity:entity];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"userEmail == %@",email];
    [fetch setPredicate:pred];
    NSArray *users = [managedObjectContext executeFetchRequest:fetch error:nil];
    for (NSManagedObject *m in users) {
        LogI(@"Remove  ----- cams");
        [managedObjectContext deleteObject:m];
        
    }
}

-(void)removeAllSelectedUsers:(NSString*)uid{
    
    NSFetchRequest *fetch = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:CAM_AND_USER_ENTITY_NAME inManagedObjectContext:managedObjectContext];
    [fetch setEntity:entity];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"cameraUid == %@",uid];
    [fetch setPredicate:pred];
    NSArray *cams = [managedObjectContext executeFetchRequest:fetch error:nil];
    for (NSManagedObject *m in cams) {
        LogI(@"Remove  ----- users");
        [managedObjectContext deleteObject:m];
    }
}

@end
