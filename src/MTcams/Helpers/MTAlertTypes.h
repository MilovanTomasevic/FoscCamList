//
//  MTAlertTypes.h
//  MTcams
//
//  Created by Milovan Tomasevic on 05/10/2017.
//  Copyright © 2017 administrator. All rights reserved.
//
#ifndef MTAlertTypes_h
#define MTAlertTypes_h

typedef NS_ENUM(NSInteger, MTAlertPriority)  {
    MTAlertPriorityLow = 1,
    MTAlertPriorityNormal,
    MTAlertPriorityHigh
};

@class MTAlertDescriptor;
typedef void (^MTAlertDescriptorConfigurator) (MTAlertDescriptor *__nonnull);

typedef void (^MTAlertActionHandler) (UIAlertAction *__nonnull);
typedef void (^MTAlertTextFieldConfigurator) (UITextField *__nonnull);
typedef void (^MTAlertCompletionBlock) (UIAlertController *__nonnull, UIAlertAction * __nonnull, NSInteger);

static NSInteger const MTAlertBlocksCancelButtonIndex = 0;
static NSInteger const MTAlertBlocksDestructiveButtonIndex = 1;
static NSInteger const MTAlertBlocksFirstOtherButtonIndex = 2;

static NSInteger const MTAlertsMaxQueueCount = 15;

#endif /* MTAlertTypes_h */
