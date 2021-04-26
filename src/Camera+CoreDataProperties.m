//
//  Camera+CoreDataProperties.m
//  MTcams
//
//  Created by administrator on 5/11/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "Camera+CoreDataProperties.h"

@implementation Camera (CoreDataProperties)

+ (NSFetchRequest<Camera *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Camera"];
}

@dynamic ipCamera;
@dynamic ipPhone;
@dynamic password;
@dynamic port;
@dynamic ssid;
@dynamic ssidPassword;
@dynamic uid;
@dynamic username;

@end
