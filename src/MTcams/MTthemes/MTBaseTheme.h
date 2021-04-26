//
//  Theme
//  MTcams
//
//  Created by Milovan Tomasevic on 11/10/2017.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
//Font style names section
//*****
extern NSString* const OCFontStyleRegular;
extern NSString* const OCFontStyleLight;
extern NSString* const OCFontStyleBold;
extern NSString* const OCFontStyleMedium;
extern NSString* const OCFontStyleItalic;
//*****************************************

//Font size names section
//******
extern CGFloat const kFontSizeMinimum;
extern CGFloat const kFontSizeMedium;
extern CGFloat const kFontSizeBtnScenesiPad;
extern CGFloat const kFontSizeBtnScenesiPhone;
//iPhone specific
extern CGFloat const kFontSizeDefIPhone;
extern CGFloat const kFontSizeMaxIPhone;
//iPad specific
extern CGFloat const kFontSizeDefIPad;
extern CGFloat const kFontSizeMaxIPad;
//*****************************************

@interface MTBaseTheme : NSObject

@property (nonatomic, strong, readonly) NSDictionary* currentFontParams;
@property (nonatomic, assign, readonly) CGFloat fontSizeDefault;
@property (nonatomic, assign, readonly) CGFloat fontSizeMaximum;

- (void)setPrimaryColorToView:(UIView *)view;
- (void)setAccentColorToView:(UIView *)view;
- (void)setLoginBoxColorToView:(UIView *)view;

// Normal color
- (UIColor*)getBackgroundColor;
- (UIColor*)getPrimaryColor;
- (UIColor*)getPrimaryLightColor;
- (UIColor*)getSecondaryColor;
- (UIColor*)getAccentColor;
- (UIColor*)getTextColor;
- (UIColor*)getStrokeColor;
- (UIColor*)getListBackgroundColor;
- (UIColor*)getListItemColor;
- (UIColor*)getFooterColor;
- (UIColor*)getTabSectionColor;
- (UIColor*)getStepsSelectionColor;
- (UIColor*)getStatusBg;
- (UIColor*)getSceneRuleLogicBackground;
- (UIColor*)getSplashScreenTextColor;
- (UIColor*)getQuickControlTextColor;
// Neutral colors
- (UIColor*)getNeutralBackgroundColor;
- (UIColor*)getNeutralTextColor;
- (UIColor*)getNeutralStrokeColor;
- (UIColor*)getNeutralListColor;
- (UIColor*)getNeutralListItemColor;
- (UIColor*)getNavigationBarColor;

// Unsorted color
- (UIColor*)getUnsortedButtonColor;
// Fail color
- (UIColor*)getFailedColor;

// Alpha colors
- (UIColor*)getPrimaryColorWithAlpha:(CGFloat)alpha;
- (UIColor*)getPrimaryLightColorWithAlpha:(CGFloat)alpha;
- (UIColor*)getTextColorWithAlpha:(CGFloat)alpha;
- (UIColor*)getSecondaryColorWithAlpha:(CGFloat)alpha;
- (void)setPrimaryColorLightWithAlpha:(CGFloat)alpha toView:(UIView *)view;
- (void)setPrimaryColorWithAlpha:(CGFloat)alpha toView:(UIView *)view;
- (void)setStatusBgWithAlpha:(CGFloat)alpha toView:(UIView *)view;
- (void)setPrimaryColorLightToView:(UIView *)view;
- (void)setStatusBgToView:(UIView *)view;

- (NSArray *)getPrimaryColors;

//Fonts
/*!
 @brief Returns common font for application
 @param styleName NSString*  is representing wanted style, values can be picked up only from Font style names section at the top of this file
 @param fontSize CGFloat  is representing wanted plain size.
 @discussion This method return font that corresponds to style and size. Use it only when you need to get non-standartized font size
 @return UIFont*
 */
- (UIFont*)fontWithStyleName:(NSString*)styleName size:(CGFloat)fontSize;

/*!
 @brief Returns dictionary for current font options. MUST BE IMPLEMENTED IN SUBCLASS
 @discussion Dictionary MUST contain values for all base keys from font style names section and font size names section
 @return NSDictionary*
 */
- (NSDictionary*)loadFontParametersDictionary;

@end
