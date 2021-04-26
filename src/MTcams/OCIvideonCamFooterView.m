//
//  OCIvideonCamFooterView.m
//  MTcams
//
//  Created by administrator on 4/7/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "OCIvideonCamFooterView.h"

@implementation OCIvideonCamFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@synthesize buttonQuality = _buttonQuality;
@synthesize buttonSnap = _buttonSnap;
@synthesize buttonTalk = _buttonTalk;
@synthesize buttonRecord = _buttonRecord;
@synthesize buttonAudio = _buttonAudio;

-(id)initWithFrame:(CGRect)frame andAlpha:(CGFloat)alpha{
    self = [super initWithFrame:frame];
    if(self){
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:alpha]];
        [self setHidden:YES];
        [self setAutoresizesSubviews:YES];
        
        _buttonRecord =  [UIButton buttonWithType:UIButtonTypeCustom];
        _buttonRecord.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        [_buttonRecord setImage:[UIImage imageNamed:(@"cam_record")] forState:UIControlStateNormal];
        //[btnRecord setEnabled:NO];
        [_buttonRecord setFrame:CGRectMake(kMarginDefault, kMarginDefault/2, kUIButtonNavBarDefHeight, kUIButtonNavBarDefHeight)];
        [self addSubview:_buttonRecord];
        
        _buttonSnap =  [UIButton buttonWithType:UIButtonTypeCustom];
        _buttonSnap.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        [_buttonSnap setImage:[UIImage imageNamed:(@"cam_snapshot")] forState:UIControlStateNormal];
        //[_buttonSnap setEnabled:NO];
        [_buttonSnap setFrame:CGRectMake(CGRectGetMaxX(_buttonRecord.frame)+kMarginDefault, kMarginDefault/2, kUIButtonNavBarDefHeight, kUIButtonNavBarDefHeight)];
        [self addSubview:_buttonSnap];
        
        _buttonAudio =  [UIButton buttonWithType:UIButtonTypeCustom];
        _buttonAudio.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        [_buttonAudio setImage:[UIImage imageNamed:(@"audioOFF")] forState:UIControlStateNormal];
        //[btnRecord setEnabled:NO];
        [_buttonAudio setFrame:CGRectMake(self.frame.size.width/2 - kUIButtonNavBarDefHeight/2, kMarginDefault/2, kUIButtonNavBarDefHeight, kUIButtonNavBarDefHeight)];
        [self addSubview:_buttonAudio];
        
        
        _buttonTalk =  [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _buttonTalk.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [_buttonTalk setImage:[UIImage imageNamed:(@"cam_talk")] forState:UIControlStateNormal];
        //[btnTalk setEnabled:NO];
        [_buttonTalk setFrame:CGRectMake(self.frame.size.width-kUIButtonNavBarDefHeight-kMarginDefault, kMarginDefault/2, kUIButtonNavBarDefHeight, kUIButtonNavBarDefHeight)];
        [self addSubview:_buttonTalk];
        
        _buttonQuality = [UIButton buttonWithType:UIButtonTypeCustom];
        _buttonQuality.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [_buttonQuality setImage:[UIImage imageNamed:(@"cam_quality")] forState:UIControlStateNormal];
        [_buttonQuality setFrame:CGRectMake(CGRectGetMinX(_buttonTalk.frame)-kUIButtonNavBarDefHeight-kMarginDefault, kMarginDefault/2, kUIButtonNavBarDefHeight, kUIButtonNavBarDefHeight)];
        [self addSubview:_buttonQuality];
    }
    return self;
}



@end
