//
//  User+CoreDataProperties.m
//  MTcams
//
//  Created by administrator on 5/22/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "User+CoreDataProperties.h"

@implementation User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"User"];
}

@dynamic adress;
@dynamic country;
@dynamic dateOfBirth;
@dynamic email;
@dynamic firstName;
@dynamic lastName;
@dynamic middleName;
@dynamic password;
@dynamic phone;
@dynamic postalCode;
@dynamic town;
@dynamic role;

@end
