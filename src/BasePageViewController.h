//
//  BasePageViewController.h
//  MTcams
//
//  Created by administrator on 4/20/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJPageControl.h"

@interface BasePageViewController : UIViewController <UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UITextField *descriptionText;

//@property (nonatomic, strong) IBOutlet ZJPageControl *pControl;
@property (nonatomic, strong) IBOutlet UIPageControl *pControl;



@end
