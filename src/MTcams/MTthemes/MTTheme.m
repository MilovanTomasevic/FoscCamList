//
//  Theme
//  MTcams
//
//  Created by Milovan Tomasevic on 11/10/2017.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "MTTheme.h"

//Primary color (1)
#define COLOR_PRIMARY(_alpha_) ([UIColor colorWithRed:24.0/255.0 green:40.0/255.0 blue:56.0/255.0 alpha:_alpha_])
//Primary dark color (2)
#define COLOR_PRIMARY_LIGHT(_alpha_) ([UIColor colorWithRed:27.0/255.0 green:45.0/255.0 blue:65.0/255.0 alpha:_alpha_])
//Secondary color (3)
#define COLOR_SECONDARY(_alpha_) [UIColor colorWithRed:26.0/255.0 green:43.0/255.0 blue:63.0/255.0 alpha:_alpha_]
//Background color (4)
#define COLOR_BACKGROUND(_alpha_) ([UIColor colorWithRed:41.0/255.0 green:66.0/255.0 blue:96.0/255.0 alpha:_alpha_])
//Accent color (5)
#define COLOR_ACCENT(_alpha_) ([UIColor colorWithRed:83.0/255.0 green:158.0/255.0 blue:60.0/255.0 alpha:_alpha_])
//Text color (6)
#define COLOR_TEXT(_alpha_) ([UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:_alpha_])
//Stroke color (7)
#define COLOR_STROKE(_alpha_) ([UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:_alpha_])
//List background color (8)
#define COLOR_LIST_BACKGROUND(_alpha_) ([UIColor colorWithRed:27.0/255.0 green:45.0/255.0 blue:65.0/255.0 alpha:_alpha_])
//List item color (9)
#define COLOR_LIST_ITEM(_alpha_) ([UIColor colorWithRed:56.0/255.0 green:68.0/255.0 blue:82.0/255.0 alpha:_alpha_])
//Neutral color (10)
#define COLOR_NEUTRAL_BACKGROUND(_alpha_) ([UIColor colorWithRed:224.0/255.0 green:226.0/255.0 blue:225.0/255.0 alpha:_alpha_])
//Neutral text background color (11)
#define COLOR_NEUTRAL_TEXT(_alpha_) ([UIColor colorWithRed:21.0/255.0 green:39.0/255.0 blue:61.0/255.0 alpha:_alpha_])
//Text color (12)
#define COLOR_NEUTRAL_STROKE(_alpha_) ([UIColor colorWithRed:162.0/255.0 green:164.0/255.0 blue:163.0/255.0 alpha:_alpha_])
//Text color (13)
#define COLOR_NEUTRAL_LIST(_alpha_) ([UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:_alpha_])
//Text color (14)
#define COLOR_NEUTRAL_LIST_ITEM(_alpha_) ([UIColor colorWithRed:226.0/255.0 green:226.0/255.0 blue:226.0/255.0 alpha:_alpha_])
//Text color (15)
#define COLOR_NAVIGATION(_alpha_) ([UIColor colorWithRed:28.0/255.0 green:56.0/255.0 blue:79.0/255.0 alpha:_alpha_])
//Footer color (16)
#define COLOR_FOOTER(_alpha_) ([UIColor colorWithRed:41.0/255.0 green:66.0/255.0 blue:96.0/255.0 alpha:_alpha_])
//Text color (17)
#define COLOR_TAB_SELECTION(_alpha_) ([UIColor colorWithRed:40.0/255.0 green:64.0/255.0 blue:96.0/255.0 alpha:_alpha_])
//Dots background color (18)
#define COLOR_STEPS_SELECTION(_alpha_) ([UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:_alpha_])
//Backgroung color (19)
#define COLOR_LOGIN_BOX(_alpha_) ([UIColor colorWithRed:74.0/255.0 green:94.0/255.0 blue:121.0/255.0 alpha:_alpha_])
//Backgroun color (20)
#define COLOR_STATUS_BG(_alpha_) ([UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:_alpha_])

//Unsorted color
#define COLOR_UNSORTED ([UIColor colorWithRed:158.0/255.0 green:15.0/255.0 blue:30.0/255.0 alpha:1.0])

static const CGFloat kDefaultAlpha = 1.0f;

/*  FONTS                               */
static NSString* const kFontNameRegular = @"HelveticaNeue";
static NSString* const kFontNameMedium = @"HelveticaNeue-Medium";
static NSString* const kFontNameLight = @"HelveticaNeue-Light";
static NSString* const kFontNameBold = @"HelveticaNeue-Bold";
static NSString* const kFontNameItalic = @"HelveticaNeue-Italic";

@implementation MTTheme

//Alpha colors
-(UIColor *)getPrimaryColorWithAlpha:(CGFloat)alpha
{
    return COLOR_PRIMARY(alpha);
}

-(UIColor *)getPrimaryLightColorWithAlpha:(CGFloat)alpha
{
    return COLOR_PRIMARY_LIGHT(alpha);
}

-(UIColor *)getTextColorWithAlpha:(CGFloat)alpha
{
    return COLOR_TEXT(alpha);
}

-(void)setPrimaryColorLightWithAlpha:(CGFloat)alpha toView:(UIView *)view
{
    [view setBackgroundColor:COLOR_PRIMARY_LIGHT(alpha)];
}

//Non alpha colors
-(void)setPrimaryColorToView:(UIView *)view
{
    [view setBackgroundColor:COLOR_PRIMARY(kDefaultAlpha)];
}

-(void)setAccentColorToView:(UIView *)view
{
    [view setBackgroundColor:COLOR_ACCENT(kDefaultAlpha)];
}

-(void)setLoginBoxColorToView:(UIView *)view
{
    [view setBackgroundColor:COLOR_LOGIN_BOX(kDefaultAlpha)];
}

-(UIColor *)getBackgroundColor
{
    return COLOR_BACKGROUND(kDefaultAlpha);
}

-(UIColor*)getPrimaryColor
{
    return COLOR_PRIMARY(kDefaultAlpha);
}

-(UIColor *)getPrimaryLightColor
{
    return COLOR_PRIMARY_LIGHT(kDefaultAlpha);
}

-(UIColor *)getSecondaryColor
{
    return COLOR_SECONDARY(kDefaultAlpha);
}

-(UIColor *)getSecondaryColorWithAlpha:(CGFloat)alpha
{
    return COLOR_SECONDARY(alpha);
}

-(UIColor *)getAccentColor
{
    return COLOR_ACCENT(kDefaultAlpha);
}

-(UIColor *)getTextColor
{
    return COLOR_TEXT(kDefaultAlpha);
}

-(UIColor *)getSceneRuleLogicBackground
{
    return COLOR_PRIMARY_LIGHT(kDefaultAlpha);
}

-(UIColor*)getSplashScreenTextColor
{
    return COLOR_TEXT(kDefaultAlpha);
}

-(UIColor *)getNeutralBackgroundColor
{
    return COLOR_NEUTRAL_BACKGROUND(kDefaultAlpha);
}

-(UIColor *)getNeutralTextColor
{
    return COLOR_NEUTRAL_TEXT(kDefaultAlpha);
}

-(UIColor *)getUnsortedButtonColor
{
    return COLOR_UNSORTED;
}

-(UIColor *)getFailedColor{
    return COLOR_UNSORTED;
}

-(UIColor*)getListItemColor
{
    return COLOR_LIST_ITEM(kDefaultAlpha);
}

-(UIColor*)getNavigationBarColor
{
    if(IS_IPHONE) {
        return COLOR_NAVIGATION(kDefaultAlpha);
    } else {
        return COLOR_STATUS_BG(kDefaultAlpha);
    }
}

-(UIColor*)getListBackgroundColor
{
    return COLOR_LIST_BACKGROUND(kDefaultAlpha);
}

-(UIColor*)getNeutralListItemColor
{
    return COLOR_NEUTRAL_LIST_ITEM(kDefaultAlpha);
}

-(UIColor*)getNeutralListColor
{
    return COLOR_NEUTRAL_LIST(kDefaultAlpha);
}

-(UIColor*)getStrokeColor
{
    return COLOR_STROKE(kDefaultAlpha);
}

-(UIColor *)getNeutralStrokeColor
{
    return COLOR_NEUTRAL_STROKE(kDefaultAlpha);
}

- (void)setPrimaryColorWithAlpha:(CGFloat)alpha toView:(UIView *)view
{
    [view setBackgroundColor:COLOR_PRIMARY(alpha)];
}

- (UIColor*)getFooterColor
{
    return COLOR_FOOTER(kDefaultAlpha);

}
- (UIColor*)getTabSectionColor
{
    return COLOR_TAB_SELECTION(kDefaultAlpha);
}
- (NSArray*)getPrimaryColors
{
    return [NSArray arrayWithObjects:(id)COLOR_PRIMARY(kDefaultAlpha).CGColor, (id)COLOR_PRIMARY(kDefaultAlpha).CGColor, nil];
}

- (UIColor*)getStepsSelectionColor
{
    return COLOR_STEPS_SELECTION(kDefaultAlpha);
}

- (UIColor*)getStatusBg
{
    return COLOR_STATUS_BG(kDefaultAlpha);
}

- (void)setStatusBgWithAlpha:(CGFloat)alpha toView:(UIView *)view
{
    [view setBackgroundColor:COLOR_STATUS_BG(alpha)];
}

- (void)setPrimaryColorLightToView:(UIView *)view
{
    [view setBackgroundColor:COLOR_PRIMARY_LIGHT(kDefaultAlpha)];
}

- (void)setStatusBgToView:(UIView *)view
{
    [view setBackgroundColor:COLOR_STATUS_BG(kDefaultAlpha)];
}

- (UIColor*)getQuickControlTextColor
{
    return COLOR_ACCENT(kDefaultAlpha);
}

-(NSDictionary *)loadFontParametersDictionary
{
    return @{
             OCFontStyleRegular : kFontNameRegular,
             OCFontStyleLight : kFontNameLight,
             OCFontStyleBold : kFontNameBold,
             OCFontStyleMedium : kFontNameMedium,
             OCFontStyleItalic : kFontNameItalic
             };
}

@end
