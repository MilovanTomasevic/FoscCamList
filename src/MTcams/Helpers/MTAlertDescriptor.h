//
//  MTAlertDescriptor.h
//  MTcams
//
//  Created by Milovan Tomasevic on 05/10/2017.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTAlertTypes.h"
#import "MTAlertValidator.h"

/**
    Describes UIAlert info(title, message, buttons) and behavior.
    There is no needs to create objects of this class primary, just use "presendAlertcontrollerWithConfigurationHandler:" method from MTAlertPresenter.
 */
@interface MTAlertDescriptor : NSObject

// dialog strings
@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy, nullable) NSString *message;

// buttons strings
@property (nonatomic, copy, nullable) NSString *cancelTitle;
@property (nonatomic, copy, nullable) NSString *destructiveTitle;
@property (nonatomic, copy, nullable) NSArray<NSString *> *otherTitles;

// other
@property (nonatomic, assign) MTAlertPriority priority;
@property (nonatomic, copy, nullable) MTAlertCompletionBlock tapBlock;
@property (nonatomic, copy, nullable) MTAlertTextFieldConfigurator textFieldConfig;

//config
@property (nonatomic, strong, nullable) MTAlertValidator* alertValidator;

- (nullable UIAlertController *)alertControllerWithCompletion:(nullable void (^)())handler;

@end
