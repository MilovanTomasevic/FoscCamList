//
//  OCIvideonCamHeaderView.h
//  MTcams
//
//  Created by administrator on 4/7/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OCIvideonCamHeaderView : UIView

@property (nonatomic, retain)UIButton *buttonBack;

-(id)initWithFrame:(CGRect)frame andDeviceName:(NSString*)deviceName andAlpha:(CGFloat)alpha;



@end
