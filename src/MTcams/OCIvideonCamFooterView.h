//
//  OCIvideonCamFooterView.h
//  MTcams
//
//  Created by administrator on 4/7/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OCIvideonCamFooterView : UIView

@property (nonatomic, retain)UIButton *buttonQuality;
@property (nonatomic, retain)UIButton *buttonSnap;
@property (nonatomic, retain)UIButton *buttonRecord;
@property (nonatomic, retain)UIButton *buttonTalk;
@property (nonatomic, retain)UIButton *buttonAudio;


-(id)initWithFrame:(CGRect)frame andAlpha:(CGFloat)alpha;



@end
