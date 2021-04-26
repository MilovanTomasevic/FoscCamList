//
//  NewCamDataViewController.h
//  MTcams
//
//  Created by Milovan Tomasevic on 6/9/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FosDef.h"
#import "FosNvrDef.h"
#import "fosnvrsdk.h"
#import "fossdk.h"
#import "MTTextField.h"

@protocol NewCamDataViewController <NSObject>

- (void)setNewUserNamePass:(NSString *)username withPass:(NSString *)password;

@end


@interface NewCamDataViewController : UIViewController <UITextFieldDelegate>


@property (nonatomic,retain) id<NewCamDataViewController> delegate;

@property (nonatomic, strong) IBOutlet UILabel *titleHeader;
@property (nonatomic, strong) IBOutlet MTTextField *userName;
@property (nonatomic, strong) IBOutlet MTTextField *password;
@property (nonatomic, strong) IBOutlet UIButton *done;

@property FOSHANDLE  newHandle;


@end
