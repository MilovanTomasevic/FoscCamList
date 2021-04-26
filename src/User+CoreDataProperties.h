//
//  User+CoreDataProperties.h
//  MTcams
//
//  Created by administrator on 5/22/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "User+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *adress;
@property (nullable, nonatomic, copy) NSString *country;
@property (nullable, nonatomic, copy) NSString *dateOfBirth;
@property (nullable, nonatomic, copy) NSString *email;
@property (nullable, nonatomic, copy) NSString *firstName;
@property (nullable, nonatomic, copy) NSString *lastName;
@property (nullable, nonatomic, copy) NSString *middleName;
@property (nullable, nonatomic, copy) NSString *password;
@property (nullable, nonatomic, copy) NSString *phone;
@property (nullable, nonatomic, copy) NSString *postalCode;
@property (nullable, nonatomic, copy) NSString *town;
@property (nullable, nonatomic, copy) NSString *role;

@end

NS_ASSUME_NONNULL_END
