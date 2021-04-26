//
//  MTTextField.h
//  MTcams
//
//  Created by Milovan Tomasevic on 06/10/2017.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTTextField : UITextField <UITextFieldDelegate>

typedef NS_ENUM(NSInteger, MTTextFieldStyle) {
    OLTextFieldStyleLight,
    OLTextFieldStyleLightBlue,
};

@property (nonatomic, strong) UIButton *rightButton;

-(id)initWithFrame:(CGRect)frame andStyle:(MTTextFieldStyle)style;
-(void)addLeftImage:(UIImage *)image;
-(void)addLeftPadding;
-(void)textFieldIsEnabled:(BOOL)enabled;
-(void)customizeField:(UITextField*)field withView:(UIView*)view andPlaceholder:(NSString*)placeholder;
-(void)addRightPasswordButton;
-(void)addLeftIcon:(UITextField*)field withImage:(NSString *)imageName;
-(void)checkFieldBackground:(UITextField*)field;
@end
