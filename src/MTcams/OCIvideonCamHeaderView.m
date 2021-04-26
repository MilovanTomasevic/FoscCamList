//
//  OCIvideonCamHeaderView.m
//  MTcams
//
//  Created by administrator on 4/7/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "OCIvideonCamHeaderView.h"

@implementation OCIvideonCamHeaderView{
    UILabel* _labelTitle;
}

@synthesize buttonBack = _buttonBack;

-(id)initWithFrame:(CGRect)frame andDeviceName:(NSString*)deviceName andAlpha:(CGFloat)alpha{
    self = [super initWithFrame:frame];
    if(self){
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:alpha]];
        [self setHidden:YES];
        [self setAutoresizesSubviews:YES];
        
        _labelTitle = [[UILabel alloc]initWithFrame:self.frame];
        _labelTitle.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        [_labelTitle setText:deviceName];
        [_labelTitle setTextColor:[[UIColor whiteColor ] colorWithAlphaComponent:1]];
        //[_labelTitle setFont:[OCCommon getFontMedium:kFontSizeDefIPhone]];
        [_labelTitle setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_labelTitle];
        
        //_buttonBack = [OCButtonFactory createCustomBackButton:NO];
        //CGSize stringsize = [_buttonBack.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[OCCommon getFontMedium:kFontSizeDefIPad], NSFontAttributeName, nil]];
        //[_buttonBack setFrame:CGRectMake(0, 0, stringsize.width+2*kMarginDefault, self.frame.size.height)];
        //_buttonBack.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        //[self addSubview:_buttonBack];
    }
    return self;
}

@end
