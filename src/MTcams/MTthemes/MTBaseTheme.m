//
//  Theme
//  MTcams
//
//  Created by Milovan Tomasevic on 11/10/2017.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "MTBaseTheme.h"
NSString* const OCFontStyleRegular = @"OCFontStyleRegular";
NSString* const OCFontStyleLight = @"OCFontStyleLight";
NSString* const OCFontStyleBold = @"OCFontStyleBold";
NSString* const OCFontStyleMedium = @"OCFontStyleMedium";
NSString* const OCFontStyleItalic = @"OCFontStyleItalic";
//*****************************************

//Font sizes section
//******
//iPhone specific
CGFloat const kFontSizeDefIPhone = 17;
CGFloat const kFontSizeMaxIPhone = 37;
//iPad specific
CGFloat const kFontSizeDefIPad = 24;
CGFloat const kFontSizeMaxIPad = 44;

CGFloat const kFontSizeBtnScenesiPad = 17;
CGFloat const kFontSizeBtnScenesiPhone = 12;

CGFloat const kFontSizeMinimum = 15;
CGFloat const kFontSizeMedium = 20;

@implementation MTBaseTheme

- (instancetype)init
{
    self = [super init];
    if (self) {
        _currentFontParams = [self loadFontParametersDictionary];
        if (IS_IPAD) {
            _fontSizeDefault = kFontSizeDefIPad;
            _fontSizeMaximum = kFontSizeMaxIPad;
        } else {
            _fontSizeDefault = kFontSizeDefIPhone;
            _fontSizeMaximum = kFontSizeMaxIPhone;
        }
    }
    return self;
}

//Alpha colors
-(UIColor*)getTextColorWithAlpha:(CGFloat)alpha
{
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil];
}

-(void)setPrimaryColorDarkWithAlpha:(CGFloat)alpha toView:(UIView *)view
{
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil];
}

-(UIColor*)getPrimaryLightColor:(CGFloat)alpha
{
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil];
}

-(UIColor *)getPrimaryColorWithAlpha:(CGFloat)alpha
{
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil];
}

-(UIColor *)getPrimaryLightColorWithAlpha:(CGFloat)alpha
{
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil];
}

-(void)setPrimaryColorLightWithAlpha:(CGFloat)alpha toView:(UIView *)view
{
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil];
}

//Non alpha colors

-(UIColor *)getBackgroundColor
{
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil];
}

-(UIColor *)getListBackgroundColor
{
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil];
}

-(UIColor*)getAccentColor
{
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil];
}

-(UIColor *)getNeutralStrokeColor
{
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil];
}

-(UIColor *)getNavigationBarColor
{
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil];
}

-(UIColor *)getListItemColor
{
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil];
}

-(UIColor *)getBackground
{
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil];
}

-(UIColor *)getSecondaryColor
{
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil];
}

-(UIColor *)getSecondaryColorWithAlpha:(CGFloat)alpha
{
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil];
}

-(UIColor *)getTextColor
{
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil];
}

-(UIColor *)getPrimaryLightColor
{
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil];
}

-(UIColor *)getAccentColorWithAlpha:(CGFloat)alpha{
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil];
}

-(UIColor*)getSceneRuleLogicBackground;
{
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil];
}

-(UIColor*)getSplashScreenTextColor
{
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil];
}

-(UIColor *)getNeutralTextColor
{
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil];
}

-(UIColor *)getNeutralBackgroundColor
{
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil];
}

-(UIColor *)getUnsortedButtonColor{
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil];
}

-(UIColor *)getFailedColor{
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil];
}

-(UIColor *)getPrimaryColor
{
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil];
}

-(void)setAccentColorToView:(UIView *)view
{
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil];
}

-(void)setLoginBoxColorToView:(UIView *)view
{
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil];
}

-(void)setPrimaryColorToView:(UIView *)view
{
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil];
}

-(UIColor *)getNeutralListColor
{
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil];
}

-(UIColor *)getStrokeColor
{
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil];
}

-(UIColor *)getNeutralListItemColor
{
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil];
}

- (void)setPrimaryColorWithAlpha:(CGFloat)alpha toView:(UIView *)view
{
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil];
}

- (UIColor *)getFooterColor
{
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil];

}

-(UIColor *)getTabSectionColor
{
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil];
}

-(NSArray *)getPrimaryColors
{
  @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil];
}

-(UIColor *)getStepsSelectionColor
{
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil];
}

-(UIColor *)getStatusBg
{
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil];
}

- (void)setStatusBgWithAlpha:(CGFloat)alpha toView:(UIView *)view
{
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil];
}

- (void)setPrimaryColorLightToView:(UIView *)view
{
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil];
}

- (void)setStatusBgToView:(UIView *)view
{
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil];
}

- (UIColor*)getQuickControlTextColor
{
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil];
}

#pragma mark - Font methods



- (UIFont*)fontWithStyleName:(NSString*)styleName size:(CGFloat)fontSize
{
    NSString* fontName = [self.currentFontParams objectForKey:styleName];
    if (!fontName) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:[NSString stringWithFormat:@"Unsupported font style name"]
                                     userInfo:nil];
    }
    return [UIFont fontWithName:fontName size:fontSize];
}

- (NSDictionary*)loadFontParametersDictionary
{
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil];
}

@end
