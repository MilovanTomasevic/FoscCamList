//
//  CamUser+CoreDataProperties.h
//  MTcams
//
//  Created by Milovan Tomasevic on 6/15/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "CamUser+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CamUser (CoreDataProperties)

+ (NSFetchRequest<CamUser *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *userEmail;
@property (nullable, nonatomic, copy) NSString *cameraUid;

@end

NS_ASSUME_NONNULL_END
