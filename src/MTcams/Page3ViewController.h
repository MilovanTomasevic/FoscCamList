//
//  Page3ViewController.h
//  MTcams
//
//  Created by administrator on 4/3/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreImage/CoreImage.h>
#import <UIKit/UIKitDefines.h>
#import <UIKit/UIColor.h>
#import <UIKit/UIGeometry.h>


#import <SystemConfiguration/CaptiveNetwork.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import "CoreDataManager.h"

#import "GradientProgressView.h"
#import "BasePageViewController.h"

@class GradientProgressView;

@interface Page3ViewController : BasePageViewController {
    GradientProgressView *progressView;
}

- (IBAction)next3:(id)sender;

@property (nonatomic, strong)CoreDataManager *coreDataManager;


@end
