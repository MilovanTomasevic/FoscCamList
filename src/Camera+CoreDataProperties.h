//
//  Camera+CoreDataProperties.h
//  MTcams
//
//  Created by administrator on 5/11/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "Camera+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Camera (CoreDataProperties)

+ (NSFetchRequest<Camera *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *ipCamera;
@property (nullable, nonatomic, copy) NSString *ipPhone;
@property (nullable, nonatomic, copy) NSString *password;
@property (nullable, nonatomic, copy) NSString *port;
@property (nullable, nonatomic, copy) NSString *ssid;
@property (nullable, nonatomic, copy) NSString *ssidPassword;
@property (nullable, nonatomic, copy) NSString *uid;
@property (nullable, nonatomic, copy) NSString *username;

@end

NS_ASSUME_NONNULL_END
