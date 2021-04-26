//
//  MTAlertPresenter.h
//  MTcams
//
//  Created by Milovan Tomasevic on 05/10/2017.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTAlertTypes.h"

@class MTAlertDescriptor;

/**
    This class implements prioritized alerts and should be used when app want to inform user about some stuff via popup dialog.
    Instance of MTAlertDescriptor is created for every alert call from application, descriptor have priority property{Low, Normal and High} which is used
    to priritize alerts. Priority means that only one alert can be displayed for user at the moment (while he read/decide). 
    And any other lower priority alert will not be displayed while first one on screen, and if higher priority call happens it will replace 
    displayed lower priority alert with new higher priority alert.

    Few examples of using AlertPresenter:

     [[MTAlertPresenter sharedPresenter] presendAlertControllerWithConfigurationHandler:^(MTAlertDescriptor *descriptor) {
         descriptor.priority = MTAlertPriorityHigh;
         descriptor.title = @"Warning!";
         descriptor.message = @"Don't use hard UIAlert and UIAlertController. MTAlertPresenter will help you".;
         descriptor.cancelTitle = @"Ok, thanks";
         descriptor.otherTitles = @[@"Never", @"I will improve it"];

         [descriptor setTapBlock:^(UIAlertController *controller, UIAlertAction *action, NSInteger buttonIndex) {
             if (buttonIndex == MTAlertBlocksCancelButtonIndex)
             {
                 // button with "Ok, thanks" titles is pressed
             }

             if (buttonIndex >= MTAlertBlocksFirstOtherButtonIndex)
             {
                 // expression (buttonIndex - MTAlertBlocksFirstOtherButtonIndex) can be used as index
                 // of titles list that you set in 'otherTitles:' param.
                 // So, 0 == "Never" titled button and 1 == "I will improve it"
             }
         }];
     }];
 */
@interface MTAlertPresenter : NSObject

+ (nullable instancetype)sharedPresenter;

/*!
 @brief present simple Low priority alert with title and messsage, without callback
 @param title - alert title
 @param message - alert message
 */
- (void)presentAlertWithTitle:(nullable NSString *)title message:(nullable  NSString *)message;

/*!
 @brief present alert with title, messsage and priority, without callback
 @param title - alert title
 @param message - alert message
 @param priority - alert priority
 */
- (void)presentAlertWithTitle:(nullable NSString *)title message:(nullable  NSString *)message andPriority:(MTAlertPriority)priority;

/*!
 @brief present alert with configurable title, message, buttons(with titles), textfield and callbacks
 @param configurator - look example in comment at class start for more info
 */
- (void)presentAlertControllerWithConfigurationHandler:(nonnull MTAlertDescriptorConfigurator)configurator;

/*!
 @brief Dissmis alert if it is shown
 */
- (void)dismissAlert;

@end
