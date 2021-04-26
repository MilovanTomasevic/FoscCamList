//
//  MTButton.h
//  MTcams
//
//  Created by Milovan Tomasevic on 09/10/2017.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTButton : NSObject

/*!
 @brief Create custom back button for navigationBar
 @param inverted Colors if YES invert default color for arrow and text of back button
 @return UIButton* to be used in navigationBar
 */
+ (UIButton *)createCustomBackButton:(BOOL)inverted;

/*!
 @brief Create button for dialogs
 @discussion Create button for dialog with default height, border, font and colors.
 Frame width depend of given text lenght, position is set to 0,0.
 @param btnText Text to be shown on button
 @return UIButton* to be used in dialogs
 */
+ (UIButton *)createDialogButton:(NSString*)btnText;

/*!
 @brief Create button for OCiPhRollerShutterGroupView
 @return UIButton* to be used in OCiPhRollerShutterGroupView
 */
+ (UIButton *)createRollerFixButton:(NSString*)imgName;


/*!
 @brief Create button for navigation Bar
 @discussion Create button for navigation bar with default height, border, font and colors.
 Frame width depend of given text lenght, position is set to 0,0.
 @return UIButton* to be used in navigation bar
 */
+ (UIButton *)createNavBarButton:(NSString*)btnText;

/*!
 @brief Create unsorted devices button
 @discussion Create unsorted devices button for IPhone or IPad with given frame and dev number
 @param numOfUnsorted Number of unsorted devices
 @frame (CGRect)frame, frame of button
 @return UIButton* to be used belowe dev by loc or by type lists
 */
+ (UIButton *)createUnsortedDevBtn:(int)numOfUnsorted withFrame:(CGRect)frame;

/*!
 @brief Create  button for navigation Bar
 @discussion Create filter button for navigation bar with default height, border, font and colors
 and down arrow on right side. Frame width depend of given text lenght, position is set to 0,0.
 @return UIButton* to be used in navigation bar
 */
+ (UIButton *)createFilterBtn:(NSString*)title;

/*!
 @brief Create gateway button for Scene trigger and device add screens
 @discussion Create gateway button for Scene trigger and device add screens with default height, border,
 font and colors, and image with given frame width and 0,0 position.
 @param yPos Y position of button frame
 @param frameWidth Width of button frame
 @param gwName Title of button
 @return UIButton* to be used in Scene trigger and device add screens
 */
+ (UIButton *)createGWSceneButton:(int)yPos frameWidth:(int)frameWidth withName:(NSString*)gwName;

/*!
 @brief Create gateway button for IPhone DevByLoc or DevByType lists
 @discussion Create gateway button for IPhone DevByLoc or DevByType lists with default height, border,
 font, colors and images with give frame width and gw name.
 @param frameWidth Width of button frame
 @param gwName Title of button
 @return UIButton* to be used in navigation bar
 */
+ (UIButton *)createGWButton:(int)frameWidth withName:(NSString*)gwName;

/*! 
 
 */
+ (UIButton *)createHelpButtonForAdvancedScenes;


/*!
 @brief Create button with the down arrow
 @discussion Create button for dialog with default height, border, font and colors.
 Frame width depend of given text lenght, position is set to 0,0.
 @param title Text to be shown on button
 @param frame (CGRect)frame, frame of button
 @return UIButton*
 */
+(UIButton*)customizeButtonWithArrow:(NSString*)title withFrame:(CGRect)frame;

+(UIButton*) customizeBarButtonWithImageName:(NSString*)imageName;

@end
