//
//  CamUser+CoreDataProperties.m
//  MTcams
//
//  Created by Milovan Tomasevic on 6/15/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "CamUser+CoreDataProperties.h"

@implementation CamUser (CoreDataProperties)

+ (NSFetchRequest<CamUser *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CamUser"];
}

@dynamic userEmail;
@dynamic cameraUid;

@end
