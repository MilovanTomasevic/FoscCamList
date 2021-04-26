//
//  MTSupport.h
//  MTcams
//
//  Created by Milovan Tomasevic on 05/10/2017.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTSupport : NSObject



/*!
 @brief replaces multiplied white spaces with one from string
 @param string string that we want to replace all multiplied white spaces in with one space
 @return NSString*
 */
+(NSString *)replaceMultipliedSpacesWithOneFromString: (NSString *) string;

/*!
 @brief This method checks if email is in correct format
 @return YES if format is valid
 */
+(BOOL)validateEmail:(NSString *)candidate;

/*!
 @brief Add numeric keyboard with done btn, for IPhone - on click it will fire given selector
 @param textField - input field
 @param doneSelector - selector to be fired when done is clicked, IPHONE ONLY!
 @param object - controller
 */
+(void)setNumericKeyboardWithDone: (UITextField*)textField withDoneSelector: (SEL)doneSelector withObject:(id)object;

/*!
 @brief Validate of password
 @discussion Get is password valid
 @param password - password for validation
 @return YES is password valid otherwise return NO
 */
+(BOOL)isPasswordFormatValid:(NSString *)password;


///*!
// @brief Next button ui custimization
// @discussion This method will be called from scene master, crate new account
// @param nextButton - UIButton
// To use it, simply call [OCCommon nextBtnCustimization:nextButton];
// */
//+(void)nextBtnCustimization:(UIButton *)nextButton;
/*!
 @brief Scale image
 @discussion Scale image
 @param image - UIImage, newSize - CGSize
 */
+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize;

//The function returns the current wifi network (SSID) to which the device is connected
+(NSString *)getCurrentWifiSSID;


/*!
 @brief valid PIN number is exactly 4 digits length and use only digits 0-9
 @param pinNumber value to be validate
 @return YES if pinNumber is valid
 */
+(BOOL)isValidPinNumber:(NSString*)pinNumber;


/*!
 @brief Method to move the view up/down whenever the keyboard is shown/dismissed
 @param movedUp YES for move up No for move down
 @param distance Movement dostance for sprecified view
 */
+(void)setViewMovedUp:(BOOL)movedUp forView:(UIView *)view forDistance:(NSInteger) distance;

+ (UIImage *)imageByApplyingAlpha:(CGFloat) alpha image:(UIImage *)img;
+ (UIImage *)filledImageFrom:(UIImage *)source withColor:(UIColor *)color;
+ (UISwitch *)switchCustom:(UISwitch *)newSwich;
+ (UISlider *)sliderCustom:(UISlider *)newSlider;
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;
+ (void)addNavigationTopBorderWithColor:(UIColor *)color toView:(UIView *)view;

@end
