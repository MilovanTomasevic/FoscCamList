//
//  Page1ViewController.h
//  MTcams
//
//  Created by administrator on 4/3/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZXingObjC/ZXingObjC.h>
#import "BasePageViewController.h"

@interface Page1ViewController : BasePageViewController <ZXCaptureDelegate>



@property (weak, nonatomic) IBOutlet UIButton *nextpressed;


@end
