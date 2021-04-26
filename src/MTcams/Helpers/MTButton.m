//
//  MTButton.m
//  MTcams
//
//  Created by Milovan Tomasevic on 09/10/2017.
//  Copyright © 2017 administrator. All rights reserved.
// 

#import "MTButton.h"

@implementation MTButton

+ (UIButton *)createCustomBackButton:(BOOL)inverted
{
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    if(inverted) {
        [button setImage:[UIImage imageNamed:(@"back_arrow_black")] forState:UIControlStateNormal];
        //[button setTitleColor:[[[self getTheme] getNeutralTextColor] colorWithAlphaComponent:1] forState:UIControlStateHighlighted];
        //[button setTitleColor:[[[self getTheme] getNeutralTextColor] colorWithAlphaComponent:1] forState:UIControlStateNormal];
    } else {
        [button setImage:[UIImage imageNamed:(@"back_arrow")] forState:UIControlStateNormal];
        //[button setTitleColor:[[[self getTheme] getTextColor] colorWithAlphaComponent:1] forState:UIControlStateHighlighted];
        //[button setTitleColor:[[[self getTheme] getTextColor] colorWithAlphaComponent:1] forState:UIControlStateNormal];
    }
    [button setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, kRightInsentBackArrow)];
    [button setTitle:NSLocalizedString(@"back_button", nil) forState:UIControlStateNormal];
    //[button.titleLabel setFont:[THEME_MANAGER fontWithStyleName:OCFontStyleMedium size:kFontSizeDefIPhone]];
    CGSize stringsize = [NSLocalizedString(@"back_button", nil) sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSFontAttributeName, nil]];
    [button setFrame:CGRectMake(0,0,stringsize.width+kMarginDefault, kUIButtonDefHeight)];
    return button;
}

+ (UIButton *)createDialogButton:(NSString*)btnText{
    UIButton* cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cancelButton setTitle:btnText forState:UIControlStateNormal];
    [cancelButton setBackgroundColor:[UIColor clearColor]];
    //[cancelButton setTitleColor:[[self getTheme] getNeutralTextColor] forState:UIControlStateNormal];
    //cancelButton.titleLabel.font = [THEME_MANAGER fontWithStyleName:OCFontStyleLight size:kFontSizeMedium];
    cancelButton.layer.borderWidth = kBorderDefWidth;
    //cancelButton.layer.borderColor = [[self getTheme] getNeutralStrokeColor].CGColor;
    cancelButton.layer.cornerRadius = kButtonDefCornerRadius;
    cancelButton.layer.masksToBounds =YES;
    CGSize stringsize1 = [cancelButton.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:cancelButton.titleLabel.font, NSFontAttributeName, nil]];
    cancelButton.frame = CGRectMake(0, 0, stringsize1.width+kMarginDefault, kUIButtonDialogDefHeight);
    return cancelButton;
}

+ (UIButton *)createRollerFixButton:(NSString*)imgName{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTintColor:[UIColor whiteColor]];
    [button setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    button.layer.cornerRadius = kButtonDefCornerRadius;
    //button.layer.borderColor = [[self getTheme] getStrokeColor].CGColor;
    button.layer.borderWidth = kBorderDefWidth;
    button.layer.masksToBounds = YES;
    return button;
}

+ (UIButton *)createNavBarButton:(NSString*)btnText{
    UIButton *button2 =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setTitle:btnText forState:UIControlStateNormal];
    [button2 setTitleColor: [UIColor orangeColor] forState:UIControlStateNormal];
    //[button2 setTitleColor:[[[self getTheme] getTextColor] colorWithAlphaComponent:kAlphaComponent] forState:UIControlStateHighlighted];
    CGSize stringsize = [button2.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:button2.titleLabel.font, NSFontAttributeName, nil]];
    [button2 setFrame:CGRectMake(0, 0, stringsize.width+kMarginDefault, kUIButtonNavBarDefHeight)];
    //button2.titleLabel.font = [self fontWithStyleName:FontStyleLight size:kFontSizeDefIPhone];
    button2.layer.borderWidth = kBorderDefWidth;
    button2.layer.borderColor = [UIColor grayColor].CGColor;
    button2.layer.cornerRadius = kButtonDefCornerRadius;
    button2.layer.masksToBounds = YES;
    return button2;
}



+ (UIButton *)createGWSceneButton:(int)yPos frameWidth:(int)frameWidth withName:(NSString*)gwName{
    UIButton* gatewayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    gatewayButton.frame = CGRectMake(0, yPos, frameWidth+2, kUIButtonUnosrtedIPhoneHeight);
    gatewayButton.layer.borderWidth = kBorderDefWidth;
    gatewayButton.layer.masksToBounds = YES;
    //gatewayButton.layer.borderColor = [[self getTheme] getNeutralStrokeColor].CGColor;
    [gatewayButton setTitle:gwName forState:UIControlStateNormal];
    gatewayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [gatewayButton setTitleEdgeInsets:UIEdgeInsetsMake(0, kMarginDefault*3/2, 0, 0)];
    gatewayButton.adjustsImageWhenHighlighted = NO;
    
    //[gatewayButton.titleLabel setFont:[THEME_MANAGER fontWithStyleName:OCFontStyleLight size:kFontSizeDefIPhone]];
    //[gatewayButton setTitleColor:[[self getTheme] getNeutralTextColor] forState:UIControlStateNormal];
    //gatewayButton.backgroundColor = [[self getTheme] getNeutralListItemColor];
    
    UIImage *img = [UIImage imageNamed:@"gateway_filters_blue"];
    //img = [OCCommon filledImageFrom:img withColor:[[self getTheme] getNeutralStrokeColor]];
    [gatewayButton setImage:[img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    // active
    //img = [OCCommon filledImageFrom:img withColor:[[self getTheme] getStrokeColor]];
    //[gatewayButton setImage:[img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateHighlighted];
    //[gatewayButton setTitleColor:[[self getTheme] getNeutralTextColor] forState:UIControlStateNormal];
    //[gatewayButton setTitleColor:[[self getTheme] getNeutralTextColor] forState:UIControlStateHighlighted];
    [gatewayButton setImageEdgeInsets:UIEdgeInsetsMake(kMarginDefault/2, kMarginDefault/2, kMarginDefault/2, 0)];
    return gatewayButton;
}

+ (UIButton *)createGWButton:(int)frameWidth withName:(NSString*)gwName{
    UIButton* gatewayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    gatewayButton.frame = CGRectMake(0, 0, frameWidth+2, kUIButtonUnosrtedIPhoneHeight);
    gatewayButton.layer.borderWidth = kBorderDefWidth;
    gatewayButton.layer.masksToBounds = YES;
    //gatewayButton.layer.borderColor = [[self getTheme]getStrokeColor].CGColor;
    [gatewayButton setTitle:gwName forState:UIControlStateNormal];
    gatewayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [gatewayButton setTitleEdgeInsets:UIEdgeInsetsMake(0, kMarginDefault*3/2, 0, 0)];
    gatewayButton.adjustsImageWhenHighlighted = NO;
    
    //UIImage *tabBGColor = [[OCCommon imageWithColor:[[self getTheme] getAccentColor] andSize:CGSizeMake(1, 1)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //tabBGColor = [OCCommon imageWithGradient:tabBGColor changeAlpha:NO];
    //[gatewayButton setBackgroundImage:tabBGColor forState:UIControlStateHighlighted];
    //[gatewayButton.titleLabel setFont:[THEME_MANAGER fontWithStyleName:OCFontStyleLight size:kFontSizeDefIPhone]];
    //[gatewayButton setTitleColor:[[self getTheme]getTextColor] forState:UIControlStateNormal];
    //[gatewayButton setImage:[[UIImage imageNamed:@"gateway_filters"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [gatewayButton setImageEdgeInsets:UIEdgeInsetsMake(kMarginDefault/2, kMarginDefault/2, kMarginDefault/2, 0)];
    // custom colour for btn
    //gatewayButton.backgroundColor = [[self getTheme] getListItemColor];
    //UIImage *tmpImg = [OCCommon filledImageFrom:[UIImage imageNamed:@"gateway_filters"] withColor:[[self getTheme] getTextColor]];
    //[gatewayButton setImage:tmpImg  forState:UIControlStateNormal];
    //[gatewayButton setTitleColor:[[self getTheme] getTextColor] forState:UIControlStateNormal];
    
    return gatewayButton;
}

+ (UIButton *)createUnsortedDevBtn:(int)numOfUnsorted withFrame:(CGRect)frame{
    UIButton* unsortedDevicesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //unsortedDevicesButton.backgroundColor = [[self getTheme] getUnsortedButtonColor];
    unsortedDevicesButton.titleEdgeInsets = UIEdgeInsetsMake(0, kMarginDefault/2, 0, 0);
    unsortedDevicesButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [unsortedDevicesButton setTitle:NSLocalizedString(@"unsorted_button", nil) forState:UIControlStateNormal];
    [unsortedDevicesButton setTitle:NSLocalizedString(@"unsorted_button", nil) forState:UIControlStateHighlighted];
    [unsortedDevicesButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [unsortedDevicesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //unsortedDevicesButton.titleLabel.font = [THEME_MANAGER fontWithStyleName:OCFontStyleLight size:THEME_MANAGER.fontSizeDefault];
    unsortedDevicesButton.frame = frame;
    int labNumberWidth = kLabelNumOfUnsortDevWidth;
    int arrowWidth = 0;
    if(!IS_IPAD){
        labNumberWidth = kLabelNumOfUnsortDevWidthiPad;
        arrowWidth = kUIButtonArrowImgWidth;
        UIImageView *arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width-arrowWidth-kMarginDefault/2, frame.size.height/2-arrowWidth/2, arrowWidth, arrowWidth)];
        arrowImage.image = [UIImage imageNamed:@"right_arrow"];
        arrowImage.alpha = kArrowImageAlpha;
        arrowImage.contentMode = UIViewContentModeCenter;
        [unsortedDevicesButton addSubview:arrowImage];
    }
    UILabel *numberOfUnsortedDevices = [[UILabel alloc]initWithFrame:CGRectMake(unsortedDevicesButton.frame.size.width-labNumberWidth-kMarginDefault/2, 0, labNumberWidth-arrowWidth-kMarginDefault/2, unsortedDevicesButton.frame.size.height)];
    //numberOfUnsortedDevices.text = STR_FROM_INT(numOfUnsorted);
    numberOfUnsortedDevices.textColor = [UIColor whiteColor];
    //numberOfUnsortedDevices.font = [THEME_MANAGER fontWithStyleName:OCFontStyleLight size:THEME_MANAGER.fontSizeDefault];
    numberOfUnsortedDevices.textAlignment = NSTextAlignmentRight;
    [unsortedDevicesButton addSubview:numberOfUnsortedDevices];
    return unsortedDevicesButton;
}

+ (UIButton *)createFilterBtn:(NSString*)title{
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    //[button setImage:[MTSupport filledImageFrom:[UIImage imageNamed:@"down_arrow"] withColor:[[UIColor redColor]] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    //[button.titleLabel setFont:[THEME_MANAGER fontWithStyleName:OCFontStyleMedium size:kFontSizeDefIPhone]];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setTitleColor:[[UIColor whiteColor]colorWithAlphaComponent:kAlphaComponent] forState:UIControlStateHighlighted];
    CGSize stringsize = [button.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:button.titleLabel.font, NSFontAttributeName, nil]];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, stringsize.width+kMarginDefault/2, 0, 0)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -kMarginDefault/2, 0, 0)];
    [button setFrame:CGRectMake(0, 0, stringsize.width+2*kMarginDefault, kUIButtonDefHeight)];
    //[button setTitleColor:[[self getTheme] getTextColor] forState: UIControlStateNormal];
    return button;
}

+ (UIButton *)createHelpButtonForAdvancedScenes{
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:NSLocalizedString(@"help_button", nil) forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[[UIColor whiteColor]colorWithAlphaComponent:kAlphaComponent] forState:UIControlStateHighlighted];
    CGSize stringsize = [button.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:button.titleLabel.font, NSFontAttributeName, nil]];
    [button setFrame:CGRectMake(0,0,stringsize.width + kMarginDefault, kUIButtonNavBarDefHeight)];
    //button.titleLabel.font = [THEME_MANAGER fontWithStyleName:OCFontStyleLight size:kFontSizeDefIPhone];
    button.layer.borderWidth = kBorderDefWidth;
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.layer.cornerRadius = kButtonDefCornerRadius;
    button.layer.masksToBounds = YES;
    //[button setTitleColor:[[self getTheme] getTextColor] forState: UIControlStateNormal];
    //button.layer.borderColor = [[self getTheme] getNeutralStrokeColor].CGColor;
    
    return button;
}

+(UIButton*)customizeButtonWithArrow:(NSString*)title withFrame:(CGRect)frame{
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor whiteColor]];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [button.layer setBorderWidth:2];
    [button.layer setBorderColor:[UIColor orangeColor].CGColor];
    [button.layer setCornerRadius:7];
    [button.layer setMasksToBounds:YES];
    [button setImage:[UIImage imageNamed:@"down_arrow_blue"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"down_arrow_blue"] forState:UIControlStateSelected];
    [button setTitle:NSLocalizedString(title, nil) forState:UIControlStateNormal];
    [button setFrame:frame];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, button.frame.size.width-20, 0, 0)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];

    return button;
}

+(UIButton*) customizeBarButtonWithImageName:(NSString*)imageName{
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0,0,kUIButtonNavBarDefHeight, kUIButtonNavBarDefHeight)];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    return button;
}

@end
