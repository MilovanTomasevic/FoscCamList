//
//  AppDelegate.h
//  MTcams
//
//  Created by administrator on 4/3/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

typedef NS_ENUM(NSUInteger, configType) {
    wired,
    wifi
};


@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,retain,readonly) NSManagedObjectModel *managedObjectModel;
@property(nonatomic,retain,readonly) NSManagedObjectContext *managedObjectContext;
@property(nonatomic,retain,readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property(nonatomic,assign)configType configurationType;

- (void)saveContext;

@end


